#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    navbarPage(
      "Yeast Phospho Atlas",
      tabPanel(
        "Expression Profiles",
        mod_expression_profiles_ui("expression_profiles_ui_1")
      ),
      tabPanel(
        "Explore Conditions",
        mod_explore_conditions_ui("explore_conditions_ui_1")
      ),
      tabPanel(
        "Raw Data",
        mod_raw_data_ui("raw_data_ui_1")
      ),
      tabPanel(
        "About"
      ),
      collapsible = TRUE
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'YeastPhosphoAtlas'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

