#'File extraction
#'
#'This function extracts data, in csv format, from the users current work directory.
#'This function is called by the fars_read_years and fars_map_state functions. It is not called
#'on its own. This file is not exported to the user.  Data is extracted using the readr package.
#'Once the data is read into R the dplyr package alters the look of the data frame
#'using the tbl_df function.
#'
#'@source Data is found at the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
#'
#'@param filename A character string providing the file location of the US National Highway Safety
#'         Administration's Fatality Analysis Reporting System data. The filename is constructed in the
#'         make_filename function, so this parameter should never have to be input direclty.
#'
#'@importFrom readr read_csv
#'
#'@importFrom dplyr tbl_df
#'
#'@details an error will be thrown if the filename does not exist, or is not in the
#'        current working directory telling the user the file does not exist.
#'
#'@return The function returns a tbl_df, tbl, data.frame object ready for manipulation.


fars_read <- function(filename) {
if(!file.exists(filename))
        stop("file '", filename, "' does not exist")
        data <- suppressMessages({
        readr::read_csv(filename, progress = FALSE)
})
dplyr::tbl_df(data)
}


#' Create a date specific file name.
#'
#' The function takes a single argment, which is a year defining a time period when data
#' from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
#' is available for this function. This function is not used directly by the user, it is called from the
#' fars_read_years and fars_map_state functions.
#'
#' @source US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
#'
#' @inheritParams fars_map_state
#'
#' @return This function returns a character string representing a file extension for the National
#'  Highway data available for extraction. The character string is then sent to the fars_read function.



make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("inst/extdata/accident_%d.csv.bz2", year)
}

#' Does a specific file exist
#'
#' This function determines if data is available in the US National Highway Traffic Safety
#' Administration's Fatality Analysis Reporting System for the a years specified by the user. If the file is
#' available then this function reads the data in and begins creating a data frame with Month and year in the
#' columns. If the year is not a year where data is available then an error will be sent to the screen indicating
#' that data is not available. This function will not be called directly by the user. It is called by
#' fars_summarize_years.
#'
#' @source  US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
#'
#' @inheritParams fars_summarize_years
#'
#' @importFrom dplyr mutate select
#'
#' @details An error will be generated if a year is given and no data is available for that year. This
#' allows the user to be aware of the years when data is available to this package.
#'
#' @return This function returns a list. Each element of the list contains the months and year that data is available.
#' If a year is not available an error is returned.


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

#' Table of traffic accidents per month per year.
#'
#' This function summarizes the number of traffic accidents for the requested years accross all states.
#' The data is presented in a tabular form.
#'
#' @source  US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
#'
#' @param years a numerical vector of years, or a vector that can be coerced into a numerical vector. The years
#'      when data are available include 2013, 2014, and 2015.
#'
#' @importFrom dplyr bind_rows group_by summarize
#'
#' @importFrom  tidyr spread
#'
#' @return The function returns a tbl_df, tbl, data.frame class that summarizes the number of accidents that have occured across all states in any given year.
#'
#' @examples
#'  \dontrun{DTA<-fars_summarize_years(c(2013, 2014))}
#'
#' @export

fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#'Map of state specific accidents
#'
#'This function takes two inputs which are used to extract traffic fatality information
#'for a given state and year. This information is used to place markers, indicated as points on a
#' map, showing where a traffic fatality occured. If there were no fatalities in a state during a given
#' year the function will generate an error stating there is no accident to plot. If you input an incorrect
#' state number then an error will indicate there is no state for the given number.
#'
#' @source  US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
#'
#' @param state.num a number between 1 and 51, excluding 3, that identifies a US state.
#'
#' @param year An integer or an object that can be coerced to an integer. Should be 2013, 2014, or 2015.
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
