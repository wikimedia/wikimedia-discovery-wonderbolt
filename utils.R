library(magrittr)

# Read in the traffic data
read_traffic <- function() {

  # Read in the initial data.
  data <- polloi::read_dataset(path = "discovery/metrics/external_traffic/referer_data.tsv", col_types = "Dlccci") %>%
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
  interim <- split(interim, by = "access_method") %>%
    lapply(dplyr::select_, .dots = list(quote(-access_method))) # fixes smoothing
  interim$total <- data[, j = list(pageviews = sum(pageviews)),
                        by = c("date", "referer_class")]
  names(interim) <- c("desktop" = "Desktop", "mobile web" = "Mobile Web", "total" = "All")[names(interim)]
  summary_traffic_data <<- lapply(interim, tidyr::spread, key = "referer_class", value = "pageviews", fill = NA)

  # Proportion
  summary_traffic_data_prop <<- interim %>%
    lapply(dplyr::group_by, date) %>%
    lapply(dplyr::mutate, pageviews = 100 * pageviews / sum(pageviews)) %>%
    lapply(tidyr::spread, key = "referer_class", value = "pageviews", fill = NA)

  # Generate per-engine values
  interim <- data[is_search == TRUE,
                  j = list(pageviews = sum(pageviews)),
                  by = c("date", "search_engine", "access_method")]
  interim <- split(interim, by = "access_method") %>%
    lapply(dplyr::select_, .dots = list(quote(-access_method))) # fixes smoothing
  interim$total <- data[is_search == TRUE,
                        j = list(pageviews = sum(pageviews)),
                        by = c("date", "search_engine")]
  names(interim) <- c("desktop" = "Desktop", "mobile web" = "Mobile Web", "total" = "All")[names(interim)]
  bysearch_traffic_data <<- interim %>%
    lapply(dplyr::filter_, .dots = list(quote(search_engine != "Not referred by search"))) %>%
    lapply(tidyr::spread, key = "search_engine", value = "pageviews", fill = NA)

  # Proportion
  bysearch_traffic_data_prop <<- interim %>%
    lapply(dplyr::group_by, date) %>%
    lapply(dplyr::mutate, pageviews = 100 * pageviews / sum(pageviews)) %>%
    lapply(dplyr::filter_, .dots = list(quote(search_engine != "Not referred by search"))) %>%
    lapply(tidyr::spread, key = "search_engine", value = "pageviews", fill = NA)

  return(invisible())
}

# Read in the non-bot traffic data
read_nonbot_traffic <- function() {

  # Read in the initial data.
  data <- polloi::read_dataset(path = "discovery/metrics/external_traffic/referer_nonbot_data.tsv", col_types = "Dlccci") %>%
    dplyr::filter(!is.na(referer_class), !is.na(pageviews)) %>%
    dplyr::mutate(
      search_engine = dplyr::if_else(search_engine == "none", "Not referred by search", search_engine),
      referer_class = forcats::fct_recode(
        referer_class,
        `None (direct)` = "none",
        `Search engine` = "external (search engine)",
        `External (but not search engine)` = "external",
        Internal = "internal"
      )
    ) %>%
    data.table::as.data.table()

  # Write out the overall values for traffic
  interim <- data[, j = list(pageviews = sum(pageviews)),
                  by = c("date", "referer_class", "access_method")]
  interim <- split(interim, by = "access_method") %>%
    lapply(dplyr::select_, .dots = list(quote(-access_method))) # fixes smoothing
  interim$total <- data[, j = list(pageviews = sum(pageviews)),
                        by = c("date", "referer_class")]
  names(interim) <- c("desktop" = "Desktop", "mobile web" = "Mobile Web", "total" = "All")[names(interim)]
  summary_traffic_nonbot_data <<- lapply(interim, tidyr::spread, key = "referer_class", value = "pageviews", fill = NA)

  # Proportion
  summary_traffic_nonbot_data_prop <<- interim %>%
    lapply(dplyr::group_by, date) %>%
    lapply(dplyr::mutate, pageviews = 100 * pageviews / sum(pageviews)) %>%
    lapply(tidyr::spread, key = "referer_class", value = "pageviews", fill = NA)

  # Generate per-engine values
  interim <- data[is_search == TRUE,
                  j = list(pageviews = sum(pageviews)),
                  by = c("date", "search_engine", "access_method")]
  interim <- split(interim, by = "access_method") %>%
    lapply(dplyr::select_, .dots = list(quote(-access_method))) # fixes smoothing
  interim$total <- data[is_search == TRUE,
                        j = list(pageviews = sum(pageviews)),
                        by = c("date", "search_engine")]
  names(interim) <- c("desktop" = "Desktop", "mobile web" = "Mobile Web", "total" = "All")[names(interim)]
  bysearch_traffic_nonbot_data <<- interim %>%
    lapply(dplyr::filter_, .dots = list(quote(search_engine != "Not referred by search"))) %>%
    lapply(tidyr::spread, key = "search_engine", value = "pageviews", fill = NA)

  # Proportion
  bysearch_traffic_nonbot_data_prop <<- interim %>%
    lapply(dplyr::group_by, date) %>%
    lapply(dplyr::mutate, pageviews = 100 * pageviews / sum(pageviews)) %>%
    lapply(dplyr::filter_, .dots = list(quote(search_engine != "Not referred by search"))) %>%
    lapply(tidyr::spread, key = "search_engine", value = "pageviews", fill = NA)

  return(invisible())
}
