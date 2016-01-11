#### Function for moving a specified column(s) to end of a data frame
movetolast <- function(data, move) {
  data[c(setdiff(names(data), move), move)]
}

df<-movetolast(df, c("b", "c"))