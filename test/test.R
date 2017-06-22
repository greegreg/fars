library(testthat)

expect_that(sum(fars_summarize_years(2014)[,2]), equals(30056))
