#' raw_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_raw_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    fixedPage(
      id="raw-data-page",
      fixedRow(
        textOutput(outputId = ns("raw_data_title"))
      ),
      fixedRow(
        id=ns("raw_data_table")
      )
    )
  )
}

#' raw_data Server Functions
#'
#' @noRd 
mod_raw_data_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$raw_data_title <- renderText({ "Raw Data" })
    write_raw_data_table_header(session)
    write_raw_data_table_items(session)
  })
}
    
## To be copied in the UI
# mod_raw_data_ui("raw_data_ui_1")
    
## To be copied in the server
# mod_raw_data_server("raw_data_ui_1")
