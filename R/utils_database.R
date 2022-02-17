#' Connect to internal database 
#'
#' @description Finds current location of database, which may change when installed, and returns a connection.
#'    TODO: future versions of this function should implement a singleton connection.
#'
#' @return A connection to the internal database.
#' @noRd
get_db_connection <- function() {
  db_location <- 
    system.file("extdata", 
                "yeast_phospho_atlas.db", 
                package = "YeastPhosphoAtlas")
  if (db_location == "") {
    db_location <- 
      system.file("inst",
                  "extdata", 
                  "yeast_phospho_atlas.db", 
                  package = "YeastPhosphoAtlas")
  }
  
  con <- DBI::dbConnect(RSQLite::SQLite(), db_location)
  return(con)
}

#' Query conditions in database 
#'
#' @description Query a dataframe of all conditions within the database.
#'
#' @return A table of conditions sorted alphabetically with untreated listed first
#' @noRd
get_conditions <- function() {
  con <- get_db_connection()
  cond <- DBI::dbGetQuery(con, paste("SELECT code, description",
                                     "FROM condition"))
  cond = cond %>%
           mutate(code = factor(code, levels = union("UT", code))) %>%
           arrange(code)

  DBI::dbDisconnect(con)
  return(cond)
}

#' Query sites on specific protein 
#'
#' @description Returns all sites in database associated with a query protein reference.
#'
#' @return A table of sites
#' @noRd
get_sites_by_prot_ref <- function(ref) {
  con <- get_db_connection()
  sites <- DBI::dbGetQuery(con, paste("SELECT s.id, s.residue, s.position",
                                      "FROM site s",
                                      "LEFT JOIN protein p ON s.idProtein=p.id",
                                      "WHERE p.reference = ",
                                      paste0("'", ref, "'")))
  DBI::dbDisconnect(con)
  return(sites)
}

#' Query quants for a specific site 
#'
#' @description Returns all expression values associated with a query site id.
#'
#' @return A table of quant values
#' @noRd
get_quants_by_site_id <- function(id) {
  con <- get_db_connection()
  quants <- DBI::dbGetQuery(con, paste("SELECT q.id idQuant,",
                                              "s.name sampleName,", 
                                              "c.code condition,",
                                              "s.batch,",
                                              "s.block,",
                                              "q.intensityRaw",
                                       "FROM quantification q",
                                       "LEFT JOIN sample s ON q.idSample=s.id",
                                       "LEFT JOIN condition c ON s.idCondition=c.id",
                                       "WHERE q.idSite = ",
                                       id))
  condition_levels <- union("UT", 
                            quants$condition %>%
                              unique() %>%
                              sort())
  quants <- quants %>%
              mutate(condition = factor(condition, levels=condition_levels))
  
  DBI::dbDisconnect(con)
  return(quants)
}
