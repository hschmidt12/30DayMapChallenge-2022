# 30 Day Map Challenge - 2022
# day 14 - hexagons
# Helen Schmidt

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(tidyverse)
library(geojsonio)
library(RColorBrewer)
library(rgdal)
library(broom)
library(rgeos)
library(NatParksPalettes)
library(showtext)

# define colors
colors <- c("#DDFFF7", "#93E1D8", "#FFA69E", "#AA4465", "#462255")

# load fonts for title
font_add_google("Turret Road", "turret")
# automatically use showtext when needed
showtext_auto()

# load search data
search <- read.csv('./data/geoMap.csv')

# get hexagon map data
hex <- geojson_read('./data/us_states_hexgrid.geojson', what = "sp")
hex@data = hex@data %>%
  mutate(google_name = gsub(" \\(United States\\)", "", google_name))
# fortify the data to be able to show it with ggplot
hex@data = hex@data %>% mutate(google_name = gsub(" \\(United States\\)", "", google_name))
hex_fortified <- tidy(hex, region = "google_name")
# calculate centroid of each hexagon 
centers <- cbind.data.frame(data.frame(gCentroid(hex, byid = T), id = hex@data$iso3166_2))

# Merge geospatial and numerical information
hex_fortified <- hex_fortified %>%
  left_join(. , search, by="id")

# create search popularity bins
hex_fortified$bin <- ifelse(hex_fortified$searchPopularity >= 95, 6,
                     ifelse(hex_fortified$searchPopularity >= 85, 5,
                     ifelse(hex_fortified$searchPopularity >= 80, 4,
                     ifelse(hex_fortified$searchPopularity >= 75, 3,
                     ifelse(hex_fortified$searchPopularity >= 70, 2, 1)))))

# plot
ggplot() +
  geom_polygon(data = hex_fortified, aes(x = long, y = lat, 
                                          group = group, fill = bin) , size=0, alpha=0.9) +
  geom_text(data=centers, aes(x=x, y=y, label=id), color="white", size=8, alpha=0.6) +
  theme_void() +
  coord_map() +
  ggtitle("United States Google Search Interest in 'Hexagon'") +
  scale_fill_gradientn(colors = natparks.pals("CapitolReef", direction = -1),
                       limits = c(1,6),
                       breaks = c(1,6),
                       labels=c('least\npopular','most\npopular')) +
  #scale_fill_natparks_c(name = "CapitolReef", direction = -1) +
  theme(legend.position = "bottom",
        text = element_text(color = "#22211d"),
        plot.background = element_rect(fill = "#f5f5f2", color = NA), 
        panel.background = element_rect(fill = "#f5f5f2", color = NA), 
        plot.title = element_text(size= 24, hjust=0.5, color = "#4e4d47", 
                                  family = "turret", face = "bold",
                              margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
        legend.margin = margin(0,0,3,0),
        legend.key.height = unit(0.1, "in"), 
        legend.key.width = unit(0.75, "in"),
        legend.text = element_text(size = 14, color = "#4e4d47", family = "turret"),
        legend.title = element_blank())

# save
ggsave(filename = "./maps/day14_hexagons.jpeg",
       width = 10,
       height = 8,
       units = "in",
       dpi = 800,
       device = "jpeg")


