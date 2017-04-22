shinyUI(
  dashboardPage(
    skin = 'green',
    dashboardHeader(title = 'NYC Accidents'),
    dashboardSidebar(
      sidebarMenu(
        id = 'sideBarMenu',
        menuItem(
          "Collision map_1",
          tabName = "map1",
          icon = icon("map")
        ),
        menuItem("Collisionmap_2", tabName = "map2", icon = icon("map"))
        
      ),
      conditionalPanel(
        "input.sideBarMenu == 'map1'",
        selectizeInput(
          'borough',
          'BOROUGH',
          choice = c(
            'All' = 'BOROUGH != ""',
            'Manhattan' = 'BOROUGH == "MANHATTAN"',
            'Brooklyn' = 'BOROUGH == "BROOKLYN"',
            'Bronx' = 'BOROUGH == "BRONX"',
            'Queens' = 'BOROUGH == "QUEENS"',
            'Staten Island' = 'BOROUGH == "STATEN ISLAND"'
          )
        )
      ),
      conditionalPanel(
        "input.sideBarMenu == 'map2'",
        selectizeInput(
          'borough',
          'BOROUGH',
          choice = c(
            'All' = 'BOROUGH != ""',
            'Manhattanaaaa' = 'BOROUGH == "MANHATTAN"',
            'Brooklyn' = 'BOROUGH == "BROOKLYN"',
            'Bronx' = 'BOROUGH == "BRONX"',
            'Queens' = 'BOROUGH == "QUEENS"',
            'Staten Island' = 'BOROUGH == "STATEN ISLAND"'
          )
        )
      )
      ),
      dashboardBody(tabItems(tabItem(
        tabName = "map1",
        fluidPage(
        fluidRow(box(
          leafletOutput("map1",
                        height = 650),
          width = 12)
        )
      )
      ),
      tabItem(tabName = "map2",
      fluidPage(
              fluidRow(box(
                leafletOutput("map2", 
                              height = 650),
                width = 12))
      ))))))

    
      

    #  sliderInput(
    #     'year',
    #     label = 'Choose the year: ',
    #     min = 2013,
    #     max = 2016,
    #     value = 2013,
    #     step = 1
    #   )
    #   , radioButtons(
    #     "vehicletype",
    #     "Select vehicle Tyep: ",
    #     c(
    #       'All' = 'VEHICLE.TYPE.CODE.1 != "ALL"',
    #       'TAXI' = 'VEHICLE.TYPE.CODE.1 == "TAXI"',
    #       'PASSENGER VEHICLE' = 'VEHICLE.TYPE.CODE.1 == "PASSENGER VEHICLE"'
    #     )
    #   )
    # ),
