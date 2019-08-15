basename_without_extension <- function(filename) {

  a <- strsplit(filename, "/", fixed = TRUE)[[1]]
  f <- a[length(a)]
  f <- sub("([^.]+.+)\\.[[:alnum:]]+$", "\\1", f)
  return(f)

}
