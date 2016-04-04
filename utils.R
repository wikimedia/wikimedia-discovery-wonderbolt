library(polloi)
library(data.table)

# Read in the traffic data
read_traffic <- function() {
  
  # Read in the initial data.
  data <- polloi::read_dataset(path = "external_traffic/referer_data.tsv")
  
  # Deduplicate
  # data <- data[!duplicated(data[,1:(ncol(data) - 1), with=FALSE], fromLast = TRUE)]
  # Not sure what happened between 2016-02-04 and 2016-03-06 that caused the pageviews to
  # come out split.
  
  # Format
  data$is_search <- ifelse(data$is_search, "Referred by search", "Not referred by search")
  data$search_engine[data$search_engine == "none"] <- "Not referred by search"
  data$referer_class[data$referer_class == "none"] <- "none (direct)"
  data$referer_class[data$referer_class == "external (search engine)"] <- "search engine"
  data$referer_class[data$referer_class == "external"] <- "external but not search engine"
  data <- as.data.table(data)
  
  # Write out the overall values for traffic
  holding <- data[, j = list(pageviews = sum(pageviews)),
                  by = c("date", "referer_class", "access_method")]
  holding <- split(holding, f = holding$access_method)
  holding$total <- data[,j = list(pageviews = sum(pageviews)),
                        by = c("date", "referer_class")]
  names(holding) <- c("Desktop", "Mobile Web", "All")
  summary_traffic_data <<- lapply(holding, function(x){
    return(reshape2::dcast(x, formula = date ~ referer_class, fun.aggregate = sum))
  })
  
  # Generate per-engine values
  holding <- data[which(data$referer_class == "search engine"),
                  j = list(pageviews = sum(pageviews)),
                  by = c("date", "search_engine", "access_method")]
  holding <- split(holding, f = holding$access_method)
  holding$all <- data[which(data$referer_class == "search engine"),
                      j = list(pageviews = sum(pageviews)),
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
