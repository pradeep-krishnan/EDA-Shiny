shinyServer(function(input, output){
  
  output$map1 <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "http://{s}.tile.osm.org/{z}/{x}/{y}.png",
        attribution = '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors') %>%
      setView(lng = -73.97, lat = 40.75, zoom = 13)
  }
  )
  
  observeEvent(input$borough,{
    proxy <- leafletProxy("map1")%>%clearMarkerClusters()%>%clearMarkers()%>%
      addMarkers(data = (filter_(major_intersections, input$borough)),
                                     #fillOpacity = 0.5,
                                     clusterOptions = markerClusterOptions(),
                                     lat=~LATITUDE,lng=~LONGITUDE,
                       #color = 'green',
                       popup=major_intersections$LOCATION,
                       label=as.character(major_intersections$N)
                                     
      )
    })
  
  output$map2 <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "http://{s}.tile.osm.org/{z}/{x}/{y}.png",
        attribution = '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors') %>%
      setView(lng = -73.97, lat = 40.75, zoom = 13)
  }
  )
  
  observeEvent(input$borough,{
    proxy <- leafletProxy("map2")%>%clearMarkerClusters()%>%clearMarkers()%>%
            addMarkers(data = (head(arrange((filter_(top_intersections, input$borough)),desc(as.numeric(N))),10)),
                 #fillOpacity = 0.5,
                 lat=~LATITUDE,lng=~LONGITUDE,
                 #color = 'green',
                 popup = ~as.character(top_intersections$N),
                 label=as.character(top_intersections$N)
  
  
  )})
  
  })