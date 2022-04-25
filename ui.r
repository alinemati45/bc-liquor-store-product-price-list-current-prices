library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(shinydashboard)
library(shinyjs)

ui <- dashboardPage(skin = "purple",
  dashboardHeader(
    title = "BC Liquor store prices By Ali Nemati",
    titleWidth = 600
    
  ),
  dashboardSidebar(
    width = 500,
    sidebarMenu( 
      menuItem("Welcome to my applicatoin!", tabName = "index", icon = icon("home", lib = "glyphicon")),
      menuItem("Find my liquor!", tabName = "database", icon = icon("glyphicon glyphicon-search", lib = "glyphicon")),
      menuItem("Settings", startExpanded = TRUE, icon = icon("cog", lib = "glyphicon"),
        tabsetPanel(id = "optionTabs", type = "tabs",
          ## tabPanel for sort and filter
          tabPanel("Sort & Filter", icon = icon("search", lib = "glyphicon"),
                   # filter by range of price
                   sliderInput("priceInput", "Price", 0, 100, c(30, 50), pre = "$"),
                   # sort by price
                   checkboxInput("sortByPrice", "Sort by price", TRUE),
                   # a conditionalPanel for ascending or descending ordering
                   conditionalPanel(
                     condition = "input.sortByPrice",
                     uiOutput("PriceSortOutput")),
                   # filter by product type
                   uiOutput("typeSelectOutput"),
                   # filter by sweetness
                   conditionalPanel(
                     condition = "input.typeInput == 'WINE'",
                     uiOutput("sweetnessOutput")
                   ),
                   # filter by subtype
                   uiOutput("subtypeSelectOutput"),
                   # filter by country
                   checkboxInput("filterCountry", "Filter by country", TRUE),
                   conditionalPanel(
                     condition = "input.filterCountry",
                     uiOutput("countrySelectorOutput")
                   )
          ),
          ## tabPanel for changing appearance
          tabPanel("Appearance plots", icon = icon("glyphicon glyphicon-user", lib = "glyphicon"),
                   # provide different plots
                   radioButtons("plotType", "Changing Plot type",
                                c("Alcohol Content" = "Alcohol_Content",
                                  "Price" = "Price")),
                   # add alpha parameter to the plot
                   sliderInput("plotAlpha", "Alpha of bars", 0, 1, value = 0.8),
                   # add color parameter to the plot
                   radioButtons("fillBrewer", "Changing Color scheme for plot",
                                c("Set3" = "Set3",
                                  "Set2" = "Set2",
                                  "Set1" = "Set1",
                                  "Pastel2" = "Pastel2",
                                  "Paired" = "Paired",
                                  "Dark2" = "Dark2",
                                  "Accent" = "Accent")),
                   # fold plot and table into tabs
                   checkboxInput("foldResults", "Fold plot and table into tabs", TRUE)
          ),
          ## tabPanel for changing appearance
          tabPanel("Appearance map", icon = icon("glyphicon glyphicon-user", lib = "glyphicon"),
                    # add color parameter to the map
                   radioButtons("mapColor", "Changing Color map",
                                c("Blue" = "Blues", "Grey" = "Greys",  "Purple" = "Purples", "Orange" = "Oranges",
                                  "Black" = "Blacks" , "Red" = "Reds"))
          ),
          ## tabPanel for changing appearance
          tabPanel("About Me", icon = icon("glyphicon glyphicon-user", lib = "glyphicon"),
                   # add color parameter to the map
                   fluidRow(column(3,"My Neme is Ali Nemati. " )),
                   fluidRow(column(3,"Phd studnet at UWM. ")),
                   
                   fluidRow(column(3,"Email: Nemati@uwm.edu")),
                   

          

          )
        )
      )
    )
  ),
  dashboardBody( 
    # include shinyjs
    useShinyjs(),
    # include CSS
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    # define a function to open tab
    tags$script(HTML("
        var openTab = function(tabName){
          $('a', $('.sidebar')).each(function() {
            if(this.getAttribute('data-value') == tabName) {
              this.click()
            };
          });
        }
      ")),
  
    # tabItems
    tabItems(
      # welcome page
      tabItem(tabName = "index",
        fluidRow(
          # embed gif as logo
          div(id="logo",
              img(src = "logo.gif")
          ),
          # description
          h2(
            "Just click on ",
            a("Find my liquor", onclick = "openTab('database')", href = "#"),
            " and use the filters at the left!"
          ),
          br(), 
          
          img(src = "https://uwm.edu/externalrelations/wp-content/uploads/sites/437/2019/09/graphic-for-logos.jpg"),
          ## license
          hr(), br(), br(),
          em(
            span("Github Download Code:", 
                 tags$a("bc-liquor-store-product-price-list-current-prices",
                        href = "https://github.com/alinemati45/bc-liquor-store-product-price-list-current-prices")),
            br(), 
            span("Improvded by Ali Nemati (Nemati@UWM.edu), Created by ", a(href = "https://github.com/daattali/shiny-server/tree/master/bcl", "Dean Attali"))
            
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