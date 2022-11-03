# 30 Day Map Challenge - 2022
# day 3 - polygons
# Helen Schmidt

# This map pays tribute to my previous home state, Massachusetts, and its obsession with Dunkin!

# Data is from the list of Dunkin locations in Massachusetts. Annoyingly, I couldn't 
# access the full dataset without paying a fee, so I manually grabbed the data. 

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(sf)
library(maps)
library(tidyverse)
library(showtext)
library(nationalparkcolors)
library(purrr)
library(geosphere)

# load fonts for title
font_add_google("Fredoka", "fredoka")
# automatically use showtext when needed
showtext_auto()

# dunkin color palette
# pink, orange, brown, white
colors <- c("#e11383", "#f5821f", "#683817", "#ffffff")
palette <- colorRampPalette(c(colors[2], colors[1]))
palette <- palette(10)

# get massachusetts map
ma <- map_data("county", "massachusetts") %>% 
  select(lon = long, lat, group, id = subregion)

# get centroid of each county to add value in map
# centroids <- ma %>% 
#   group_by(id) %>% 
#   group_modify(~ data.frame(centroid(cbind(.x$lon, .x$lat))))

# get dunkin data
dunkin <- read.csv("./data/dunkin-data-ma.csv")

# match dunkin data with map 
ma$dunkin <- dunkin$DunkinNumber[match(ma$id, dunkin$County)]

# match dunkin data to centroids data
# centroids$dunkin <- dunkin$DunkinNumber[match(centroids$id, dunkin$County)]

# plot!
ggplot() + 
  geom_polygon(data = ma, aes(x = lon, y = lat, group = group, fill = dunkin), color = colors[4]) +
  scale_fill_gradientn(colors = palette) +
  theme_void() +
  coord_map() +
  #geom_text(data = centroids, aes(x = lon, y = lat, label = dunkin), size = 2) +
  annotate(geom = "text",
           label = "DUNKIN",
           x = -73.1, y = 41.75,
           family = "fredoka", size = 7, fontface = 2, 
           color = colors[2]) +
  annotate(geom = "text",
           label = "'",
           x = -72.6, y = 41.75,
           family = "fredoka", size = 7, fontface = 2,
           color = colors[1]) +
  annotate(geom = "text", 
           label = "locations",
           x = -71.95, y = 41.75,
           family = "fredoka", size = 7, fontface = 2,
           color = colors[3]) +
  annotate(geom = "text",
           label = "in Massachusetts",
           x = -72.48, y = 41.55,
           family = "fredoka", size = 7, fontface = 2,
           color = colors[3]) +
  theme(legend.position = "bottom",
        legend.margin = margin(0,110,10,0),
        plot.background = element_rect(fill = colors[4], color = colors[4]),
        panel.background = element_rect(fill = colors[4], color = colors[4]),
        legend.key.height = unit(0.1, "cm"), 
        legend.key.width = unit(0.5, "cm"),
        legend.text = element_text(size = 6, color = colors[3], family = "fredoka"),
        legend.title = element_blank())

# save plot
ggsave(filename = "./maps/day3_polygons.jpeg",
       width = 5,
       height = 3,
       units = "in",
       dpi = 400,
       device = "jpeg")
