library(shiny)
library(shinydashboard)
library(dygraphs)
options(scipen = 500)
source("functions.R")

#Header elements for the visualisation
header <- dashboardHeader(title = "External Search Traffic", disable = FALSE)

sidebar <- dashboardSidebar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css"),
    tags$script(src = "custom.js")
  ),
  sidebarMenu(menuItem(text = "Traffic"),
              menuSubItem(text = "Summary", tabName = "traffic_summary"),
              menuSubItem(text = "Pageviews by search engine", tabName = "traffic_by_engine")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "traffic_summary",
            platform_select("platform_traffic_summary"),
            dygraphOutput("traffic_summary_dygraph"),
            includeMarkdown("./tab_documentation/traffic_summary.md")
    ),
    tabItem(tabName = "traffic_by_engine",
            platform_select("platform_traffic_bysearch"),
            checkboxInput("platform_traffic_bysearch_log", label = "Log scale", value = FALSE),
            dygraphOutput("traffic_bysearch_dygraph"),
            includeMarkdown("./tab_documentation/traffic_byengine.md")
            
    )
  )
)

dashboardPage(header, sidebar, body, skin = "black",
              title = "External Search Dashboard | Discovery | Engineering | Wikimedia Foundation")
