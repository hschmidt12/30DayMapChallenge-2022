# 30 Day Map Challenge - 2022
# day 28 - 3D
# Helen Schmidt

# Aurlandsfjord - my fjord cruise!

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

library(tidyverse)         # ultimate tidyverse collection
library(sf)                # simple features
library(RColorBrewer)      # palette brewer
library(showtext)          # fonts
library(raster)            # raster mapping
library(rayshader)         # 3d mapping
library(elevatr)           # elevation maps
library(RColorBrewer)      # palette brewer

# colors - norway winter (dark red to blue to white)
colors <- c("#913715", "#886f73", "#5f7d95", "#a0c2cc", "#d9e2e9", "#dae4eb")
palette <- colorRampPalette(c(colors[1], colors[2], colors[3], colors[4], colors[5]))
palette <- palette(24)
palette <- c(colors[6], palette)

coord <- data.frame(x = c(6.724925689871142, 7.33947339844402),
                    y = c(60.84910020088077, 61.02454926039806))

# get elevation raster data and format
elev <- get_elev_raster(coord, z = 9, clip = "bbox",
                        prj = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
fjord.df <- as.data.frame(elev, xy = T)
colnames(fjord.df) <- c("x", "y", "elev")
fjord.above0 <- filter(fjord.df, elev > 0)
fjord.df <- fjord.above0 %>%
  mutate(elev.level = ntile(elev, 75))

# plot
fjord <- ggplot() +
  geom_raster(data = fjord.df, aes(x = x, y = y, fill = elev.level)) +
  scale_fill_gradientn(colors = palette) +
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = colors[6], color = NA),
        panel.background = element_rect(fill = colors[6], color = NA))

fjord

# rayshader 
plot_gg(fjord,
        raytrace = T, 
        width=3,height=3,
        scale=50, # default 150
        windowsize=c(1400,866),
        zoom = 0.6, theta = 195, phi = 20,
        sunangle = 255) # changes angle of sun; default 315

# save
render_highquality(filename = "./maps/day28_3D",
                   clear = T)





