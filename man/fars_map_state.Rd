% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/farsfunctions.R
\name{fars_map_state}
\alias{fars_map_state}
\title{Map of state specific accidents}
\source{
US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
}
\usage{
fars_map_state(state.num, year)
}
\arguments{
\item{state.num}{a number between 1 and 51, excluding 3, that identifies a US state.}

\item{year}{An integer or an object that can be coerced to an integer. Should be 2013, 2014, or 2015.}
}
\value{
This function returns a picture of a state and a dot at each geographical location
  where an accident has occurred during the specified year.
}
\description{
This function takes two inputs which are used to extract traffic fatality information
for a given state and year. This information is used to place markers, indicated as points on a
map, showing where a traffic fatality occured. If there were no fatalities in a state during a given
year the function will generate an error stating there is no accident to plot. If you input an incorrect
state number then an error will indicate there is no state for the given number.
}
\details{
This function will throw and error if there is an invalled state given to the program.
  A message will be  displayed if a specific state for a given year reports no fatalities.
}
\examples{
  \dontrun{fars_map_state(4, 2014)
  fars_map_state(51, 2013)}

}
