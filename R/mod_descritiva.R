#' descritiva UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_descritiva_ui <- function(id){
  ns <- shiny::NS(id)
  tagList(
    
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        width = 3,
        shiny::selectInput(
          ns("dados"), 
          "Base de dados",
          bases(),
          c("pinguins"), 
          multiple = FALSE
        ),
        shinyWidgets::pickerInput(
          ns("variaveis"),
          "Colunas (selecione apenas numéricas)",
          character(0),
          character(0),
          multiple = TRUE
        )
      ),
      shiny::mainPanel(
        width = 9,
        shiny::tabsetPanel(
          header = "Descritiva",
          shiny::tabPanel(
            "Esquisse", 
            esquisse::esquisse_ui(
              ns("esquisse"),
              header = FALSE,
              container = esquisse::esquisseContainer(height = "700px")
            )
          ),
          shiny::tabPanel(
            "Skim",
            shiny::verbatimTextOutput(ns("glimpse"))
          )
        )
      )
    )
  )
  
}
    
#' descritiva Server Functions
#'
#' @noRd 
mod_descritiva_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # parte de dados e descritiva -------------------------------------------
    
    # reactive value usado no esquisse
    dados_rv <- shiny::reactiveValues(data = dados::pinguins, name = "pinguins")
    
    # carrega os dados
    dados <- shiny::reactive({
      get_data(input$dados)
    })
    
    dados_select <- shiny::reactive({
      dplyr::select(dados(), tidyselect::any_of(input$variaveis))
    })
    
    # muda o reactive value usado no esquisse
    shiny::observeEvent(input$dados, {
      dados_rv$data <- dados()
      dados_rv$name = input$dados
    })
    
    # descritiva com esquisse
    esquisse::esquisse_server("esquisse", dados_rv)
    
    # atualiza a base
    shiny::observe({
      nm <- names(dados())
      shinyWidgets::updatePickerInput(
        session, "variaveis",
        "Variável (selecione apenas numéricas)",
        nm,
        nm
      )
    })
    
    output$glimpse <- shiny::renderPrint({
      skimr::skim(dados_select())
    })

  })
}
    
## To be copied in the UI
# mod_descritiva_ui("descritiva_ui_1")
    
## To be copied in the server
# mod_descritiva_server("descritiva_ui_1")
