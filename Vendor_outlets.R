library(tidyverse)
library(leaflet)
library(htmlwidgets)
library(htmltools)

iDir <- "D:/OneDrive - CGIAR/Scientist requests/Christine_chege"

outlets <- read.csv(paste0(iDir, "/data/", "Vendor_outlets_Routes.csv"), stringsAsFactors=FALSE)

markets <- read.csv(paste0(iDir, "/data/", "Market_locations.csv"), stringsAsFactors=FALSE)

#remove data that doesnt make sense
outlets <- outlets[-c(12457:12465),] 

popup1 <- paste0("Depot Name: ", outlets$stall_id)
popup2 <-  paste0("Market Name: ", markets$Market)

map.ll <- leaflet() %>%
  
  addProviderTiles("Esri.WorldStreetMap") %>%
  
  addMiniMap(position = "bottomright") %>% 
  
  setView(36.900168, -1.162006, zoom = 10) %>%
  
  addMarkers(
    markets$Lon, markets$Lat,
    popup = popup2,
    group = "Markets") %>% 
  
  addCircleMarkers(data = outlets,
    outlets$longitude, outlets$latitude,
    weight = 3,
    color = "green",
    opacity = 0.5,
    radius = 2,
    group ="Outlets", 
    popup = popup1) %>%
  
  addLayersControl(overlayGroups = c("Outlets", "Markets"), options = layersControlOptions(collapsed = FALSE))


saveWidget(map.ll, file = paste0(iDir, "/outputs/", "Vendor_outlets", ".html", sep = ""))


#14k vendors clustered by routes 

map.ll2 <- leaflet() %>%
  
  addProviderTiles("Esri.WorldStreetMap") %>%
  
  addMiniMap(position = "bottomright") %>% 
  
  setView(36.900168, -1.162006, zoom = 10) %>%
  
  addMarkers(
    markets$Lon, markets$Lat,
    label = markets$Market,
    labelOptions = labelOptions(noHide = T, textsize = "15px"), group = "Markets") %>% 
  
  addCircleMarkers(
    outlets$longitude, outlets$latitude,
    weight = 3,
    color = "#03F",
    opacity = 0.5,
    radius = 5,
    group = "Vendors clustered by routes", 
    popup = popup,
    clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = T, showCoverageOnHover = F)) %>%
  
  addLayersControl(overlayGroups = c("Markets", "Vendors clustered by routes"), options = layersControlOptions(collapsed = FALSE))


saveWidget(map.ll2, file = paste0(iDir, "/outputs/", "Vendor_outlets_clustered", ".html", sep = ""))



