library(dplyr)
library(glue)
library(readr)
library(fs)
devtools::load_all()

dir_create(data_raw_path("result"))

n <- nrow(valid)
data <- slice_head(valid, n = n)

answer <- menu(c("Continue", "Cancel"), title = glue("Iterate over {n} items?"))
if (answer == 2) stop("Do you need to adjust `n` and retry?", call. = FALSE)

for (i in seq_along(data$rowid)) {
  result <- prep_raw(data, slice(data, i))
  if (any(result$category %in% useful_categories())) {
    write_csv(result, data_raw_path("result", glue("{data$rowid[i]}.csv")))
  }
}
