# 30 Day Map Challenge - 2022
# day 18 - color friday: blue
# Helen Schmidt

# rivers in iceland

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(sf)
library(tidyverse)
library(showtext)
library(osmdata)

# colors (light blue, dark blue, whiteish blue)
colors <- c("#0094c6", "#003f91", "#EBF2FA")

# load fonts for title
font_add_google("Nova Mono", "nova")
# automatically use showtext when needed
showtext_auto()

coord <- c(-24.70774458727845, 63.507063916217504, 
           -12.842510111186554, 66.70311932377426)

iceland <- opq(bbox = coord) %>%
  add_osm_feature(key = "waterway") %>%
  osmdata_sf()

# plot
ggplot() +
  ggtitle("Rivers of Iceland") +
  labs(caption = "data - open street map") +
  geom_sf(data = iceland$osm_lines, 
          color = colors[1]) +
  theme_void() +
  theme(plot.background = element_rect(fill = colors[3], color = NA),
        panel.background = element_rect(fill = colors[3], color = NA),
        plot.title = element_text(family = "nova", color = colors[2], 
                                  size = 26, hjust = 0.5, vjust = -0.7),
        plot.caption = element_text(family = "nova", color = colors[2],
                                    size = 8, hjust = 0.5, vjust = 1.5))

# save plot
ggsave(filename = "./maps/day18_colorfriday_blue.jpeg",
       width = 7,
       height = 5,
       units = "in",
       dpi = 600,
       device = "jpeg")
