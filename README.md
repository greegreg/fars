<!-- README.md is generated from README.Rmd. Please edit that file -->
### Status

[![Build Status](https://travis-ci.org/greegreg/fars.svg?branch=master)](https://travis-ci.org/greegreg/fars)

Traffic Fatality Analysis
-------------------------

Usage of this package requires the user to download data from [fars\_data.zip](https://d18ky98rnyall9.cloudfront.net/_e1adac2a5f05192dc8780f3944feec13_fars_data.zip?Expires=1499385600&Signature=ITQ5sWjdExbe52CekvVQtKxflkNZKMOovaLIZ2AzhPNLULBD5Pula~0WN3r70v3sPNi5iq7GeuneYiQWH-Zv7KQjm9cRpzvNw2EXtl5tvosxUojVXBbpYqT8SlvcB9aSERaYDhKS1B74geu2Gr3ia8d27rHM52lHZbv7lSsMowQ_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A). This data contains traffic fatality information for the years 2013 - 2015. The data should be unzipped and placed in the working directory of your computer.

### fars\_summarize\_years

This function takes a vector of integers as an argument. The integers are years representing years when traffic fatility data is available, which currently includes 2013 - 2015. The traffic fatality data is then summarized and a table is constructed showing the number of fatalities by month across all states.

``` r
#DF<-fars_summarize_years(c(2013,2014))
#kable(DF)
```

### fars\_map\_state

This function is very different. There are two arguments to this function state.num, a number between 1 and 51, excluding 3. The second input is a year. This time year is singular, so would be 2013, 2014, or 2015.

The output of this function is a map of the chosen state and the locations of each fatality is represented as a dot on the map.

``` r
#fars_map_state(16, 2014)
```
