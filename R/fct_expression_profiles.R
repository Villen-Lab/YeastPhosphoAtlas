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
  font_size <- 16
  plt <- ggplot(quants, aes(x=condition, y=intensityRaw,
                            color=condition == "UT")) +
           geom_jitter(size = 2, width = .2, alpha=.6) +
           stat_summary(fun = median, fun.min = median, fun.max = median,
                        geom = "crossbar", width = 0.5, color="#000000") +
           xlab("Condition") +
           ylab("Expression Value") +
           scale_color_manual(values = c("#27898c", "#461554")) + 
           theme_bw() +
           theme(axis.text.x = element_text(size=font_size,
                                            angle = 90,
                                            vjust = 0.5,
                                            hjust=1),
                 axis.text.y = element_text(size=font_size),
                 axis.title = element_text(size=font_size),
                 legend.position = "none")
  
  return(plt)
}

#' Render expression profile panels
#'
#' @param quants Filtered dataframe of quantifications
#' @param output Internal shiny parameter
#'
#' @noRd
render_expression_profile <- function(quants, output) {
  output$expression_profile_1 <- renderPlot({})
  output$expression_profile_2 <- renderPlot({})
  output$expression_profile_3 <- renderPlot({})
  output$expression_profile_4 <- renderPlot({})
  
  final_conditions <- quants %>%
    select(condition) %>%
    distinct() %>%
    arrange(condition)

  output$expression_profile_1 <- renderPlot({
    quants %>%
      right_join(final_conditions %>%
                   slice(c(1, 2:27)),
                 by="condition") %>%
      build_expression_profile()
  })
  
  if (nrow(final_conditions) > 27) {
    output$expression_profile_2 <- renderPlot({
      quants %>%
        right_join(final_conditions %>%
                     slice(c(1, 28:53)),
                   by="condition") %>%
        build_expression_profile()
    })
  }
  
  if (nrow(final_conditions) > 53) {
    output$expression_profile_3 <- renderPlot({
      quants %>%
        right_join(final_conditions %>%
                     slice(c(1, 54:80)),
                   by="condition") %>%
        build_expression_profile()
    })
  }
  
  if (nrow(final_conditions) > 80) {
    output$expression_profile_4 <- renderPlot({
      quants %>%
        right_join(final_conditions %>%
                     slice(c(1, 81:104)),
                   by="condition") %>%
        build_expression_profile()
    })
  }
}

#' Load expression data and reset selected conditions
#'
#' @param input,output,session Internal parameters for {shiny}..
#'
#' @noRd
init_condition_checkboxes <- function(input, output, session) {
  if (input$site != "" && input$site != 0) {
    print(paste("Site chosen:", input$site))
    # Load quant data
    quants <- get_quants_by_site_id(input$site)
    
    # Ignore current condition select state and render all
    updateCheckboxGroupInput(session = session, 
                             inputId = "select_conditions", 
                             selected = unique(quants$condition))
  }
}

#' Load expression data and filter by selected conditions
#'
#' @param input,output,session Internal parameters for {shiny}..
#'
#' @noRd
load_expression_profile <- function(input, output, session) {
  if (!is.null(input$select_conditions)) {
    # Load quant data
    quants <- get_quants_by_site_id(input$site) %>%
      filter(condition %in% c("UT", input$select_conditions))
    
    # Render plot
    render_expression_profile(quants, output)
  }
}