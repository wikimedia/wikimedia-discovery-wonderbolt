library(polloi)
library(data.table)

# Read in the traffic data
read_traffic <- function() {
  
  # Read in the initial data and format.
  data <- polloi::read_dataset(path = "external_traffic/referer_data.tsv") %>%
    dplyr::rename(date = timestamp) %>%
    as.data.table
  data$is_search <- ifelse(data$is_search, "Referred by search", "Not referred by search")
  data$search_engine[data$search_engine == "None"] <- "Not referred by search"
  
  # Write out the overall values for traffic
  holding <- data[, j = list(pageviews = sum(pageviews)),
                  by = c("date", "is_search", "access_method")]
  holding <- split(holding, f = holding$access_method)
  holding$all <- data[,j = list(pageviews = sum(pageviews)),
                      by = c("date", "is_search")]
  names(holding) <- c("Desktop", "Mobile Web", "All")
  summary_traffic_data <<- lapply(holding, function(x){
    return(reshape2::dcast(x, formula = date ~ is_search, fun.aggregate = sum))
  })
  
  # Generate per-engine values
  holding <- data[, j = list(pageviews = sum(pageviews)),
                  by = c("date", "search_engine", "access_method")]
  holding <- split(holding, f = holding$access_method)
  holding$all <- data[, j = list(pageviews = sum(pageviews)),
                      by = c("date", "search_engine")]
  names(holding) <- c("Desktop", "Mobile Web", "All")
  bysearch_traffic_data <<- lapply(holding, function(x){
    return(reshape2::dcast(x, formula = date ~ search_engine, fun.aggregate = sum))
  })
  
  return(invisible())
}

logscale <- function(data, logscale_setting){
  if (logscale_setting) {
    return(cbind(date = data$date, as.data.frame(apply(data[, 2:ncol(data)], 2, log10))))
  }
  return(data)
}
