# 30 Day Map Challenge - 2022
# day 16 - minimal
# Helen Schmidt

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(sf)
library(tidyverse)
library(showtext)
library(osmdata)

# load fonts for title
font_add_google("Domine", "domine")
# automatically use showtext when needed
showtext_auto()

# estonia colors (purple, white, grey, blue)
colors <- c("#c4c1ca", "#eeeae7", "#8f9095", "#197bbd")

coord <- c(24.7312201078326, 59.43134356745493, 
           24.754265646263732, 59.44380362007976)

roads <- opq(bbox = coord) %>%
  add_osm_feature(key = "highway") %>%
  osmdata_sf()

# plot
ggplot() +
  ggtitle("Tallinn, Estonia") +
  geom_sf(data = roads$osm_lines, color = colors[1], size = .3) +
  theme_void() +
  theme(plot.background = element_rect(fill = colors[2], color = NA),
        panel.background = element_rect(fill = colors[2], color = NA),
        plot.title = element_text(family = "domine", color = colors[3], 
                                  size = 26, hjust = 0.5, vjust = -1, face = "bold"))

# save!
ggsave(filename = "./maps/day16_minimal.jpeg",
       width = 5,
       height = 5,
       units = "in",
       dpi = 500,
       device = "jpeg")
