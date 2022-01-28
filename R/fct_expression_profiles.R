#' Fill protein site dropdown menu
#'
#' @param input,output,session Internal parameters for {shiny}..
#'
#' @noRd
load_protein_sites <- function(input, output, session) {
  if (str_length(input$protein) == 7) { # FIX
    print(paste("Protein chosen:", input$protein))
    sites <- get_sites_by_prot_ref(input$protein)
    site_ids <- as.list(sites$id)
    names(site_ids) <- paste0(sites$residue, sites$position)
    updateSelectInput(session = session, inputId = "site", 
                      choices = c("Select 1" = 0, site_ids))
  }
}

#' Build ggplot output for expression profile
#'
#' @param quants Filtered dataframe of quantifications
#'
#' @noRd
build_expression_profile <- function(quants) {
  plt <- ggplot(quants, aes(x=condition, y=intensityRaw)) +
           geom_point(size = 5) +
           xlab("Condition") +
           ylab("Expression Value") +
           theme_bw() +
           theme(axis.text = element_text(size=24),
                 axis.title = element_text(size=24))
  
  return(plt)
}

#' Load expression data
#'
#' @param input,output,session Internal parameters for {shiny}..
#'
#' @noRd
display_expression_profile <- function(input, output, session) {
  if (input$site != "" && input$site != 0) {
    print(paste("Site chosen:", input$site))
    quants <- get_quants_by_site_id(input$site) %>%
      filter(condition %in% c("UT", input$select_treatments))
    output$expression_profile <- renderPlot({
      build_expression_profile(quants)
    })
  }
}