
#'Read data from a file
#'
#'This function extracts data from the users current work directory for data in csv format.
#'The user must provide file location which is
#'the only agrument of this function. The data is extracted using the readr package.
#'Once the data is read into R the dplyr package alters the look of the data frame
#'using the tbl_df function.
#'
#'@source US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
#'
#'@param filename A character string providing the location of the file to be read.
#'
#'@importFrom readr read_csv
#'
#'@importFrom dplyr tbl_df
#'
#'@details an error will be thrown if the filename does not exist, or is not in the
#'current working directory.
#'
#'@return The function returns a tbl_df, tbl, data.frame object.
#'
#'@examples
#' \dontrun{fars_read("accident_2013.csv.bz2")}


fars_read <- function(filename) {
if(!file.exists(filename))
        stop("file '", filename, "' does not exist")
        data <- suppressMessages({
        readr::read_csv(filename, progress = FALSE)
})
dplyr::tbl_df(data)
}


#' Make a filename to read data for a specific year.
#'
#' The function takes a single argment, which is a year defining a time period when data
#' from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
#' is available for this function.
#'
#' @source US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
#'
#' @param year An integer or an object that can be coerced to an integer.
#'
#' @return This function returns a filename defining the file extension of the National
#'  Highway data available for extraction.
#'
#' @examples
#' \dontrun{make_filename(2013)
#' make_filename(2014)}


make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("data/accident_%d.csv.bz2", year)
}

#' Testing if a vector specified by the user has data available.
#'
#' This function determines if data is available in the US National Highway Traffic Safety
#' Administration's Fatality Analysis Reporting System for the a years specified by the user.
#'
#' @source  US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
#'
#' @param years is a numerical vector, or a vector that can be coerced to numerical, of years
#'
#' @importFrom dplyr mutate select
#'
#' @details An error will be generated if a year is given and no data is available for that year. This
#' allows the used to be aware of the years when data is available to this package.
#'
#' @return This function returns a list. Each element of the list contains the months and year that data is available.
#' If a year is not available an error is returned.
#'
#' @examples
#' \dontrun{fars_read_years(2013)
#' fars_read_years(c(2013,2014))
#' fars_read_years(c(2013,2014,2015))}


fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#' Summarizes the number of traffic accidents per month per year.
#'
#' This function summarizes the number of traffic accidents for the requested years accross all states.
#' The data is presented in a tabular form.
#'
#' @source  US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
#'
#' @param years is a numerical vector of years, or a vector that can be coerced into a numerical vector.
#'
#' @importFrom dplyr bind_rows group_by summarize
#'
#' @importFrom  tidyr spread
#'
#' @return The function returns a tbl_df, tbl, data.frame class that summarizes the number of accidents that have occured across all states in any given year.
#'
#' @export
#'
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#'Creates a picture of a state and where an auto accident occurred
#'
#'This function takes two inputs which are used to extract traffic fatality information
#'for a given state and year and then draws a map showing the regions for the fatalities.
#'
#' @source  US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
#'
#' @param state.num a number between 1 adn 51, excluding 3, that identifies a US state.
#'
#' @param year An integer or an object that can be coerced to an integer.
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @details This function will throw and error if there is an invalled state given to the program.
#'   A message will be  displayed if a specific state for a given year reports no fatalities.
#'
#' @return This function returns a picture of a state and a dot at each geographical location
#'   where an accident has occurred during the specified year.
#'
#' @examples
#'   \dontrun{fars_map_state(4, 2014)
#'   fars_map_state(51, 2013)}
#'
#'@export


fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
