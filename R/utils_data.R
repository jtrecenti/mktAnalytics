#' mobile_app
"mobile_app"


get_data <- function(x) {
  if (x == "mobile_app") {
    lab <- "mktAnalytics"
  } else {
    lab <- "dados"
  }
  eval(parse(text = paste0(lab, "::", x)))
}

bases <- function() {
  c("pinguins", "diamante", "clima", "dados_atmosfera", 
    "dados_iris", "mtcarros", "mobile_app")
}