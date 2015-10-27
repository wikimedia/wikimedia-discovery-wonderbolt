source("functions.R")

existing_date <- Sys.Date() - 1

shinyServer(function(input, output){
  
  if (Sys.Date() != existing_date) {
    read_traffic()
    existing_date <<- Sys.Date()
  }
  
  output$traffic_summary_dygraph <- renderDygraph({
    polloi::make_dygraph(
      data = summary_traffic_data[[input$platform_traffic_summary]],
      xlab = "Date", ylab = "Pageviews", title = "Pageviews from external search engines")
  })
  
  output$traffic_bysearch_dygraph <- renderDygraph({
    polloi::make_dygraph(
      data = logscale(bysearch_traffic_data[[input$platform_traffic_bysearch]], input$platform_traffic_bysearch_log),
      xlab = "Date", ylab = "Pageviews", title = "Pageviews from external search engines, broken down by engine")
  })
})
