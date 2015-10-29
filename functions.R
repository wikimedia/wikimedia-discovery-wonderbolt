library(polloi)
library(data.table)

# Custom function to allow for the selection betwene
platform_select <- function(name){
  return(selectizeInput(inputId = name, label = "Platform",
                        choices = c("All","Desktop","Mobile Web")))
}

# Read in the traffic data
read_traffic <- function(){
  
  # Read in the initial data and format.
  data <- as.data.table(polloi::read_dataset(path = "external_traffic/referer_data.tsv"))
  data$is_search <- ifelse(data$is_search, "Referred by search", "Not referred by search")
  data$search_engine[data$search_engine == "None"] <- "Not referred by search"
  # Write out the overall values for traffic
  holding <- data[,j=list(pageviews = sum(pageviews)), by = c("timestamp", "is_search", "access_method")]
  holding <- split(holding, f = holding$access_method)
  holding$all <- data[,j=list(pageviews = sum(pageviews)), by = c("timestamp", "is_search")]
  names(holding) <- c("Desktop", "Mobile Web", "All")
  summary_traffic_data <<- lapply(holding, function(x){
    return(reshape2::dcast(x, formula = timestamp ~ is_search, fun.aggregate = sum))
  })

  # Generate per-engine values
  holding <- data[, j = list(pageviews = sum(pageviews)), by = c("timestamp", "search_engine", "access_method")]
  holding <- split(holding, f = holding$access_method)
  holding$all <- data[,j=list(pageviews = sum(pageviews)), by = c("timestamp", "search_engine")]
  names(holding) <- c("Desktop", "Mobile Web", "All")
  bysearch_traffic_data <<- lapply(holding, function(x){
    return(reshape2::dcast(x, formula = timestamp ~ search_engine, fun.aggregate = sum))
  })
  return(invisible())
}

logscale <- function(data, logscale_setting){
  if(logscale_setting){
    return(cbind(data[,1], as.data.frame(apply(data[,2:ncol(data)], 2, log10))))
  }
  return(data)
}
