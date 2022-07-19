#' explore_conditions UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_explore_conditions_ui <- function(id){
  ns <- NS(id)
  tagList(
    fixedPage(
      id="expl-cond-page",
      fixedRow(
        textOutput(outputId = ns("coming_soon_title")),
        textOutput(outputId = ns("coming_soon_description"))
      )
    )
  )
}
    
#' explore_conditions Server Functions
#'
#' @noRd 
mod_explore_conditions_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$coming_soon_title <- renderText({ "Coming Soon" })
    output$coming_soon_description <-
      renderText({
        paste("Check back in the future for deep dives into",
              "differential expression by treatment.")
      })
  })
}
    
## To be copied in the UI
# mod_explore_conditions_ui("explore_conditions_ui_1")
    
## To be copied in the server
# mod_explore_conditions_server("explore_conditions_ui_1")
