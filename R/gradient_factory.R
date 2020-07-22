#' gradient_factory.maxLik
#' @description This function is basically a copy of margins:::gradient_factory, but introduces the formula parameter, which cannot be retrieved from maxLik object and is required to predict the data
#' @importFrom prediction prediction
#' @description import internal find_terms_in_model
#' @description import internal marginal_effects
#' @description import internal reset_coefs
#' @export
gradient_factory.maxLik <- function(data, model, variables = NULL, type = "response", weights = NULL, eps = 1e-7, varslist = NULL, formula = NULL, ...) {

  # identify classes of terms in `model`
  if (is.null(varslist)) {
    varslist <- margins:::find_terms_in_model(model, variables = variables)
  }

  # factory function to return marginal effects holding data constant but varying coefficients
  FUN <- function(coefs, weights = NULL, ...) {
    model <- margins:::reset_coefs(model, coefs)
    if (is.null(weights)) {
      # build matrix of unit-specific marginal effects
      if (is.null(type)) {
        me_tmp <- margins:::marginal_effects(model = model, data = data, variables = variables, eps = eps, as.data.frame = FALSE, varslist = varslist, formula = formula,...)
      } else {
        me_tmp <- margins:::marginal_effects(model = model, data = data, variables = variables, type = type, eps = eps, as.data.frame = FALSE, varslist = varslist, formula = formula,...)
      }
      # apply colMeans to get average marginal effects
      means <- stats::setNames(.colMeans(me_tmp, nrow(me_tmp), ncol(me_tmp), na.rm = TRUE), colnames(me_tmp))
    } else {
      # build matrix of unit-specific marginal effects
      if (is.null(type)) {
        me_tmp <- margins:::marginal_effects(model = model, data = data, variables = variables, eps = eps, as.data.frame = FALSE, varslist = varslist, formula = formula, ...)
      } else {
        me_tmp <- margins:::marginal_effects(model = model, data = data, variables = variables, type = type, eps = eps, as.data.frame = FALSE, varslist = varslist, formula = formula, ...)
      }
      # apply colMeans to get average marginal effects
      means <- apply(me_tmp, 2L, stats::weighted.mean, w = weights, na.rm = TRUE)
    }
    means
  }
  return(FUN)
}
