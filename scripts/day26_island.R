# 30 Day Map Challenge - 2022
# day 26 - island
# Helen Schmidt

# rayshader elevatio of maui
# thanks to iva brunec for code that helped me get started with rayshader!

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

library(tidyverse)         # ultimate tidyverse collection
library(elevatr)           # elevation maps
library(rgeoboundaries)    # get country boundaries
library(USAboundaries)     # get US state boundaries
library(USAboundariesData) # get data for US states
library(sf)                # simple features
library(raster)            # raster mapping
library(rayshader)         # 3d mapping
library(RColorBrewer)      # palette brewer
library(showtext)          # fonts
library(magick)            # annotate plot

# colors - vintage hawaii (light blue, yellow, orange, dark blue, grey)
colors <- c("#68b3af", "#f8cc85", "#f47413", "#1a7f87", "#557871")
palette <- colorRampPalette(c(colors[5], colors[4], colors[3], colors[2]))
palette <- palette(50)

# load fonts for title
font_add_google("Nerko One", "nerko")
# automatically use showtext when needed
showtext_auto()

# get maui + kaho'olawe coordinates
coord <- data.frame(x = c(-156.73898367656844, -155.96994070779783),
                    y = c(20.498438431533426, 21.068499579327177))
# get elevation raster data and format
elev <- get_elev_raster(coord, z = 9, clip = "bbox",
                        prj = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
maui.df <- as.data.frame(elev, xy = T)
colnames(maui.df) <- c("x", "y", "elev")
maui.above0 <- filter(maui.df, elev > 0)
maui.df <- maui.above0 %>%
  mutate(elev.level = ntile(elev, 50))

# plot
maui <- ggplot() +
  geom_raster(data = maui.df, aes(x = x, y = y, fill = elev.level)) +
  scale_fill_gradientn(colors = palette) +
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = colors[1], color = NA),
        panel.background = element_rect(fill = colors[1], color = NA))

maui

# rayshader time!
plot_gg(maui,
        raytrace = T, 
        width=3,height=3,
        scale=50, # default 150
        windowsize=c(1400,866),
        zoom = 0.6, theta = 0, phi = 70,
        sunangle = 255) # changes angle of sun; default 315

# save
render_snapshot("./maps/day26_island",
                clear = T)

