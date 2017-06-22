<!-- README.md is generated from README.Rmd. Please edit that file -->
The package fars requires the following packages to operate.

``` r

#library(dplyr)
#library(maps)
#library(tidyr)
#library(fars)
```

Traffic Fatality Analysis
-------------------------

Traffic fatalities are recorded by the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System (NHTSA). This package extracts data for the years 2013, 2014, and 2015. The fatalities can be summarized in one of two ways, a table for each month of each year or in a map of a specific state.

The function fars\_summarize\_years uses the traffic fatality data set and summarizes the data in that set.

``` r
#fars_summarize_years <- function(years) {
#        dat_list <- fars_read_years(years)
#        dplyr::bind_rows(dat_list) %>% 
#                dplyr::group_by(year, MONTH) %>% 
#                dplyr::summarize(n = n()) %>%
#                tidyr::spread(year, n)
#}
#kable(fars_summarize_years(c(2013,2014)))
```

Thu function fars\_map\_state() uses the data from the NSTSA and plots a year's traffic fatalities in a map of the state where the fatalities occured, if there were traffic fatalities in that state for that year.

``` r
#fars_map_state <- function(state.num, year) {
#        filename <- make_filename(year)
#        data <- fars_read(filename)
#        state.num <- as.integer(state.num)
#
#        if(!(state.num %in% unique(data$STATE)))
#                stop("invalid STATE number: ", state.num)
#        data.sub <- dplyr::filter(data, STATE == state.num)
#        if(nrow(data.sub) == 0L) {
#                message("no accidents to plot")
#                return(invisible(NULL))
#        }
#        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
#        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
#        with(data.sub, {
#                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
#                          xlim = range(LONGITUD, na.rm = TRUE))
#                graphics::points(LONGITUD, LATITUDE, pch = 46)
#        })
#}

#fars_map_state(16, 2013)
#fars_map_state(13,2015)
```
