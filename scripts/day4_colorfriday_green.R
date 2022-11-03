# 30 Day Map Challenge - 2022
# day 4 - color friday: green
# Helen Schmidt

# Heritage trees of Ireland dataset published by the National Biodiversity
# Data Centre and accessed via data.gov.ie (survey conducted in 2009). 
# These trees are exclusively native to Ireland.

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(maps)
library(tidyverse)
library(showtext)
library(MetBrewer)
library(geosphere)
library(rgdal)

# load fonts for title
font_add_google("Mali", "mali")
# automatically use showtext when needed
showtext_auto()

# get colors
colors <- met.brewer(name = "VanGogh3", n = 8)
palette <- c(colors[1], colors[2], colors[3], colors[4], colors[5], colors[6], colors[8])

# get ireland map
ireland <- map_data("world", "Ireland") %>% 
  select(lon = long, lat)

# get tree data
trees <- read.csv("./data/HeritageTreesOfIreland.csv")
# only include trees that are "standing alive"
trees <- subset(trees, Condition.of.tree == "Standing alive")
# remove trees where age isn't known
trees <- subset(trees, Age.Range != "Not known")
# add nicer age column
trees$age[trees$Age.Range == "0 - 50 years"] <- 0
trees$age[trees$Age.Range == "50 - 100 years"] <- 50
trees$age[trees$Age.Range == "100 - 150 years"] <- 100
trees$age[trees$Age.Range == "150 - 200 years"] <- 150
trees$age[trees$Age.Range == "200 - 300 years"] <- 200
trees$age[trees$Age.Range == "300 - 500 years"] <- 300
trees$age[trees$Age.Range == "500 + years"] <- 500

# convert trees east and north Irish grid coordinates to latitude and longitude
trees.longlat <- read.csv("./data/trees.csv")
# Note: the original data set uses Irish grid coordinates which were difficult 
# to convert to longitude and latitude. Be warned if you want to use this data!

# match long and lat with trees data
trees$lon <- trees.longlat$lon[match(trees.longlat$East, trees$East)]
trees$lat <- trees.longlat$lat[match(trees.longlat$North, trees$North)]

# plot
ggplot() + 
  annotate(geom = "text",
           label = "Heritage Trees of Ireland",
           x = -8.2, y = 55.5,
           family = "mali", size = 4, fontface = 2,
           color = colors[7]) +
  geom_polygon(data = ireland, aes(x = lon, y = lat), fill = colors[7]) +
  geom_point(data = trees, size = 1.1, shape = 17,
             aes(x = lon, y = lat, color = age, fill = age)) +
  scale_fill_gradientn(colors = palette, name = "age (years)") +
  scale_color_gradientn(colors = palette, name = "age (years)") +
  theme_void() +
  coord_map() +
  guides(fill = guide_colorbar(title.position = "top", 
                               title.hjust = 0.5, title.vjust = -0.05)) +
  theme(legend.position = "bottom",
        legend.margin = margin(0,0,15,0),
        plot.background = element_rect(fill = "#f5efe8", color = "#f5efe8"),
        panel.background = element_rect(fill = "#f5efe8", color = "#f5efe8"),
        legend.key.height = unit(0.1, "cm"), 
        legend.key.width = unit(0.5, "cm"),
        legend.text = element_text(size = 6, color = colors[7], family = "mali"),
        legend.title = element_text(size = 8, color = colors[7], family = "mali"))

# save plot
ggsave(filename = "./maps/day4_colorfriday_green.jpeg",
       width = 3,
       height = 4,
       units = "in",
       dpi = 400,
       device = "jpeg")
