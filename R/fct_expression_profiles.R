#' Fill in page description
#'
#' @param input,output,session Internal parameters for {shiny}..
#'
#' @noRd
write_expression_profiles_description <- function(input, output, session) {
  output$title <- renderText({ "Phosphosite Expression Profiles" })
  output$description <-
    renderText({
      paste("Welcome to the Yeast Phospho Atlas' phosphosite expression profile page.",
            "Here you can look up individual sites of interest and view their dynamics",
            "accross treatements. After entering a SGD accession on the left,",
            "you may choose a site and set of treatments for your comparison.")})
}

#' Fill in page description
#'
#' @param input,output,session Internal parameters for {shiny}..
#'
#' @noRd
remove_expression_profiles_description <- function(input, output, session) {
  removeUI("#expression_profiles_ui_1-title")
  removeUI("#expression_profiles_ui_1-description")
}

#' Fill protein site dropdown menu
#'
#' @param input,output,session Internal parameters for {shiny}..
#'
#' @noRd
load_protein_sites <- function(input, output, session) {
  preloadData <- session$userData$preloadData
  site_list <- list()
  if (str_length(input$protein) == 7) { # FIX
    sites <- get_sites_by_prot_ref(input$protein)
    site_list <- as.list(sites$id)
    names(site_list) <- paste0(sites$residue, sites$position)
  }
  
  if (input$protein=='YHR205W' && preloadData==TRUE) {
  
    print(site_list$S726)
    updateSelectInput(session = session, inputId = "site", 
                      choices = c("Select 1" = 0, site_list),
                      selected = site_list$S726)
    session$userData$preloadData <- FALSE
  } else {
    updateSelectInput(session = session, inputId = "site", 
                      choices = c("Select 1" = 0, site_list)) 
  }
}

#' Build ggplot output for expression profile
#'
#' @param quants Filtered dataframe of quantifications
#'
#' @noRd
build_expression_profile <- function(quants) {
  font_size <- 20
  plt <- ggplot(quants, aes(x=condition, y=intensityRaw,
                            color=condition == "UT")) +
           stat_summary(fun = median, fun.min = median, fun.max = median,
                        geom = "crossbar", width = 0.75, color="#000000") +
           geom_jitter(size = 3, width = .2, alpha=.6) +
           xlab("Condition") +
           ylab("Expression") +
           scale_color_manual(values = c("#27898c", "#461554")) + 
           theme_bw() +
           theme(axis.text.x = element_text(size=font_size,
                                            angle = 90,
                                            vjust = 0.5,
                                            hjust=1),
                 axis.text.y = element_text(size=font_size),
                 axis.title = element_text(size=font_size+4),
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
  remove_expression_profiles_description(input, output, session)
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
    # Load quant data
    quants <- get_quants_by_site_id(input$site)
    
    # Ignore current condition select state and render all
    updateCheckboxGroupInput(session = session, 
                             inputId = "select_conditions", 
                             selected = unique(quants$condition))
  }
}

#' Clear selected condition checkboxes
#'
#' @param input,output,session Internal parameters for {shiny}..
#'
#' @noRd
clean_condition_checkboxes <- function(input, output, session) {
  updateCheckboxGroupInput(session = session, 
                           inputId = "select_conditions",
                           choices = get_conditions()$code[-1],
                           inline = TRUE)
}

#' Load expression data and filter by selected conditions
#'
#' @param input,output,session Internal parameters for {shiny}..
#'
#' @noRd
load_expression_profile <- function(input, output, session) {
  if (!is.null(input$select_conditions) && input$site != "" && input$site != 0) {
    # Load quant data
    quants <- get_quants_by_site_id(input$site) %>%
      filter(condition %in% c("UT", input$select_conditions))
    
    # Render plot
    render_expression_profile(quants, output)
  }
}
