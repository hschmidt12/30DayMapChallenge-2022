# 30 Day Map Challenge - 2022
# day 11 - color friday: red
# Helen Schmidt

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(sf)
library(maps)
library(tidyverse)
library(showtext)
library(nationalparkcolors)
library(purrr)
library(geosphere)
library(gganimate)       # animate plots
library(gifski)          # save animations as gifs

# load fonts for title
font_add_google("Righteous", "righteous")
# automatically use showtext when needed
showtext_auto()

# get world map
world <- map_data("world") %>% 
  select(long, lat, group, id = region) %>%
  subset(id != "Antarctica")

# load blood type data
blood <- read.csv("./data/blood-country.csv")
names(blood)[1] <- "id"
# define list of blood types
types <- c("oPos", "aPos", "bPos", "abPos", "oNeg", "aNeg", "bNeg", "abNeg")
names <- c("O Positive (%)", "A Positive (%)", "B Positive (%)", "AB Positive (%)",
           "O Negative (%)", "A Negative (%)", "B Negative (%)", "AB Negative (%)")

for (i in length(types)) {
  current.type = types[i]  # get current type in dataframe
  current.name <- names[i] # get name for plotting legend title
  this.plot <- blood[,c(1,(i+1))]
  # merge world map with blood data
  this.plot <- merge(this.plot, world, by = "id", all.y = T)
  # plot!
  plot <- ggplot() + 
    ggtitle("Blood Type and Rh Factor Frequencies by Country") +
    geom_map(data = this.plot, map = world, 
             aes(long, lat, map_id = id, fill = this.plot[,2]),
             color = "black", size = 0.1) +
    theme_void() +
    annotate(geom = "text",
             label = "Data: World Population Review",
             y = Inf, x = Inf, hjust = 1.3, vjust = 1.5,
             family = "righteous", color = "#8C0D07", size = 2) +
    scale_fill_gradient(low = "#Faa39e", high = "#8c0d07", na.value="gray80") +
    coord_fixed(1.3) +
    guides(fill = guide_colorbar(title.position = "top", title = current.name,
                                 title.hjust = 0.5, title.vjust = -0.05)) +
    theme(plot.title = element_text(family = "righteous", color = "#8C0D07", 
                                    size = 30, hjust = 0.5),
          legend.title = element_text(family = "righteous", color = "#8C0D07",
                                      size = 12),
          plot.background = element_rect(fill = "#f5efe8", color = "#f5efe8"),
          panel.background = element_rect(fill = "#f5efe8", color = "#f5efe8"),
          legend.position = "bottom",
          legend.margin = margin(0,0,15,0),
          legend.key.height = unit(0.1, "in"), 
          legend.key.width = unit(1, "in"),
          legend.text = element_text(size = 6, color = "#8C0D07", family = "righteous"))
  # save plot
  filename <- paste0("./maps/day11_blood/day11_colorfriday_red_", current.type, ".jpeg", sep = "")
  ggsave(filename = filename,
         width = 10,
         height = 8,
         units = "in",
         dpi = 800,
         device = "jpeg")

}
