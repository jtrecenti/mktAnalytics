#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#' 
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    shiny::navbarPage(
      theme = bslib::bs_theme(
        version = 5, 
        bootswatch = "sketchy",
        primary = "red",
        font_scale = 1.2
      ),
      title = "mktAnalytics",
      shiny::tabPanel(
        "Home",
        shiny::includeMarkdown(system.file("sobre.md", package = "mktAnalytics"))
      ),
      shiny::tabPanel(
        "Descritiva",
        mod_descritiva_ui("descritiva_ui_1")
      ),
      shiny::tabPanel(
        "Componentes principais",
        mod_pca_ui("pca_ui_1")
      ),
      shiny::tabPanel(
        "Análise de agrupamento",
        mod_cluster_ui("cluster_ui_1")
      )
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
      app_title = 'mktAnalytics'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

