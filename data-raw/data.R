# WARNING: Git ignores data/. You may recover it from the published app's bundle

if (exists("valid_rowids", "package:tacApp")) {
  valid_rowids <- tacApp::valid_rowids
} else {
  rlang::warn(c(
    "Discovering which rowids produce valid results, slooowly.",
    i = "Do you need to recover data/ from the bundle of the published app?"
  ))
  source(here::here("data-raw", "result.R"))
  valid_rowids <- "result" %>%
    data_raw_path() %>%
    dir_ls() %>%
    path_file() %>%
    path_ext_remove() %>%
    as.integer() %>%
    sort()
}

valid <- full() %>%
  filter(rowid %in% valid_rowids)

unique_rowids <- valid %>%
  select(rowid, target_company, subsidiary_company, technology) %>%
  distinct(target_company, subsidiary_company, technology, .keep_all = TRUE) %>%
  pull(rowid)

useful <- filter(valid, rowid %in% unique_rowids)
use_data(
  valid,
  valid_rowids,
  unique_rowids,
  useful,
  overwrite = TRUE
)
