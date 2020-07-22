#' @export
find_terms_in_model.maxLik <- function(model, variables = NULL) {

  varslist <- margins:::find_terms_in_model.default(model$model, variables)

  varslist
}

#' @export
terms.maxLik <- function(model) stats::terms(model$model)

#' @export
reset_coefs.maxLik <- function(model, coefs) {
  model$estimate <- coefs
  model
}
