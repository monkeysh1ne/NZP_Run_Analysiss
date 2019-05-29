library(leaflet)
library(dplyr)
library(stringr)
library(RColorBrewer)
library(lubridate)
library(tidyverse)

# load data from external file (e.g., csv) ----
df <- read.csv("data/WCP111 13-180519 GPS.csv", stringsAsFactors = FALSE)


# Convert Scan.Date type to Dates ----
df$newDate <- as.POSIXct(strptime(df$Scan.Date, format = "%d/%m/%Y %H:%M:%S"), tz="Pacific/Auckland")



# Remove missing data entries ----
# If rows contain one or more fields with missing data
# remove these
complete.cases(df)
x <- df[complete.cases(df),]
df <- x


# Filters if desired ----
sub1 <- subset(df, newDate >= as.POSIXct('2019-05-14 04:00'))



# Identify the different layers based
# on Run.No - e.g., WCP110, WCP110A, WCP110B...
# code????


# Generate color palette ----
# func 'colors()' produces
# number of different colors from 1 to n, n = min 3
# to max dependent on palette and df attr.
colorsmap = colors()[1:length(unique(sub1$Run.No.))]
palette = brewer.pal(3,"Set1") # Make colors avail as R pallette
# palette = colorRampPalette(palette)(25)  # exted color palette number avail colors for large #runs
groupColors = colorFactor(palette, domain = sub1$Run.No.)





# Render finished map ----
leaflet(data = sub1) %>% 
  addTiles() %>%
  addCircleMarkers(lng = ~Longitude, lat = ~Latitude, color = ~groupColors(Run.No.),
                   group = ~Run.No.,
                   weight = 1, popup = paste(
                     "<strong>Tracking No.:</strong>", sub1$Tracking.No, "<br/>",
                     "<strong>Event DateTime:</strong>", sub1$newDate, "<br/>",
                     "<strong>Event Type:</strong>",sub1$Scan.Type, "<br />",
                     "<strong>Run.No.:</strong>", sub1$Run.No.)) %>% 
  addLayersControl(overlayGroups = sub1$Run.No.,
                   options = layersControlOptions(collapsed = TRUE)) %>%
  addLegend(position = "topright", pal = groupColors, values = ~Run.No.)

# To Do:
# Provide interactive means to display data by
# Scan Type (i.e., Delivery, Attempted Delivery...)

