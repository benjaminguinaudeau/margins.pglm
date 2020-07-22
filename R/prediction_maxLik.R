#' prediction.maxLik
#' @export
prediction.maxLik <- function(model, data, type = "response", calculate_se = F, formula = formula){
  curent <- options("na.action")
  options(na.action='na.pass')
  out <- data.frame(fitted = exp(stats::model.matrix(formula, data) %*% summary(model)$estimate[,1]))
  options(na.action=curent[[1]])
  return(cbind(data, out))
}
