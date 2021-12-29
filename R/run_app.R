#' Run the tacApp
#'
#' @return Called for its side effect.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
run_app <- function() {
  ui <- fluidPage(
    tabsetPanel(
      id = "tabs",
      tabPanel(
        "Search and select one row",
        mainPanel(DTOutput("row_selector"))
      ),
      tabPanel(
        "View changes",
        mainPanel(
          tableOutput("summary"),
          plotOutput("plot")
        )
      ),
      tabPanel(
        "Download results",
        DTOutput("table"),
        downloadButton(
          "download", "Download results",
          class = "btn-lg btn-success"
        )
      )
    )
  )

  shinyApp(ui, server)
}

server <- function(input, output, session) {
  known_id <- 1L
  default <- list(mode = "single", selected = known_id, target = "row")
  output$row_selector <- renderDT(
    select_output_columns(useful),
    selection = default,
    filter = "top"
  )

  rowid <- reactive(useful[input$row_selector_rows_selected, "rowid"][[1]])

  data <- reactive({
    path <- installed_source_extdata_path("result", glue("{rowid()}.csv"), mustWork = TRUE)
    vroom::vroom(path, show_col_types = FALSE)
  })

  output$summary <- renderTable({
    if (!has_useful_categories(data())) {
      validate(glue("
        There is no data for the company and technology you selected.
        Do you need to search and select another row?
      "))
    }
    req(has_useful_categories(data()))

    path <- installed_source_extdata_path("summary", glue("{rowid()}.csv"), mustWork = TRUE)
    out <- vroom::vroom(path, show_col_types = FALSE)
    out <- round_percent_columns(out)
    names(out) <- format_summary_names(names(out))
    out
  })

  output$plot <- renderPlot(
    {
      req(has_useful_categories(data()))
      path <- installed_source_extdata_path("plot", glue("{rowid()}.rds"), mustWork = TRUE)
      plot <- readr::read_rds(path)
      plot
    },
    res = match_rstudio(),
    height = function() {
      # https://github.com/rstudio/shiny/issues/650#issuecomment-62443654
      session$clientData$output_plot_width
    }
  )

  output$table <- renderDT(data())
  output$download <- download(data())
}

download <- function(data) {
  downloadHandler(
    filename = function() "tacApp.csv",
    content = function(file) write_csv(data, file)
  )
}
