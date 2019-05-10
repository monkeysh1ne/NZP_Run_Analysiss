# Plots delivery events on a geo map
# using data from a csv file.
#
#
# requires libraries:
# leaflet()
# sp()
# author: D Mayson
# last modified: 8/5/19







library(leaflet)
library(sp)

# Can the following DFs be improved by refactoring?
# Is there a better, DRYer
# way to create these?
#
#
# Remove CTC tickets from DF
#
#
run_data <- read.csv("data/WCP306 090519 GPS.csv")
rd_205 <- run_data[which(run_data$Run.No. == "WCP205"),]
rd_205A <- run_data[which(run_data$Run.No. == "WCP205A"),]
rd_205B <- run_data[which(run_data$Run.No. == "WCP205B"),]
rd_205C <- run_data[which(run_data$Run.No. == "WCP205C"),]

# Spacial Point DF points to columns (5 & 6 here) that contain the
# lat and lng coords.
#
#
data.SP <- SpatialPointsDataFrame(run_data[,c(5,6)], run_data[,-c(5,6)])


# initailise map
mapdf_init <- data.frame(
  InitialLat = -41.25852,
  InitialLong = 174.7881) 



# custom icons for map
# Refactor these.  Lot of repeated code
#
#
# Define map markers

# Create collection of colors relating to run no.
new <- c("red", "green","blue", "orange")[run_data$Run.No.]

# Create icon set
icons <- awesomeIcons(
  icon= 'pushpin', 
  markerColor = new,
  iconColor = 'white', 
  library = 'glyphicon'
)


m = leaflet(mapdf_init)
m <- m %>% 
  # Base Groups
  addTiles(group = "OSM (default)") %>% 
  addProviderTiles(providers$Stamen.Toner, group = "Toner") %>% 
  # Overlay Groups
  #
  #
  addAwesomeMarkers(data = rd_205, lng= ~Longitude, lat = ~Latitude, icon = icons, popup = paste(
    "<strong>TrackingNo:</strong>", rd_205$Tracking.No, "<br/>",
    "<strong>Event DateTime:</strong>", rd_205$Scan.Date, "<br/>",
    "<strong>Event Type:</strong>",rd_205$Scan.Type,
    "<strong>Run.No.:</strong>", rd_205$Run.No.),
    group = "WCP205",
    clusterOptions = markerClusterOptions()
  ) %>% 
   addMarkers(data = rd_205A, lng= ~Longitude, lat = ~Latitude, icon = icons, popup = paste(
    "<strong>TrackingNo:</strong>", rd_205A$Tracking.No, "<br/>",
    "<strong>Event DateTime:</strong>", rd_205A$Scan.Date, "<br/>",
    "<strong>Event Type:</strong>",rd_205A$Scan.Type,
    "<strong>Run.No.:</strong>", rd_205A$Run.No.),
    group = "WCP205A",
    clusterOptions = markerClusterOptions()
  ) %>%   
   addMarkers(data = rd_205B, lng= ~Longitude, lat = ~Latitude, icon = icons, popup = paste(
    "<strong>TrackingNo:</strong>", rd_205B$Tracking.No, "<br/>",
    "<strong>Event DateTime:</strong>", rd_205B$Scan.Date, "<br/>",
    "<strong>Event Type:</strong>",rd_205B$Scan.Type,
    "<strong>Run.No.:</strong>", rd_205B$Run.No.),
    group = "WCP205B",
    clusterOptions = markerClusterOptions()
  ) %>%   
  addMarkers(data = rd_205C, lng= ~Longitude, lat = ~Latitude, icon = icons, popup = paste(
    "<strong>TrackingNo:</strong>", rd_205C$Tracking.No, "<br/>",
    "<strong>Event DateTime:</strong>", rd_205C$Scan.Date, "<br/>",
    "<strong>Event Type:</strong>",rd_205C$Scan.Type,
    "<strong>Run.No.:</strong>", rd_205C$Run.No.),
    group = "WCP205C",
    clusterOptions = markerClusterOptions()
  ) %>%   
  
  # Layers Control
  addLayersControl(
    baseGroups = c("OSM (default)", "Toner"),
    overlayGroups = c("WCP205", "WCP205A", "WCP205B", "WCP205C"),
    options = layersControlOptions(collapsed = FALSE)
  )
m
