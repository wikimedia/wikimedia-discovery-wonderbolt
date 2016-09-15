library(shiny)
library(shinydashboard)
library(dygraphs)

function(request) {
  dashboardPage(

    dashboardHeader(title = "External Search Traffic", dropdownMenuOutput("message_menu"), disable = FALSE),

    dashboardSidebar(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css"),
        tags$script(src = "custom.js")
      ),
      sidebarMenu(id = "tabs",
                  menuItem(text = "Traffic",
                           menuSubItem(text = "Summary", tabName = "traffic_summary"),
                           menuSubItem(text = "Pageviews by search engine", tabName = "traffic_by_engine")),
                  menuItem(text = "Global Settings",
                           selectInput(inputId = "smoothing_global", label = "Smoothing", selectize = TRUE, selected = "day",
                                       choices = c("No Smoothing" = "day", "Weekly Median" = "week", "Monthly Median" = "month", "Splines" = "gam")),
                           icon = icon("cog", lib = "glyphicon"))
      ),
      div(icon("info-sign", lib = "glyphicon"), HTML("<strong>Tip</strong>: you can drag on the graphs with your mouse to zoom in on a particular date range."), style = "padding: 10px; color: white;"),
      div(bookmarkButton(), style = "text-align: center;")
    ),

    dashboardBody(
      tabItems(
        tabItem(tabName = "traffic_summary",
                fluidRow(
                  column(selectizeInput(inputId = "platform_traffic_summary", label = "Platform", choices = c("All", "Desktop", "Mobile Web")), width = 2),
                  column(polloi::smooth_select("smoothing_traffic_summary"), width = 3),
                  column(div(id = "traffic_summary_legend", style = "text-align: right;"), width = 7)),
                dygraphOutput("traffic_summary_dygraph"),
                includeMarkdown("./tab_documentation/traffic_summary.md")
        ),
        tabItem(tabName = "traffic_by_engine",
                fluidRow(
                  column(selectizeInput(inputId = "platform_traffic_bysearch", label = "Platform", choices = c("All", "Desktop", "Mobile Web")), width = 2),
                  column(HTML("<label class = \"control-label\" style = \"margin-bottom:-30px;\">Scale</label>"), checkboxInput("platform_traffic_bysearch_log", label = "Use Log scale", value = FALSE), width = 2),
                  column(polloi::smooth_select("smoothing_traffic_bysearch"), width = 3),
                  column(div(id = "traffic_bysearch_legend", style = "text-align: right;"), width = 5)),
                dygraphOutput("traffic_bysearch_dygraph"),
                includeMarkdown("./tab_documentation/traffic_byengine.md")
        )
      )
    ),

    skin = "black", title = "External Search Dashboard | Discovery | Engineering | Wikimedia Foundation")
}
