# 30 Day Map Challenge - 2022
# day 27 - music
# Helen Schmidt

# new orleans venues with live entertainment permits

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

library(tidyverse)         # ultimate tidyverse collection
library(sf)                # simple features
library(RColorBrewer)      # palette brewer
library(showtext)          # fonts
library(biscale)           # bivariate plotting
library(osmdata)           # open street map

# colors - razz jazz (dark blue, light blue, grey, pink, dark pink)
colors <- c("#283044", "#78a1bb", "#ebf5ee", "#ab538b", "#8c325f")

# load fonts for title
font_add_google("Cherry Cream Soda", "cherry")
# automatically use showtext when needed
showtext_auto()

# load new orleans base roads
# https://portal-nolagis.opendata.arcgis.com/datasets/NOLAGIS::road-centerline/explore?location=30.028452%2C-89.936800%2C11.61 
nola <- read_sf("./data/Road_Centerline/Road_Centerline.shp")
# load new orleans live music venues
# https://data.nola.gov/Recreation-and-Culture/Live-Entertainment-Permits/aj8a-ghih 
venue <- read_sf("./data/Live Entertainment Permits/geo_export_299a9ee2-6df8-46c0-8a6f-f430d716c775.shp")

# plot
ggplot() +
  geom_sf(data = nola$geometry, color = colors[3], size = 0.1) +
  geom_sf(data = venue$geometry, color = colors[4], size = 0.9) +
  theme_void() +
  annotate(geom = "text",
           label = "New Orleans, Louisiana",
           x = -90.045, y = 29.885,
           family = "cherry", size = 9, color = colors[5]) +
  annotate(geom = "text",
           label = "live music & entertainment venues",
           x = -90.045, y = 29.872,
           family = "cherry", size = 4, color = colors[5]) +
  annotate(geom = "text",
           label = "data - data.nola.gov",
           x = -90.045, y = 29.866,
           family = "cherry", size = 2, color = colors[1]) +
  coord_sf(default_crs = sf::st_crs(4326), xlim = c(-90.15, -89.94), ylim = c(29.87, 30.07)) +
  theme(plot.background = element_rect(fill = colors[2], color = NA),
        panel.background = element_rect(fill = colors[2], color = NA))

# save
ggsave(filename = "./maps/day27_music.jpeg",
       width = 5,
       height = 5,
       units = "in",
       dpi = 500,
       device = "jpeg")
