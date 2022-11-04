# 30 Day Map Challenge - 2022
# day 5 - ukraine
# Helen Schmidt

# Topographic map of Ukraine

# Special thanks to rspatialdata for the tutorial that I followed:
# https://rspatialdata.github.io/elevation.html

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(tidyverse)       # ultimate tidyverse collection
library(elevatr)         # elevation maps
library(rgeoboundaries)  # get country boundaries
library(sf)              # simple features
library(raster)          # raster mapping
library(MetBrewer)       # met art palette
library(RColorBrewer)    # color brewer
library(scales)          # scales

# load fonts for title
font_add_google("Yeseva One", "yeseva")
# automatically use showtext when needed
showtext_auto()

# colors (blue gradient)
colors <- met.brewer("Hokusai2", n = 9)
# define elevation colors
elev <- read.csv(textConnection(
"altitudes,colors
10000,#ABC9C8
4000,#87B8BC
3000,#67A7B4
1500,#4B95B0
500,#3A81A8
300,#2B6B9B
0,#1A547E
-1,#0F4266
-12000,#0A3351"), stringsAsFactors=FALSE)
elev$altitudes01 <- scales::rescale(elev$altitudes)
elev.colors <- function(n) {
        colorRampPalette(etopo$colors)(n)}

# get ukraine boundaries
ukraine.bound <- rgeoboundaries::geoboundaries("Ukraine")
elevation.data <- elevatr::get_elev_raster(locations = ukraine.bound, z = 6,
                                           units = "meters", clip = "locations")
elevation.data <- as.data.frame(elevation.data, xy = TRUE)
colnames(elevation.data)[3] <- "elevation"
# remove rows of data frame with one or more NAs
elevation.data <- elevation.data[complete.cases(elevation.data), ]

# plot!
ggplot() +
        geom_raster(data = elevation.data, aes(x = x, y = y, fill = elevation)) +
        geom_sf(data = ukraine.bound, color = NA, fill = NA) +
        coord_sf() +
        theme_void() +
        annotate(geom = "text",
                 label = "Ukraine",
                 x = 25, y = 46.5,
                 family = "yeseva", size = 18, fontface = 2,
                 color = colors[9]) +
        annotate(geom = "text",
                 label = "48.3794° N, 31.1656° E",
                 x = 25, y = 45.9,
                 family = "yeseva", size = 4, fontface = 1,
                 color = colors[9]) +
        scale_fill_gradientn(colors = elev$colors, values=elev$altitudes01) +
        theme(legend.position = "none",
              plot.background = element_rect(fill = "#ffe078", color = "#ffe078"),
              panel.background = element_rect(fill = "#ffe078", color = "#ffe078"))

# save plot
ggsave(filename = "./maps/day5_ukraine.jpeg",
       width = 10,
       height = 8,
       units = "in",
       dpi = 800,
       device = "jpeg")
