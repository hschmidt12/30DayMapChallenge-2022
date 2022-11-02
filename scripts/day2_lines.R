# 30 Day Map Challenge - 2022
# day 2 - lines
# Helen Schmidt

# Flight and airport data from anyflights package

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

# load packages
library(maps)
library(ggplot2)
library(dplyr)
library(showtext)
library(anyflights)
library(geosphere)
library(nationalparkcolors)

# load fonts for title
font_add_google("Train One", "train")
font_add_google("Mukta", "mukta")
# automatically use showtext when needed
showtext_auto()

# get colors
colors <- park_palette("Denali", 5)

# get Philadelphia airport information (June 2021)
df <- anyflights("PHL", 2021, 6)

# define airports only in US
airports <- df$airports
usairports <- filter(airports, lat < 48.5)
usairports <- filter(usairports, lon > -130)
usairports <- filter(usairports, faa != "PHL") #filter out PHL
usairports <- filter(usairports, faa != "TZR") #filter out TZR in Hungary
phl <- filter(airports, faa == "PHL") # create separate dataframe for Philly

# get flight information
flights <- df$flights
# filter to June 4, 2021 for simplicity (Friday)
flights <- subset(flights, day == 4)
# select only origin and destination
flights <- flights %>% select(origin, dest)
names(flights)[2] <- "faa" # match destination code
# merge destination with usairports to get only direct flights
direct <- merge(flights, usairports, by = "faa")

ggplot() + geom_polygon(data = map_data("usa"), aes(x=long, y = lat, group = group), 
                        fill = colors[2]) +
  theme_void() +
  geom_point(data = direct, aes(x = lon, y = lat), 
             size = 0.001, color = colors[3], fill = colors[3]) +
  geom_curve(data = direct, aes(x = phl$lon, y = phl$lat, xend = lon, yend = lat),
             size = 0.09, color = colors[4], curvature = 0.2) +
  coord_fixed(1.3) +
  annotate(geom = "text",
           label = "PHL > USA",
           x = -Inf, y = -Inf, hjust = -0.2, vjust = -1,
           family = "train", size = 6, fontface = 2, color = colors[3]) +
  annotate(geom = "text",
           label = "Direct domestic flights originating from Philadelphia",
           x = -Inf, y = -Inf, hjust = -0.08, vjust = -1,
           family = "mukta", size = 2, color = colors[3]) +
  theme(legend.position = "none",
        plot.background = element_rect(fill = colors[1], color = colors[1]),
        panel.background = element_rect(fill = colors[1], color = colors[1]))

# save plot
ggsave(filename = "./maps/day2_lines.jpeg",
       width = 5,
       height = 3,
       units = "in",
       dpi = 400,
       device = "jpeg")
