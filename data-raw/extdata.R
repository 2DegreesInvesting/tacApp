data <- full()[1:10, ]

library(dplyr)
library(here)
library(glue)
library(vroom)
library(fs)
devtools::load_all()

c("result", "summary", "plot") %>%
  extdata_path() %>%
  map(dir_create)

for (i in data$rowid) {
  result <- prep_raw(data, slice(data, i))
  if (any(result$category %in% useful_categories())) {
    vroom_write(result, extdata_path("result", glue("{i}.csv")))

    summary <- summarize_change(result)
    vroom_write(summary, extdata_path("summary", glue("{i}.csv")))

    plot <- plot_techs(result, aspect.ratio = 1 / 1)
    write_rds(plot, extdata_path("plot", glue("{i}.ids")))
  }
}
