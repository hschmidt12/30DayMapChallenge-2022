# 30 Day Map Challenge - 2022
# day 23 - movement
# Helen Schmidt

# whale shark movement in gulf of mexico 
# data from movebank (https://www.movebank.org/cms/webapp?gwt_fragment=page=studies,path=study1153270750)

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(sf)
library(tidyverse)
library(showtext)
library(rnaturalearth)
library(rnaturalearthdata)

world <- ne_countries(scale = "medium", returnclass = "sf")

# colors (onyx, grey, yellow, teal, black)
colors <- c("#393e41", "#d3d0cb", "#e2c044", "#587b7f", "#1e2019")

# load fonts for title
font_add_google("Arima Madurai", "arima")
# automatically use showtext when needed
showtext_auto()

# load whale routes shapefile
whale.line <- read_sf("./data/Whale shark movements in Gulf of Mexico/lines.shp")
# adjust whale ID
whale.line$name <- substring(whale.line$name, 1, 5)

# plot
ggplot() +
  geom_sf(data = world, color = colors[5], fill = colors[1]) +
  annotate(geom = "text",
           label = "Whale Sharks in the Gulf of Mexico",
           x = -Inf, y = Inf, vjust = 1.5, hjust = -0.04,
           family = "arima", fontface = 2, size = 12, color = colors[2]) +
  geom_sf(data = whale.line$geometry, aes(color = whale.line$name), alpha = 0.6) +
  coord_sf(xlim = c(-102.15, -80), ylim = c(15, 33.97), expand = FALSE) +
  scale_color_gradient(low = colors[2], high = colors[3]) +
  theme_void() +
  theme(legend.position = "none", 
        plot.background = element_rect(fill = colors[4], color = NA), 
        panel.background = element_rect(fill = colors[4], color = NA))

# save
ggsave(filename = "./maps/day23_movement.jpeg",
       width = 8,
       height = 8,
       units = "in",
       dpi = 700,
       device = "jpeg")
