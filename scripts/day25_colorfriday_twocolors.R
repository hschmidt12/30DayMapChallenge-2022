# 30 Day Map Challenge - 2022
# day 25 - color friday: 2 colors
# Helen Schmidt

# green space in singapore

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(sf)
library(tidyverse)
library(showtext)
library(osmdata)

coord <- c(103.59567166979348, 1.1955782010321085, 
           104.09005641858955, 1.4550605421649785)

# load fonts for title
font_add_google("Signika Negative", "signika")
# automatically use showtext when needed
showtext_auto()

# colors (green, blue, light blue)
colors <- c("#499F68", "#0B3948", "#1e99c2")

# load singapore boundary shapefile
sing <- read_sf("./data/stanford-pg798kr1205-shapefile/pg798kr1205.shp")

natural.sing <- opq(bbox = coord) %>%
  add_osm_feature(key = "natural") %>%
  osmdata_sf()

parks.sing <- opq(bbox = coord) %>%
  add_osm_feature(key = "leisure", value = c("park", "dog_park", "nature_reserve", "garden")) %>%
  osmdata_sf()

land.sing <- opq(bbox = coord) %>%
  add_osm_feature(key = "landuse", value = c("conservation", "grass", "orchard", "meadow")) %>%
  osmdata_sf()

# plot
ggplot() +
  geom_sf(data = natural.sing$osm_polygons, color = colors[1], fill = colors[1]) +
  geom_sf(data = sing$geometry, color = colors[3], fill = NA) +
  geom_sf(data = parks.sing$osm_polygons, color = colors[1], fill = colors[1]) +
  geom_sf(data = land.sing$osm_polygons, color = colors[1], fill = colors[1]) +
  theme_void() +
  labs(caption = "Singapore | The Garden City") +
  theme(plot.background = element_rect(fill = colors[2], color = NA),
        panel.background = element_rect(fill = colors[2], color = NA),
        plot.caption = element_text(hjust = 0.5, vjust = 1.5, color = colors[3], 
                                    size = 30, family = "signika"))

# save plot
ggsave(filename = "./maps/day25_colorfriday_twocolors.jpeg",
       width = 7,
       height = 5,
       units = "in",
       dpi = 600,
       device = "jpeg")
