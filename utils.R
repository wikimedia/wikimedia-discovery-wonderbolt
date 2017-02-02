library(magrittr)

# Read in the traffic data
read_traffic <- function() {

  # Read in the initial data.
  data <- polloi::read_dataset(path = "discovery/external_traffic/referer_data.tsv", col_types = "Dlccci") %>%
    dplyr::filter(!is.na(referer_class), !is.na(pageviews)) %>%
    dplyr::mutate(
      search_engine = dplyr::if_else(search_engine == "none", "Not referred by search", search_engine),
      referer_class = forcats::fct_recode(
        referer_class,
        `None (direct)` = "none",
        `Search engine` = "external (search engine)",
        `External (but not search engine)` = "external",
        Internal = "internal",
        Unknown = "unknown"
      )
    ) %>%
    data.table::as.data.table()

  # Write out the overall values for traffic
  interim <- data[, j = list(pageviews = sum(pageviews)),
                  by = c("date", "referer_class", "access_method")]
  interim <- split(interim, f = interim$access_method)
  interim$total <- data[,j = list(pageviews = sum(pageviews)),
                        by = c("date", "referer_class")]
  names(interim) <- c("Desktop", "Mobile Web", "All")
  summary_traffic_data <<- lapply(interim, tidyr::spread, key = "referer_class", value = "pageviews", fill = NA)

  # Generate per-engine values
  interim <- data[is_search == TRUE,
                  j = list(pageviews = sum(pageviews)),
                  by = c("date", "search_engine", "access_method")]
  interim <- split(interim, f = interim$access_method)
  interim$total <- data[is_search == TRUE,
                        j = list(pageviews = sum(pageviews)),
                        by = c("date", "search_engine")]
  names(interim) <- c("Desktop", "Mobile Web", "All")
  bysearch_traffic_data <<- interim %>%
    lapply(dplyr::filter_, .dots = list(quote(search_engine != "Not referred by search"))) %>%
    lapply(tidyr::spread, key = "search_engine", value = "pageviews", fill = NA)

  return(invisible())
}
