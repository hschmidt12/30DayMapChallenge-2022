# 30 Day Map Challenge - 2022
# day 27 - music
# Helen Schmidt

# music venues in nashville, colored by size and age (length of time open)
# 3x3 color grid to color age/size

# set working directory
setwd("/Volumes/GoogleDrive/My Drive/30DayMapChallenge-2022")

library(tidyverse)         # ultimate tidyverse collection
library(sf)                # simple features
library(RColorBrewer)      # palette brewer
library(showtext)          # fonts

# colors - vintage hawaii (light blue, yellow, orange, dark blue, grey)
colors <- c("#68b3af", "#f8cc85", "#f47413", "#1a7f87", "#557871")
palette <- colorRampPalette(c(colors[5], colors[4], colors[3], colors[2]))
palette <- palette(25)

# load fonts for title
font_add_google("Signika Negative", "signika")
# automatically use showtext when needed
showtext_auto()

