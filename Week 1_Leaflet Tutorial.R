#MIGUEL CURIEL LEAFLET TUTORIAL

library(leaflet) #load the library, alternatively, you can use require(leaflet)

#BOSTON
#m <- leaflet() %>% setView(lng = -71.0589, lat = 42.3601, zoom = 12)
#m %>% addTiles()

#MACHU PICHU
m <- leaflet() %>% setView(lng = -72.545128, lat = -13.163068, zoom = 12)
m %>% addTiles()