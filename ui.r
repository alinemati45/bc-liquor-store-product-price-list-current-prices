library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(shinydashboard)
library(shinyjs)

ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "BC Liquor store prices By Ali Nemati",
                  
                  titleWidth = 600),
  dashboardSidebar(width = 400,
                   sidebarMenu(
                     menuItem(
                       "Welcome to my applicatoin!",
                       tabName = "index",
                       icon = icon("home", lib = "glyphicon")
                     ),
                     menuItem(
                       "Find my liquor!",
                       tabName = "database",
                       icon = icon("glyphicon glyphicon-search", lib = "glyphicon")
                     ),
                     menuItem(
                       "Settings",
                       startExpanded = TRUE,
                       icon = icon("cog", lib = "glyphicon"),
                       tabsetPanel(
                         id = "optionTabs",
                         type = "tabs",
                         ## TabPanel for sorting and filtering
                         tabPanel(
                           "Sort & Filter",
                           icon = icon("search", lib = "glyphicon"),
                           # a conditionalPanel for ascending or descending ordering
                           
                           conditionalPanel(condition = "input.sortByPrice",
                                            uiOutput("PriceSortOutput")),
                           # Price ranges can be filtered
                           sliderInput("priceInput", "Price", 0, 100, c(25, 45), pre = "$"),
                           sliderInput("plotAlpha", "Alpha of bars", 0, 1, value = 0.8),
                           # Sorted by price
                           checkboxInput("sortByPrice", "Sort by price", TRUE),
                           
                           # filter by product type
                           uiOutput("typeSelectOutput"),
                           # filter by sweetness
                           conditionalPanel(condition = "input.typeInput == 'WINE'",
                                            uiOutput("sweetnessOutput")),
                           # filter by subtype
                           uiOutput("subtypeSelectOutput"),
                           # filter by country
                           checkboxInput("filterCountry", "Filter by country", TRUE),
                           conditionalPanel(condition = "input.filterCountry",
                                            uiOutput("countrySelectorOutput"))
                         ),
                         ## tabPanel for changing appearance
                         tabPanel(
                           "Appearance plots",
                           icon = icon("glyphicon glyphicon-edit", lib = "glyphicon"),
                           # provide different plots
                           radioButtons(
                             "plotType",
                             "Changing Plot type",
                             c("Alcohol Content" = "Alcohol_Content",
                               "Price" = "Price")
                           ),
                           # add alpha parameter to the plot
                           sliderInput("plotAlpha", "Alpha of bars", 0, 1, value = 0.6),
                           # add color parameter to the plot
                           radioButtons(
                             "fillBrewer",
                             "Changing Color scheme for plot",
                             c(
                               "Set1" = "Set1",
                               "Set2" = "Set2",
                               "Set3" = "Set3",
                               "Pastel2" = "Pastel2",
                               "Paired" = "Paired",
                               "Dark2" = "Dark2",
                               "Accent" = "Accent"
                             )
                           ),
                           # fold plot and table into tabs
                           checkboxInput("foldResults", "Fold plot and table into tabs", FALSE)
                         ),
                         ## tabPanel for changing appearance
                         tabPanel(
                           "Appearance map",
                           icon = icon("glyphicon glyphicon-edit", lib = "glyphicon"),
                           # add color parameter to the map
                           radioButtons(
                             "mapColor",
                             "Changing Color map",
                             c(
                               "Blue" = "Blues",
                               "Grey" = "Greys",
                               "Purple" = "Purples",
                               "Orange" = "Oranges",
                               "Black" = "Blacks" ,
                               "Red" = "Reds"
                             )
                           )
                         ),
                         
                         
                         tabPanel(
                           "Feedback",
                           icon = icon("glyphicon glyphicon-comment", lib = "glyphicon"),
                           h3("Feedback"),
                           h5(
                             "Contact the developer on ",
                             a("GitHub.", href = "https://github.com/alinemati45/"),
                             br(),
                             span("last updated: 4-28-2022")
                           ),
                           
                           
                           
                         ),
                         
                         
                         tabPanel(
                           "Refrence",
                           icon = icon("glyphicon glyphicon-pushpin", lib = "glyphicon"),
                           h3("Refrence"),
                           h5(
                            
                             a("1- Shinydashboard", href = "https://rstudio.github.io/shinydashboard/index.html"),
                             br(),
                             a("1- Shinydashboard", href = "https://rstudio.github.io/shinydashboard/index.html"), br(),
                             a("2- Interactive Choropleth Map", href = "https://leafletjs.com/examples/choropleth/"),br(),
                             a("3- How to plot country-based choropleths using leaflet R", href = "https://stackoverflow.com/questions/44525730/how-to-plot-country-based-choropleths-using-leaflet-r"),br(),
                             a("4- World.geo.json", href = "https://github.com/johan/world.geo.json"),br(),
                             a("5- Drag and drop geo-json feature files to paint your planet!", href = "http://bl.ocks.org/johan/1431429"),br(),
                             a("6- World Atlas TopoJSON", href = "https://github.com/topojson/world-atlas"),br(),
                             a("7- Leaflet for R: Colors", href = "https://rstudio.github.io/leaflet/colors.html"),br(),
                             a("8- Leaflet for R: Choropleths", href = "https://rstudio.github.io/leaflet/choropleths.html"),br(),
                             a("9- Create colorful graphs in R with RColorBrewer and Plotly", href = "https://moderndata.plotly.com/create-colorful-graphs-in-r-with-rcolorbrewer-and-plotly/"),br(),
                             a("10- Direct link to tabItem with R shiny dashboard", href = "https://stackoverflow.com/questions/37169039/direct-link-to-tabitem-with-r-shiny-dashboard"),br(),
                             a("11- R Shiny: Handle Action Buttons in Data Table", href = "https://stackoverflow.com/questions/45739303/r-shiny-handle-action-buttons-in-data-table"),br(),
                             
                             
                             br(),
                             span("last updated: 4-28-2022")
                           ),
                           
                           
                           
                         )
                       )
                     )
                   )),
  dashboardBody(
    # include shinyjs
    useShinyjs(),
    # include CSS
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    # define a function to open tab
    tags$script(
      HTML(
        "
        var openTab = function(tabName){
          $('a', $('.sidebar')).each(function() {
            if(this.getAttribute('data-value') == tabName) {
              this.click()
            };
          });
        }
      "
      )
    ),
    
    # tabItems
    tabItems(
      # welcome page
      tabItem(tabName = "index",
              fluidRow(
                # embed gif as logo
                div(id = "logo",
                    img(src = "logo.gif")),
                # description
                h2(
                  "Just click on ",
                  a("Find my liquor", onclick = "openTab('database')", href = "#"),
                  " and use the filters at the left!"
                ),
                br(),
                
                img(src = "https://uwm.edu/externalrelations/wp-content/uploads/sites/437/2019/09/graphic-for-logos.jpg"),
                ## license
                hr(),
                br(),
                br(),
                em(
                  span(
                    "Github Download Code:",
                    tags$a("bc-liquor-store-product-price-list-current-prices",
                           href = "https://github.com/alinemati45/bc-liquor-store-product-price-list-current-prices")
                  ),
                  br(),
                  span(
                    "Improvded by Ali Nemati (Nemati@UWM.edu), Created by ",
                    a(href = "https://github.com/daattali/shiny-server/tree/master/bcl", "Dean Attali"),
                    br(),
                    span("last updated: 4-28-2022")
                  )
                  
                )
              )),
      # data page
      tabItem(tabName = "database",
              fluidRow(
                h3(textOutput("summaryText")),
                br(),
                uiOutput("showResults")
              ))
      
      
      
    )
    
  )
)