# 30 Day Map Challenge - 2022
# day 8 - open street map
# Helen Schmidt

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(tidyverse)         # ultimate tidyverse collection
library(OpenStreetMap)     # open street map
library(sf)                # simple features
library(raster)            # raster mapping
library(scales)            # scales
library(showtext)          # fonts
library(osmdata)           # work with streets
library(ggmap)
library(rvest)

# load fonts for title
font_add_google("Abril Fatface", "abril")
# automatically use showtext when needed
showtext_auto()

# define colors
# dark blue, grey, light sea green
colors <- c("#233d4d", "#d4d2d5", "#20a39e")
# get big streets
london_big <- getbb("London United Kingdom")%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("motorway", "primary", "motorway_link", "primary_link")) %>%
  osmdata_sf()
# get medium streets
med_streets <- getbb("London United Kingdom")%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("secondary", "tertiary", "secondary_link", "tertiary_link")) %>%
  osmdata_sf()
# get small streets
small_streets <- getbb("London United Kingdom")%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = "road") %>%
  osmdata_sf()
# get rivers
river <- getbb("London United Kingdom")%>%
  opq()%>%
  add_osm_feature(key = "water", value = "river") %>%
  osmdata_sf()

# plot!
ggplot() +
  # add title
  annotate(geom = "text",
           label = "L O N D O N,   U N I T E D   K I N G D O M",
           x = Inf, y = 51.71, hjust = 0.996,
           family = 'abril', fontface = 2, size = 10,
           color = colors[1]) +
  # river
  geom_sf(data = river$osm_polygons,
          inherit.aes = F,
          fill = colors[3]) +
  geom_sf(data = river$osm_multipolygons,
          fill = colors[3],
          inherit.aes = F) +
  geom_sf(data = river$osm_lines,
          inherit.aes = F,
          color = colors[3]) +
  geom_sf(data = river$osm_multilines,
          inherit.aes = F,
          color = colors[3]) +
  # big streets 
  geom_sf(data = london_big$osm_lines,
          inherit.aes = F,
          color = colors[1],
          size = .4,
          alpha = 1) + 
  geom_sf(data = med_streets$osm_lines,
          inherit.aes = F,
          color = colors[1],
          size = .3,
          alpha = 1) +
  geom_sf(data = small_streets$osm_lines,
          inherit.aes = F,
          color = colors[1],
          size = .2,
          alpha = 1) +
  coord_sf(xlim = c(-0.45, 0.31),
           ylim = c(51.3, 51.72),
           expand = F) +
  theme_void() +
  theme(plot.background = element_rect(fill = colors[2], color = colors[2]),
        panel.background = element_rect(fill = colors[2], color = colors[2]))

# save plot
ggsave(filename = "./maps/day8_openstreetmap.jpeg",
       width = 10,
       height = 8,
       units = "in",
       dpi = 800,
       device = "jpeg")
