library(shiny)
library(shinydashboard)
library(dygraphs)

source("utils.R")

existing_date <- Sys.Date() - 1

function(input, output, session) {

  if (Sys.Date() != existing_date) {
    read_traffic()
    existing_date <<- Sys.Date()
  }

  output$traffic_summary_dygraph <- renderDygraph({
    summary_traffic_data[[input$platform_traffic_summary]] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_traffic_summary)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Pageviews",
                           title = "Sources of page views (e.g. search engines and internal referers)") %>%
      dyLegend(labelsDiv = "traffic_summary_legend", show = "always", showZeroValues = FALSE) %>%
      dyRangeSelector(retainDateWindow = TRUE) %>%
      dyEvent(as.Date("2016-03-07"), "A (new UDF)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-06-26"), "B (DuckDuckGo)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  })

  output$traffic_bysearch_dygraph <- renderDygraph({
    input$platform_traffic_bysearch_prop %>%
      polloi::data_select(bysearch_traffic_data_prop[[input$platform_traffic_bysearch]],
                          bysearch_traffic_data[[input$platform_traffic_bysearch]]) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_traffic_bysearch)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = ifelse(input$platform_traffic_bysearch_prop, "Pageview Share (%)", "Pageviews"),
                           title = "Pageviews from external search engines, broken down by engine") %>%
      dyLegend(labelsDiv = "traffic_bysearch_legend", show = "always", showZeroValues = FALSE) %>%
      dyAxis("y", logscale = input$platform_traffic_bysearch_log) %>%
      dyRangeSelector(fillColor = ifelse(input$platform_traffic_bysearch_prop, "", "#A7B1C4"),
                      strokeColor = ifelse(input$platform_traffic_bysearch_prop, "", "#808FAB"),
                      retainDateWindow = TRUE) %>%
      dyEvent(as.Date("2016-06-26"), "A (DuckDuckGo)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
  })

  # Check datasets for missing data and notify user which datasets are missing data (if any)
  output$message_menu <- renderMenu({
    notifications <- list(
      polloi::check_yesterday(summary_traffic_data[['All']], "referrer data"),
      polloi::check_past_week(summary_traffic_data[['All']], "referrer data"))
    notifications <- notifications[!sapply(notifications, is.null)]
    return(dropdownMenu(type = "notifications", .list = notifications))
  })

}
