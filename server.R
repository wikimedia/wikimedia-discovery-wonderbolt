library(shiny)
library(shinydashboard)
library(dygraphs)

source("utils.R")

existing_date <- Sys.Date() - 1

function(input, output, session) {

  if (Sys.Date() != existing_date) {
    progress <- shiny::Progress$new(session, min = 0, max = 1)
    on.exit(progress$close())
    progress$set(message = "Downloading overall pageview counts...", value = 0)
    read_traffic()
    progress$set(message = "Downloading non-bot pageview counts...", value = 1/2)
    read_nonbot_traffic()
    progress$set(message = "Finished downloading datasets.", value = 1)
    existing_date <<- Sys.Date()
  }

  output$traffic_summary_dygraph <- renderDygraph({
    input$include_automata_traffic_summary %>%
      polloi::data_select(
        polloi::data_select(
          input$platform_traffic_summary_prop,
          summary_traffic_data_prop[[input$platform_traffic_summary]],
          summary_traffic_data[[input$platform_traffic_summary]]
        ),
        polloi::data_select(
          input$platform_traffic_summary_prop,
          summary_traffic_nonbot_data_prop[[input$platform_traffic_summary]],
          summary_traffic_nonbot_data[[input$platform_traffic_summary]]
        )
      ) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_traffic_summary)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = ifelse(input$platform_traffic_summary_prop, "Pageview Share (%)", "Pageviews"),
                           title = "Sources of page views (e.g. search engines and internal referers)") %>%
      dyLegend(labelsDiv = "traffic_summary_legend", show = "always", showZeroValues = FALSE) %>%
      dyAxis("x", axisLabelFormatter = polloi::custom_axis_formatter, axisLabelWidth = 70) %>%
      dyAxis("y", logscale = input$platform_traffic_summary_log) %>%
      dyRangeSelector(fillColor = ifelse(input$platform_traffic_summary_prop, "", "#A7B1C4"),
                      strokeColor = ifelse(input$platform_traffic_summary_prop, "", "#808FAB"),
                      retainDateWindow = TRUE) %>%
      dyEvent(as.Date("2016-03-07"), "A (new UDF)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-06-26"), "B (DuckDuckGo)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2020-05-01"), "U (automated users)", labelLoc = "bottom")
  })

  output$traffic_bysearch_dygraph <- renderDygraph({
    input$include_automata_traffic_bysearch %>%
      polloi::data_select(
        polloi::data_select(
          input$platform_traffic_bysearch_prop,
          bysearch_traffic_data_prop[[input$platform_traffic_bysearch]],
          bysearch_traffic_data[[input$platform_traffic_bysearch]]
        ),
        polloi::data_select(
          input$platform_traffic_bysearch_prop,
          bysearch_traffic_nonbot_data_prop[[input$platform_traffic_bysearch]],
          bysearch_traffic_nonbot_data[[input$platform_traffic_bysearch]]
        )
      ) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_traffic_bysearch)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = ifelse(input$platform_traffic_bysearch_prop, "Pageview Share (%)", "Pageviews"),
                           title = "Pageviews from external search engines, broken down by engine") %>%
      dyLegend(labelsDiv = "traffic_bysearch_legend", show = "always", showZeroValues = FALSE) %>%
      dyAxis("x", axisLabelFormatter = polloi::custom_axis_formatter, axisLabelWidth = 70) %>%
      dyAxis("y", logscale = input$platform_traffic_bysearch_log) %>%
      dyRangeSelector(fillColor = ifelse(input$platform_traffic_bysearch_prop, "", "#A7B1C4"),
                      strokeColor = ifelse(input$platform_traffic_bysearch_prop, "", "#808FAB"),
                      retainDateWindow = TRUE) %>%
      dyEvent(as.Date("2016-06-26"), "A (DuckDuckGo)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2020-05-01"), "U (automated users)", labelLoc = "bottom")
  })

  output$google_ratio_dygraph <- renderDygraph({
    req(length(input$platform_google_ratio) > 0)
    google_ratio_nonbot_data[input$platform_google_ratio] %>%
      dplyr::bind_rows(.id = "access_method") %>%
      { .$metric <- .[[input$metric_google_ratio]]; . } %>%
      .[, c("date", "access_method", "metric"), with = FALSE] %>%
      tidyr::spread(access_method, metric) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_google_ratio)) %>%
      polloi::make_dygraph(xlab = "Date",
                           ylab = ifelse(input$metric_google_ratio == "Proportion", "Google-referred %", "Google / Other external referrers"),
                           title = "Google-referred pageviews in externally referred traffic") %>%
      dyLegend(show = "always", labelsDiv = "google_ratio_legend") %>%
      dyRangeSelector(fillColor = "", retainDateWindow = TRUE)
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
