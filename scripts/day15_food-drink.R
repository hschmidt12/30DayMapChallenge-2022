# 30 Day Map Challenge - 2022
# day 15 - food/drink
# Helen Schmidt

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(tidyverse)
library(showtext)
library(maps)
library(showtext)

# read in coffee consumption data
df <- read.csv("./data/disappearance.csv") 
# define a coffee color palette
colors <- c("#DFB78C","#AB6832","#49281A")

# load fonts for title
font_add_google("Berkshire Swash", "swash")
font_add_google("Nunito", "nunito")
# automatically use showtext when needed
showtext_auto()

# get world map
world <- map_data('world')
# make a list of Scandinavian & Baltic countries
list <- c("Finland","Norway","Sweden","Denmark","Estonia","Latvia","Lithuania")
# filter out my selected countries from world map
countries <- filter(world, region %in% list)

# reshape data into long format
df <- pivot_longer(df,
                   cols = X1990:X2018,
                   names_to = "Year",
                   values_to = "Consumption")
df <- filter(df, region %in% list)

# define a new data frame for my combined map and coffee data
all.years <- data.frame()

# loop through all years to merge coffee data with world map
years <- unique(df$Year)              # get a list of all unique years
for (i in 1:length(years)) {          # loop through the number of years
  year <- years[i]                    # define current year
  data <- subset(df, df$Year == year) # subset the coffee data frame
  
  # Match coffee consumption data with map
  countries$coffee_consumption <- data$Consumption[match(countries$region,data$region)]
  # make group and region a factor
  countries$group <- as.factor(countries$group)
  countries$region <- as.factor(countries$region)
  # save the year information in a new column
  countries$year <- year
  # combine all years together
  all.years <- rbind(all.years,countries)
}

# remove the X placeholder at the front of each year value
all.years$year <- substring(all.years$year, 2)
# make year numeric
all.years$year <- as.numeric(all.years$year)
# subset to only years that have data for each country
all.years <- subset(all.years, !is.na(coffee_consumption))
# calculate average per year
all.years <- all.years %>%
  group_by(region) %>%
  mutate(avg.consumption = mean(coffee_consumption))

ggplot() + 
  # labs(title = "Coffee Consumption",
  #      subtitle = "Average consumption of coffee measured in thousands of 60-kg bags of coffee.") +
  geom_polygon(data = all.years, aes(x=long, y=lat, group = group, fill = avg.consumption), 
                   color = "#faf0dc", size = 0.3) +
  annotate(geom = "text",
           label = "Coffee Consumption",
           x = -Inf, y = Inf, hjust = -0.1, vjust = 3.4,
           family = "swash", size = 10, fontface = 2,
           color = colors[3]) +
  annotate(geom = "text",
           label = "average consumption of coffee measured",
           x = -Inf, y = Inf, hjust = -0.12, vjust = 13,
           family = "nunito", size = 4, fontface = 1,
           color = colors[3]) +
  annotate(geom = "text",
           label = "in thousands of 60-kg bags of coffee",
           x = -Inf, y = Inf, hjust = -0.14, vjust = 14.5,
           family = "nunito", size = 4, fontface = 1,
           color = colors[3]) +
  annotate(geom = "text",
           label = "data: international coffee organization",
           x = Inf, y = -Inf, vjust = -0.25, hjust = 2,
           family = "nunito", size = 2.5, fontface = 1,
           color = colors[3]) +
  coord_fixed(1.5) +
  theme_void() +
  scale_color_gradient(name = "", low = colors[1], high = colors[3]) +
  scale_fill_gradient(name = "", low = colors[1], high = colors[3],
                      breaks = c(100,400,700,1000,1300),
                      limits = c(100,1315)) + 
  theme(legend.position = "bottom",
        legend.key.height = unit(0.1, "in"),
        legend.key.width = unit(0.75, "in"),
        legend.text = element_text(size = 10, color = colors[3], family = "swash"),
        plot.background = element_rect(fill = "#faf0dc", color = NA))

# save!
ggsave(filename = "./maps/day15_food-drink.jpeg",
       width = 5,
       height = 6,
       units = "in",
       dpi = 500,
       device = "jpeg")
