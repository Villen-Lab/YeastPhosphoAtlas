#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {

  # Preload protein and site data
  session$userData$preloadData <- TRUE
  
  # Your application server logic 
  mod_expression_profiles_server("expression_profiles_ui_1")
  mod_explore_conditions_server("explore_conditions_ui_1")
  mod_raw_data_server("raw_data_ui_1")
  mod_about_server("about_ui_1")
}
