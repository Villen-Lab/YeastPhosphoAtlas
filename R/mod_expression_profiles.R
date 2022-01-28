#' expression_profiles UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_expression_profiles_ui <- function(id){
  ns <- NS(id)
  sidebarLayout(
    sidebarPanel(
      textInput(
        inputId = ns("protein"),
        label = "Protein",
        value = "",
        width = "200px", 
        placeholder = NULL
      ),
      selectInput(
        inputId = ns("site"),
        label = "Site",
        choices = list(""),
        selected = "Select 1",
        multiple = FALSE,
        selectize = TRUE,
        width = "200px",
        size = NULL
      ),
      checkboxGroupInput(
        inputId = ns("select_treatments"),
        label = "Select Treatments",
        choices = c("AA", "MZ", "I3", "I5", "I7", "I8"),
        selected = c("AA", "MZ", "I3", "I5", "I7", "I8"),
        inline = FALSE,
        width = "200px",
        choiceNames = NULL,
        choiceValues = NULL
      )
    ),
    mainPanel(
      plotOutput(
        outputId = ns("expression_profile"), 
        width = "100%",
        height = "400px"
      )
    )
  )
}
    
#' expression_profiles Server Functions
#'
#' @import stringr dplyr ggplot2
#' @noRd 
mod_expression_profiles_server <- function(id){
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Lookup sites to fill drop down.
    observeEvent(input$protein, {
      load_protein_sites(input, output, session)
      })
    
    # Load expression profile given a choice in site.
    observe({
      display_expression_profile(input, output, session)
      })
    
  })
}
    
## To be copied in the UI
# mod_expression_profiles_ui("expression_profiles_ui_1")
    
## To be copied in the server
# mod_expression_profiles_server("expression_profiles_ui_1")
