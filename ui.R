library(shiny)
library(shinydashboard)
library(dygraphs)

#Header elements for the visualisation
header <- dashboardHeader(title = "External Search Traffic", dropdownMenuOutput("message_menu"), disable = FALSE)

sidebar <- dashboardSidebar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css"),
    tags$script(src = "custom.js")
  ),
  sidebarMenu(
    menuItem(text = "Traffic",
             menuSubItem(text = "Summary", tabName = "traffic_summary"),
             menuSubItem(text = "Pageviews by search engine", tabName = "traffic_by_engine")),
    menuItem(text = "Global Settings",
             selectInput(inputId = "smoothing_global", label = "Smoothing", selectize = TRUE, selected = "day",
                         choices = c("No Smoothing" = "day", "Weekly Median" = "week", "Monthly Median" = "month", "Splines" = "gam")),
             selectInput(inputId = "timeframe_global", label = "Time Frame", selectize = TRUE, selected = "",
                         choices = c("All available data" = "all", "Last 7 days" = "week", "Last 30 days" = "month",
                                     "Last 90 days" = "quarter", "Custom" = "custom")),
             conditionalPanel("input.timeframe_global == 'custom'",
                              dateRangeInput("daterange_global", label = "Custom Date Range",
                                             start = Sys.Date()-11, end = Sys.Date()-1, min = "2015-04-14")),
             icon = icon("cog", lib = "glyphicon"))
  ),
  div(icon("info-sign", lib = "glyphicon"), HTML("<strong>Tip</strong>: you can drag on the graphs with your mouse to zoom in on a particular date range."), style = "padding: 10px; color: white;")
)

# Custom function to allow for the selection betwene
platform_select <- function(name){
  return(selectizeInput(inputId = name, label = "Platform",
                        choices = c("All","Desktop","Mobile Web")))
}

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "traffic_summary",
            fluidRow(
              column(platform_select("platform_traffic_summary"), width = 3),
              column(polloi::smooth_select("smoothing_traffic_summary"), width = 3),
              column(polloi::timeframe_select("traffic_summary_timeframe"), width = 3),
              column(polloi::timeframe_daterange("traffic_summary_timeframe"), width = 3)),
            dygraphOutput("traffic_summary_dygraph"),
            div(id = "traffic_summary_legend", style = "text-align: right;"),
            includeMarkdown("./tab_documentation/traffic_summary.md")
    ),
    tabItem(tabName = "traffic_by_engine",
            fluidRow(
              column(platform_select("platform_traffic_bysearch"), width = 2),
              column(checkboxInput("platform_traffic_bysearch_log", label = "Log10 Scale", value = FALSE), width = 1),
              column(polloi::smooth_select("smoothing_traffic_bysearch"), width = 3),
              column(polloi::timeframe_select("traffic_bysearch_timeframe"), width = 3),
              column(polloi::timeframe_daterange("traffic_bysearch_timeframe"), width = 3)),
            dygraphOutput("traffic_bysearch_dygraph"),
            div(id = "traffic_bysearch_legend", style = "text-align: right;"),
            includeMarkdown("./tab_documentation/traffic_byengine.md")
    )
  )
)

dashboardPage(header, sidebar, body, skin = "black",
              title = "External Search Dashboard | Discovery | Engineering | Wikimedia Foundation")
