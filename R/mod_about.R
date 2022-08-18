#' about UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_about_ui <- function(id){
  ns <- NS(id)
  tagList(
    fixedPage(
      id="about-page",
      fixedRow(
        textOutput(outputId = ns("about_title"))
      ),
      fixedRow(
        column(12, includeMarkdown(
          system.file("content", "about.md", 
                      package = "YeastPhosphoAtlas")
          ),
          class = "text-justify"
        )
      ),
    )
  )
}
    
#' about Server Functions
#'
#' @noRd 
mod_about_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$about_title <- renderText({ "About the YeastPhosphoAtlas" })
  })
}
    
## To be copied in the UI
# mod_about_ui("about_ui_1")
    
## To be copied in the server
# mod_about_server("about_ui_1")
