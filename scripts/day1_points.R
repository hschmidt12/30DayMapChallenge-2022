# 30 Day Map Challenge - 2022
# day 1 - points
# Helen Schmidt

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(sf)
library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)
library(showtext)

# load fonts for title
font_add_google("Montserrat", "montserrat")
# automatically use showtext when needed
showtext_auto()

# set custom colors (city of Philadelphia color palette)
# ghost-grey (background), dark-ben-franklin-blue (streets), bell yellow (restaurants)
colors <- c("#f0f0f0","#0f4d90","#f3c613")

# Read in Philadelphia base map
base <- read_sf("./data/Philly_Street_Centerline/Street_Centerline.shp") %>%
  dplyr::select(geometry)
# Read in business license data
license <- read_sf("./data/business_licenses/business_licenses.shp") %>%
  dplyr::select(licensetyp, geometry)

# Only select food establishments
food <- c("Food Preparing and Serving", "Food Estab, Retail Non-Permanent Location (Annual)","Food Establishment, Retail Permanent Location",
          "Food Caterer", "Sidewalk Cafe", "Food Establishment, Outdoor", "Food Establishment, Retail Perm Location (Large)",
          "Food Preparing and Serving (30+ SEATS)", "Food Estab, Retail Non-Permanent Location (Event)", "Sidewalk Cafe (Temporary)")
license <- subset(license, license$licensetyp %in% food)

# plot!
ggplot() + geom_sf(data = base$geometry, color = colors[2], size = 0.1) +
  geom_sf(data = license$geometry, alpha = 0.7, aes(color = colors[3], alpha = 0.7), size = 0.001, shape = 20) +
  scale_color_manual(values = colors[3]) +
  scale_fill_manual(values = colors[3]) +
  theme_void() + 
  annotate(geom = "text",
           label = "Philadelphia\nRestaurants",
           x = Inf, y = -Inf, hjust = 1.4, vjust = -3,
           family = "montserrat", size = 3, fontface = 2, color = colors[2]) +
  annotate(geom = "text",
           label = "Data: OpenDataPhilly",
           x = Inf, y = -Inf, hjust = 2, vjust = -23,
           family = "montserrat", size = 1, fontface = 2, color = colors[3]) +
  theme(legend.position = "none",
        plot.background = element_rect(fill = colors[1], color = colors[1]),
        panel.background = element_rect(fill = colors[1], color = colors[1]),
        legend.key.height = unit(0.1, "cm"), 
        legend.key.width = unit(0.5, "cm"),
        legend.text = element_text(size = 8, color = "white", family = "montserrat"),
        legend.title = element_blank())

# save plot
ggsave(filename = "./maps/day1_points.jpeg",
       width = 3,
       height = 3,
       units = "in",
       device = "jpeg")
