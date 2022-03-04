#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#' 
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  mod_descritiva_server("descritiva_ui_1")
  mod_pca_server("pca_ui_1")
  mod_cluster_server("cluster_ui_1")
  
}
