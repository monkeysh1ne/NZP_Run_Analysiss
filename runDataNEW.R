library(leaflet)
library(dplyr)
library(stringr)
library(RColorBrewer)

# load data from external file (e.g., csv)
df <- read.csv("data/WCP ALL 090519 GPS.csv")


# If rows contain one or more fields with missing data
# remove these
complete.cases(df)
x <- df[complete.cases(df),]
df <- x



# Identify the different layers based
# on Run.No - e.g., WCP110, WCP110A, WCP110B...


# Generate color palette - func 'colors()' produces
# number of different colors from 1 to n, n = min 3
# to max dependent on palette and df attr.
colorsmap = colors()[1:length(unique(df$Run.No.))]
palette = brewer.pal(4,"YlOrRd")
palette = colorRampPalette(palette)(25)  # exted color palette number avail colors
groupColors = colorFactor(palette, domain = df$Run.No.)





# Render finished map
leaflet(data = df) %>% 
  addTiles() %>%
  addCircleMarkers(lng = ~Longitude, lat = ~Latitude, color = ~groupColors(Run.No.),
                   group = ~Run.No.,
                   weight = 1, popup = paste(
                     "<strong>Event DateTime:</strong>", df$Scan.Date, "<br/>",
                     "<strong>Event Type:</strong>",df$Scan.Type, "<br />",
                     "<strong>Run.No.:</strong>", df$Run.No.)) %>% 
  addLayersControl(overlayGroups = df$Run.No.,
                   options = layersControlOptions(collapsed = TRUE)) %>%
  addLegend(position = "topright", pal = groupColors, values = ~Run.No.)

# To Do:
# Provide interactive means to display data by
# Scan Type (i.e., Delivery, Attempted Delivery...)

