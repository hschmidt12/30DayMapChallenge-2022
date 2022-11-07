# 30 Day Map Challenge - 2022
# day 6 - network
# Helen Schmidt

# Boston MBTA Rapid Transit Rail Network

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
library(gganimate)       # animate plots
library(gifski)          # save animations as gifs

# make mbta color palette (blue, green, orange, red)
colors <- c("#003DA5","#00843D","#ED8B00","#DA291C")

# load mbta station nodes (no silver line)
nodes <- read_sf("./data/mbta_rapid_transit/MBTA_NODE.shp") %>%
  subset(LINE != "SILVER")
# load mbta lines
lines <- read_sf("./data/mbta_rapid_transit/MBTA_ARC.shp") %>%
  subset(LINE != "SILVER")
# load mbta ridership by stop (fall 2019, weekdays)
riders <- read.csv("./data/MBTA_Rail_Ridership_by_Time_Period%2C_Season%2C_Route_Line%2C_and_Stop.csv") %>%
  subset(season == "Fall 2019" & day_type_name == "weekday") %>%
  dplyr::select(route_name, time_period_name, stop_name, total_offs)
names(riders)[3] <- "STATION"
riders$LINE[riders$route_name == "Blue Line"] <- "BLUE"
riders$LINE[riders$route_name == "Green Line"] <- "GREEN"
riders$LINE[riders$route_name == "Red Line"] <- "RED"
riders$LINE[riders$route_name == "Orange Line"] <- "ORANGE"
# merge with node data
nodes <- merge(nodes, riders, by = c("STATION", "LINE"))
# rescale ridership to plot
nodes$riders_off <- nodes$total_offs/10000
# fix time of day names
nodes$timeofday[nodes$time_period_name == "VERY_EARLY_MORNING"] <- "1 - Very Early Morning"
nodes$timeofday[nodes$time_period_name == "EARLY_AM"] <- "2 - Early Morning"
nodes$timeofday[nodes$time_period_name == "AM_PEAK"] <- "3 - Peak Morning"
nodes$timeofday[nodes$time_period_name == "MIDDAY_BASE"] <- "4 - Midday Baseline"
nodes$timeofday[nodes$time_period_name == "MIDDAY_SCHOOL"] <- "5 - Midday School"
nodes$timeofday[nodes$time_period_name == "EVENING"] <- "6 - Evening"
nodes$timeofday[nodes$time_period_name == "PM_PEAK"] <- "7 - Peak Evening"
nodes$timeofday[nodes$time_period_name == "LATE_EVENING"] <- "8 - Late Evening"
nodes$timeofday[nodes$time_period_name == "NIGHT"] <- "9 - Night"

# plot!
plot <- ggplot() + 
  transition_manual(nodes$timeofday) + labs(title = "{current_frame}") +
  geom_sf(data = lines$geometry, size = 3, aes(color = lines$LINE)) +
  geom_sf(data = nodes$geometry, size = nodes$riders_off, aes(color = nodes$LINE)) + 
  theme_void() +
  scale_color_manual(values = colors) +
  scale_fill_manual(values = colors) +
  theme(plot.title = element_text(size = 60, face = "bold",
                                  hjust = 0.1, vjust = -17),
        legend.position = "none")

# make into a gif
animate(plot, duration = 10, fps = 20, renderer = gifski_renderer(),
        height = 1500, width = 1500)

# save gif
anim_save("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022/maps/day6_network.gif")
