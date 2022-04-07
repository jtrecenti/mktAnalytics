#' logit UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_logit_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' logit Server Functions
#'
#' @noRd 
mod_logit_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_logit_ui("logit_1")
    
## To be copied in the server
# mod_logit_server("logit_1")
