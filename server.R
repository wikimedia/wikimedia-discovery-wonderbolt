source("utils.R")

existing_date <- Sys.Date() - 1

shinyServer(function(input, output){
  
  if (Sys.Date() != existing_date) {
    read_traffic()
    existing_date <<- Sys.Date()
  }
  
  # Wrap time_frame_range to provide global settings
  time_frame_range <- function(input_local_timeframe, input_local_daterange) {
    return(polloi::time_frame_range(input_local_timeframe, input_local_daterange, input$timeframe_global, input$daterange_global))
  }
  
  output$traffic_summary_dygraph <- renderDygraph({
    summary_traffic_data[[input$platform_traffic_summary]] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_traffic_summary)) %>%
      polloi::subset_by_date_range(time_frame_range(input$traffic_summary_timeframe, input$traffic_summary_timeframe_daterange)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Pageviews",
                           title = "Sources of page views (e.g. search engines and internal referers)") %>%
      dyLegend(labelsDiv = "traffic_summary_legend", show = "always", showZeroValues = FALSE) %>%
      dyRangeSelector %>%
      dyEvent(as.Date("2016-03-07"), "A (new UDF)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-06-26"), "B (DuckDuckGo)", labelLoc = "bottom")
  })
  
  output$traffic_bysearch_dygraph <- renderDygraph({
    bysearch_traffic_data[[input$platform_traffic_bysearch]] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_traffic_bysearch)) %>%
      polloi::subset_by_date_range(time_frame_range(input$traffic_bysearch_timeframe, input$traffic_bysearch_timeframe_daterange)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Pageviews",
                           title = "Pageviews from external search engines, broken down by engine") %>%
      dyLegend(labelsDiv = "traffic_bysearch_legend", show = "always", showZeroValues = FALSE) %>%
      dyAxis("y", logscale = input$platform_traffic_bysearch_log) %>%
      dyRangeSelector(fillColor = "", strokeColor = "") %>%
      dyEvent(as.Date("2016-06-26"), "A (DuckDuckGo)", labelLoc = "bottom")
  })
  
  # Check datasets for missing data and notify user which datasets are missing data (if any)
  output$message_menu <- renderMenu({
    notifications <- list(
      polloi::check_yesterday(summary_traffic_data[['All']], "referrer data"),
      polloi::check_past_week(summary_traffic_data[['All']], "referrer data"))
    notifications <- notifications[!sapply(notifications, is.null)]
    return(dropdownMenu(type = "notifications", .list = notifications))
  })
  
})
