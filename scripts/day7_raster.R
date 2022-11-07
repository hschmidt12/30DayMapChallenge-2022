# 30 Day Map Challenge - 2022
# day 7 - raster
# Helen Schmidt

# Topographic map of Connecticut

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(tidyverse)         # ultimate tidyverse collection
library(elevatr)           # elevation maps
library(rgeoboundaries)    # get country boundaries
library(USAboundaries)     # get US state boundaries
library(USAboundariesData) # get data for US states
library(sf)                # simple features
library(raster)            # raster mapping
library(MetBrewer)         # met art palette
library(RColorBrewer)      # color brewer
library(scales)            # scales
library(showtext)          # fonts

# load fonts for title
font_add_google("Akaya Telivigala", "akaya")
# automatically use showtext when needed
showtext_auto()

# colors (blue gradient)
colors <- met.brewer("OKeeffe2", n = 9)
# define elevation colors
elev <- read.csv(textConnection(
  "altitudes,colors
650,#FBE3C2
300,#F4CE9B
150,#EFBC86
80,#EAAC78
50,#E69C6B
-1,#D78056
-5,#C56647
-10,#AF4D36
-50,#92351E"), stringsAsFactors=FALSE)
elev$altitudes01 <- scales::rescale(elev$altitudes)
elev.colors <- function(n) {
  colorRampPalette(etopo$colors)(n)}

# get connecticut boundaries
CT.bound <- USAboundaries::us_states(resolution = "high", states = "Connecticut")
elevation.data <- elevatr::get_elev_raster(locations = CT.bound, z = 9,
                                           units = 'meters', clip = "locations")
elevation.data <- as.data.frame(elevation.data, xy = TRUE)
colnames(elevation.data)[3] <- "elevation"
# remove rows of data frame with one or more NAs
elevation.data <- elevation.data[complete.cases(elevation.data), ]

# plot!
ggplot() +
  geom_raster(data = elevation.data, aes(x = x, y = y, fill = elevation)) +
  geom_sf(data = CT.bound, color = NA, fill = NA) +
  coord_sf() +
  annotate(geom = "text",
           label = "Connecticut",
           x = Inf, y = -Inf, hjust = 1.2, vjust = -1.7,
           family = "akaya", size = 24, fontface = 2,
           color = colors[1]) +
  theme_void() +
  scale_fill_gradientn(colors = elev$colors, values=elev$altitudes01) +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "#87311C", color = "#87311C"))

# save plot
ggsave(filename = "./maps/day7_raster.jpeg",
       width = 10,
       height = 8,
       units = "in",
       dpi = 800,
       device = "jpeg")
