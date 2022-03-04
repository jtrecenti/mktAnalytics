
get_data <- function(x) {
  eval(parse(text = paste0("dados::", x)))
}

bases <- function() {
  c("pinguins", "diamante", "clima", "dados_atmosfera", 
    "dados_iris", "mtcarros")
}