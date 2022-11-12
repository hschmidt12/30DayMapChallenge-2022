# 30 Day Map Challenge - 2022
# day 9 - space
# Helen Schmidt

# Population in US cities shown as lights from space

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(sf)
library(maps)
library(ggplot2)
library(dplyr)
library(showtext)
library(tigris)        # get census geographies

# colors (dark blue, blue, yellow, white)
colors <- c("#03101b", "#0f2443", "#d7ae33", "#fef9ef")

# load city locations & population
city <- read_sf("./data/USA_Major_Cities/USA_Major_Cities.shp") %>%
  select(NAME, POPULATION, geometry)
# shift city geometry too
city <- city %>%
  shift_geometry()
# separate city geometry into longitude and latitude
city$LonLat <- stringr::str_remove_all(city$geometry, "[c()]")
city <- city %>% 
  tidyr::separate(LonLat, c("lon","lat"), sep = "(,)")
city$lon <- as.numeric(city$lon)
city$lat <- as.numeric(city$lat)
# make a new population column to vary point size
city$pop.new <- city$POPULATION/2000000
city$pop.new <- as.numeric(city$pop.new)

# load usa map
states <- tigris::states(class = "sf", cb = TRUE) %>%
  shift_geometry()
# remove only 50 states + DC (alaska and hawaii shifted earlier)
states <- states %>% 
  filter(GEOID < 60)

# plot!
ggplot() + 
  geom_sf(data = states$geometry, color = colors[1], fill = colors[2]) +
  geom_point(data = city, aes(x = lon, y = lat, size = pop.new, color = pop.new), shape = 8, alpha = 0.8) +
  scale_color_gradient(low = colors[3], high = colors[4]) +
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = colors[1], color = colors[1]),
        panel.background = element_rect(fill = colors[1], color = colors[1]))

# save plot
ggsave(filename = "./maps/day9_space.jpeg",
       width = 5,
       height = 3,
       units = "in",
       dpi = 400,
       device = "jpeg")
