#' pca UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_pca_ui <- function(id){
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
          shiny::tabPanel(
            "Scree Plot",
            shiny::plotOutput(ns("scree")),
            shiny::p(paste("Explicações:", shinipsum::random_text(100)))
          ),
          shiny::tabPanel(
            "Contribuições",
            shiny::numericInput(ns("eixo"), "PCA", 1),
            shiny::plotOutput(ns("contrib")),
            shiny::p(paste("Explicações:", shinipsum::random_text(100)))
          ),
          shiny::tabPanel(
            "Variáveis",
            shiny::selectInput(ns("colorir"), "Colorir por", c("Nada", "contrib")),
            shiny::plotOutput(ns("plotvar")),
            shiny::p(paste("Explicações:", shinipsum::random_text(100)))
          ),
          shiny::tabPanel(
            "Indivíduos",
            shiny::selectInput(ns("colorir_ind"), "Colorir por", c("Nada")),
            shiny::plotOutput(ns("ind")),
            shiny::p(paste("Explicações:", shinipsum::random_text(100)))
          ),
          shiny::tabPanel(
            "Biplot",
            shiny::selectInput(ns("colorir_biplot"), "Colorir por", c("Nada")),
            shiny::plotOutput(ns("biplot")),
            shiny::p(paste("Explicações:", shinipsum::random_text(100)))
          )
        )
        
      )
    )
 
  )
}
    
#' pca Server Functions
#'
#' @noRd 
mod_pca_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # parte de dados e descritiva -------------------------------------------
    
    # carrega os dados
    dados <- shiny::reactive({
      get_data(input$dados)
    })
    
    dados_select <- shiny::reactive({
      dplyr::select(dados(), tidyselect::any_of(input$variaveis))
    })
    
    # atualiza as variáveis
    shiny::observe({
      nm <- names(dados())
      shinyWidgets::updatePickerInput(
        session, "variaveis",
        "Variável (selecione apenas numéricas)",
        nm, nm
      )
      shiny::updateSelectInput(
        session, "colorir_biplot",
        "Colorir por",
        c("Nada", nm), 
        "Nada"
      )
      shiny::updateSelectInput(
        session, "colorir_ind",
        "Colorir por",
        c("Nada", nm), 
        "Nada"
      )
    })
    
    # parte de PCA ----------------------------------------------------------
    
    pca <- shiny::reactive({
      FactoMineR::PCA(dados_select(), ncp = Inf, graph = FALSE)
    })
    
    output$scree <- shiny::renderPlot({
      factoextra::fviz_screeplot(pca(), addlabels = TRUE)
    })
    output$plotvar <- shiny::renderPlot({
      col_var <- ifelse(input$colorir == "Nada", "black", input$colorir)
      factoextra::fviz_pca_var(pca(), col.var = col_var, repel = TRUE)
    })
    output$contrib <- shiny::renderPlot({
      factoextra::fviz_contrib(pca(), choice = "var", axes = input$eixo)
    })
    output$ind <- shiny::renderPlot({
      
      if (input$colorir_ind == "Nada") {
        hab <- "none"
      } else {
        hab <- dados()[[input$colorir_ind]] |> 
          forcats::fct_lump_n(5)
      }
      
      factoextra::fviz_pca_ind(
        pca(), 
        label = "none",
        habillage = hab,
        col.ind = "contrib", 
        repel = TRUE,
        addEllipses = (hab[1] != "none")
      )
    })
    output$biplot <- shiny::renderPlot({
      
      if (input$colorir_biplot == "Nada") {
        hab <- "none"
      } else {
        hab <- dados()[[input$colorir_biplot]] |> 
          forcats::fct_lump_n(5)
      }
      
      factoextra::fviz_pca_biplot(
        pca(), 
        label = "none",
        repel = TRUE, 
        habillage = hab
      )
    })
    
  })
}
    
## To be copied in the UI
# mod_pca_ui("pca_ui_1")
    
## To be copied in the server
# mod_pca_server("pca_ui_1")
