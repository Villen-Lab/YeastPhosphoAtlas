#' Write column headers for raw data table
#'
#' @param input,output,session Internal parameters for {shiny}..
#'
#' @noRd
write_raw_data_table_header <- function(session) {
  ns <- session$ns
  
  # Insert row for header
  insertUI(
    paste("#", ns("raw_data_table"), sep=""),
    where = "beforeEnd",
    fixedRow(id=ns("raw_data_table_header"))
  )
  
  # Insert individual column titles
  n_col <- length(raw_data_info$column_sizes)
  for (col_ind in 1:n_col) {
    col_name <- raw_data_info$header[[col_ind]]
    col_size <- raw_data_info$column_sizes[[col_ind]]
    insertUI(
      paste("#", ns("raw_data_table_header"), sep=""),
      where = "beforeEnd",
      column(col_size, p(col_name))
    )
  }
}

#' Write items for raw data table
#'
#' @param input,output,session Internal parameters for {shiny}..
#'
#' @noRd
write_raw_data_table_items <- function(session) {
  ns <- session$ns
  
  n_items <- length(raw_data_info$assets)
  for (item_ind in 1:n_items) {
    # Insert row for header
    item_id <- paste0("raw_data_table_item_", item_ind)
    insertUI(
      paste("#", ns("raw_data_table"), sep=""),
      where = "beforeEnd",
      fixedRow(id=ns(item_id))
    )
  
    # Insert individual column titles
    n_col <- length(raw_data_info$column_sizes)
    for (col_ind in 1:n_col) {
      col_value <- raw_data_info$assets[[item_ind]][[col_ind]]
      col_size <- raw_data_info$column_sizes[[col_ind]]
      
      if (raw_data_info$header[[col_ind]] != "Link") {
        element = p(col_value)
      } else{
        element = a("Link", href=col_value)
      }
      insertUI(
        paste("#", ns(item_id), sep=""),
        where = "beforeEnd",
        column(col_size, element)
      )
    }
  }
}

########
# Data #
########

raw_data_info = list(
  column_sizes = list(4, 6, 2), # Must add up to 12
  header = list("Asset", "Description", "Link"),
  assets = list(
    pride = list(
      asset = "PRIDE Repository",
      description = "Repository for all raw data and initial analyses described in the paper.",
      link = "/" # Can be true link
    )
  )
)
