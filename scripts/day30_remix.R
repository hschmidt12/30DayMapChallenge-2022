# 30 Day Map Challenge - 2022
# day 30 - remix
# Helen Schmidt

# Remixing day 6 - network; Boston MBTA Rapid Transit Rail Network using Open Street Map

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

library(tidyverse)         # ultimate tidyverse collection
library(sf)                # simple features
library(RColorBrewer)      # palette brewer
library(showtext)          # fonts
library(osmdata)           # open street map

# make mbta color palette (blue, green, orange, red)
colors <- c("#003DA5","#00843D","#ED8B00","#DA291C")

# load fonts for title
font_add_google("Signika Negative", "signika")
# automatically use showtext when needed
showtext_auto()

coord <- c(-71.26675120549528, 42.198518171013326, 
           -70.9563874502486, 42.44018681789687)

# get MBTA network area bounding box
bb <- getbb(place_name = "Boston, United States")
# get MBTA routes 
redline <- opq(bbox = bb, timeout = 120) %>%
  add_osm_feature(key = "route", value = c("subway", "light_rail", "tram")) %>%
  add_osm_feature(key = "name", value = "Red Line", value_exact = F) %>%
  osmdata_sf()
orangeline <- opq(bbox = bb, timeout = 120) %>%
  add_osm_feature(key = "route", value = c("subway", "light_rail", "tram")) %>%
  add_osm_feature(key = "name", value = "Orange Line", value_exact = F) %>%
  osmdata_sf()
greenline <- opq(bbox = bb, timeout = 120) %>%
  add_osm_feature(key = "route", value = c("subway", "light_rail", "tram")) %>%
  add_osm_feature(key = "name", value = "Green Line", value_exact = F) %>%
  osmdata_sf()
blueline <- opq(bbox = bb, timeout = 120) %>%
  add_osm_feature(key = "route", value = c("subway", "light_rail", "tram")) %>%
  add_osm_feature(key = "name", value = "Blue Line", value_exact = F) %>%
  osmdata_sf()
# get Boston roads
roads <- opq(bbox = coord, timeout = 120) %>%
  add_osm_feature(key = "highway") %>%
  osmdata_sf()

ggplot() +
  geom_sf(data = roads$osm_lines, size = 0.05, color = "white") +
  geom_sf(data = redline$osm_lines, size = 1, color = colors[4]) +
  geom_sf(data = orangeline$osm_lines, size = 1, color = colors[3]) +
  geom_sf(data = greenline$osm_lines, size = 1, color = colors[2]) +
  geom_sf(data = blueline$osm_lines, size = 1, color = colors[1]) +
  theme_void() +
  coord_sf(default_crs = sf::st_crs(4326), xlim = c(-71.25, -70.97), ylim = c(42.21, 42.43)) +
  labs(caption = "Boston | MBTA Subway Network") +
  theme(plot.background = element_rect(fill = '#65737E', color = NA),
        panel.background = element_rect(fill = '#65737E', color = NA),
        plot.caption = element_text(hjust = 0.5, vjust = 1.2, color = "white", 
                                    size = 25, family = "signika"))

# save plot
ggsave(filename = "./maps/day30_remix.jpeg",
       width = 5,
       height = 5,
       units = "in",
       dpi = 600,
       device = "jpeg")
