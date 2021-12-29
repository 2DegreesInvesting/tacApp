library(tidyverse)
devtools::load_all()

test <- full()[1:30, ]

rows <- split(data, data$rowid)
prepared <- purrr::map(rows, ~prep_raw(data, .x))
enframed <- tibble::enframe(prepared)

useful <- enframed$value %>%
  map(~any(.x$category %in% useful_categories())) %>%
  unlist()

enframed %>% filter(useful)

keep(enframed, any(enframed$value %in% useful_categories()))

# save
# keep

summarized <- purrr::map(prepared, summarize_change)

usethis::use_data(DATASET, overwrite = TRUE)
