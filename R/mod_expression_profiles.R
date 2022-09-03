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
  fixedPage(
    id="expr-prof-page",
    fixedRow(
      column(
        id="expr-prof-query-panel",
        textInput(
          inputId = ns("protein"),
          label = "Protein",
          value = "",
          width = "275px",
          placeholder = "Enter an SGD ID..."
        ),
        selectInput(
          inputId = ns("site"),
          label = "Site",
          choices = list(""),
          selected = "Select 1",
          multiple = FALSE,
          selectize = TRUE,
          width = "275px",
          size = NULL
        ),
        checkboxGroupInput(
          inputId = ns("select_conditions"),
          label = "Select Conditions",
          choices = get_conditions()$code[-1],
          inline = TRUE,
          width = "275px",
          choiceNames = NULL,
          choiceValues = NULL
        ),
        actionButton(inputId = ns("select_all"), 
                     label = "Select All"),
        actionButton(inputId = ns("clear_all"), 
                     label = "Clear All"),
        width=3
      ),
      column(
        id="expr-prof-display-panel",
        textOutput(outputId = ns("title")),
        textOutput(outputId = ns("description")),
        plotOutput(
          outputId = ns("expression_profile_1"),
          width = "100%",
          height = "200px"
          ),
        plotOutput(
          outputId = ns("expression_profile_2"),
          width = "100%",
          height = "200px"
        ),
        plotOutput(
          outputId = ns("expression_profile_3"),
          width = "100%",
          height = "200px"
        ),
        plotOutput(
          outputId = ns("expression_profile_4"),
          width = "100%",
          height = "200px"
        ),
        width=9
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

    # Write description for user
    write_expression_profiles_description(input, output, session)
    
    # Lookup sites to fill drop down.
    observeEvent(input$protein, {
      load_protein_sites(input, output, session)
    })

    # Set initial condition checkboxes.
    observeEvent(input$site, {
      init_condition_checkboxes(input, output, session)
    })

    # Reload expression profile given a choice in conditions.
    observeEvent(input$select_conditions, {
      load_expression_profile(input, output, session)
    })

    # Reset initial condition checkboxes.
    observeEvent(input$select_all, {
      init_condition_checkboxes(input, output, session)
    })

    # Clear condition checkboxes
    observeEvent(input$clear_all, {
      updateCheckboxGroupInput(session = session, 
                               inputId = "select_conditions",
                               choices = get_conditions()$code[-1],
                               inline = TRUE)
    })
    
  })
}
    
## To be copied in the UI
# mod_expression_profiles_ui("expression_profiles_ui_1")
    
## To be copied in the server
# mod_expression_profiles_server("expression_profiles_ui_1")
