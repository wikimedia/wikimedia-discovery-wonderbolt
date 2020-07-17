library(shiny)
library(shinydashboard)
library(dygraphs)

spider_checkbox <- function(input_id) {
  shiny::checkboxInput(input_id, "Include automata", value = TRUE, width = NULL)
}

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
                           menuSubItem(text = "Pageviews by search engine", tabName = "traffic_by_engine"),
                           menuSubItem(text = "Google ratio", tabName = "google_ratio")),
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
        tabItem(
          tabName = "traffic_summary",
          fluidRow(
            column(selectizeInput(inputId = "platform_traffic_summary", label = "Platform", choices = c("All", "Desktop", "Mobile Web")), width = 3),
            column(HTML("<label class = \"control-label\" style = \"margin-bottom:-30px;\">Data</label>"),
                   spider_checkbox("include_automata_traffic_summary"), width = 2),
            column(conditionalPanel("!input.platform_traffic_summary_prop", HTML("<label class = \"control-label\" style = \"margin-bottom:-30px;\">Scale</label>")),
                   conditionalPanel("!input.platform_traffic_summary_prop", checkboxInput("platform_traffic_summary_log", label = "Use Log scale", value = FALSE)),
                   width = 2),
            column(conditionalPanel("!input.platform_traffic_summary_log", HTML("<label class = \"control-label\" style = \"margin-bottom:-30px;\">Type</label>")),
                   conditionalPanel("!input.platform_traffic_summary_log", checkboxInput("platform_traffic_summary_prop", label = "Use Proportion", value = FALSE)),
                   width = 2),
            column(polloi::smooth_select("smoothing_traffic_summary"), width = 3)),
          dygraphOutput("traffic_summary_dygraph"),
          div(id = "traffic_summary_legend", style = "text-align: right;"),
          includeMarkdown("./tab_documentation/traffic_summary.md")
        ),
        tabItem(
          tabName = "traffic_by_engine",
          fluidRow(
            column(selectizeInput(inputId = "platform_traffic_bysearch", label = "Platform", choices = c("All", "Desktop", "Mobile Web")), width = 3),
            column(HTML("<label class = \"control-label\" style = \"margin-bottom:-30px;\">Data</label>"),
                   spider_checkbox("include_automata_traffic_bysearch"), width = 2),
            column(conditionalPanel("!input.platform_traffic_bysearch_prop", HTML("<label class = \"control-label\" style = \"margin-bottom:-30px;\">Scale</label>")),
                   conditionalPanel("!input.platform_traffic_bysearch_prop", checkboxInput("platform_traffic_bysearch_log", label = "Use Log scale", value = FALSE)),
                   width = 2),
            column(conditionalPanel("!input.platform_traffic_bysearch_log", HTML("<label class = \"control-label\" style = \"margin-bottom:-30px;\">Type</label>")),
                   conditionalPanel("!input.platform_traffic_bysearch_log", checkboxInput("platform_traffic_bysearch_prop", label = "Use Proportion", value = FALSE)),
                   width = 2),
            column(polloi::smooth_select("smoothing_traffic_bysearch"), width = 3)),
          dygraphOutput("traffic_bysearch_dygraph"),
          div(id = "traffic_bysearch_legend", style = "text-align: right;"),
          includeMarkdown("./tab_documentation/traffic_by_engine.md")
        ),
        tabItem(
          tabName = "google_ratio",
          fluidRow(
            column(checkboxGroupInput("platform_google_ratio", "Platform",
                                      choices = c("All", "Desktop", "Mobile Web"),
                                      selected = c("All", "Desktop", "Mobile Web"),
                                      inline = TRUE),
                   width = 5),
            column(radioButtons("metric_google_ratio", "Metric",
                                choices = c("Ratio", "Proportion"),
                                selected = "Proportion",
                                inline = TRUE),
                   width = 4),
            column(polloi::smooth_select("smoothing_google_ratio"), width = 3)
          ),
          dygraphOutput("google_ratio_dygraph"),
          div(id = "google_ratio_legend", style = "text-align: right;"),
          includeMarkdown("./tab_documentation/google_ratio.md")
        )
      ) # end tabItems
    ), # end dashboardBody

    skin = "black",
    title = "External Search Traffic Dashboard | Product Analytics | Wikimedia Foundation"
  ) # end dashboardPage
}
