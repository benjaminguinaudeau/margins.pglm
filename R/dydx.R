#' dydx.factor
#' @description This function is basically a copy of margins:::dydx.factor, but simulates factor level variable with a factor instead of a character. Current version of dydx.factor is problematic when predicting maxLik object with prediction.maxLik
#' @importFrom prediction prediction
#' @export
dydx.factor <-
  function(data,
           model,
           variable,
           type = c("response", "link"),
           fwrap = FALSE,
           as.data.frame = TRUE,
           ...
  ) {

    levs <- levels(as.factor(data[[variable]]))
    base <- levs[1L]
    levs <- levs[-1L]

    # setup response object
    if (isTRUE(fwrap)) {
      outcolnames <- paste0("factor(", variable, ")", levs)
    } else {
      outcolnames <- paste0("dydx_", variable, levs)
    }

    if (isTRUE(as.data.frame)) {
      out <- structure(rep(list(list()), length(levs)),
                       class = "data.frame",
                       names = outcolnames,
                       row.names = seq_len(nrow(data)))
    } else {
      out <- matrix(NA_real_, nrow = nrow(data), ncol = length(levs), dimnames = list(seq_len(nrow(data)), outcolnames))
    }

    # setup base data and prediction
    d0 <- d1 <- data
    d0[[variable]] <- factor(base, levels = c(base, levs))
    if (!is.null(type)) {
      type <- type[1L]
      pred0 <- prediction(model = model, data = d0, type = type, calculate_se = FALSE, ...)[["fitted"]]
    } else {
      pred0 <- prediction(model = model, data = d0, calculate_se = FALSE, ...)[["fitted"]]
    }
    # calculate difference for each factor level
    for (i in seq_along(levs)) {
      d1[[variable]] <- factor(levs[i], levels = c(base, levs))
      if (!is.null(type)) {
        type <- type[1L]
        pred1 <- prediction(model = model, data = d1, type = type, calculate_se = FALSE, ...)[["fitted"]]
      } else {
        pred1 <- prediction(model = model, data = d1, calculate_se = FALSE, ...)[["fitted"]]
      }
      if (isTRUE(as.data.frame)) {
        out[[outcolnames[i]]] <- structure(pred1 - pred0, class = c("marginaleffect", "numeric"))
      } else {
        out[, outcolnames[i]] <- pred1 - pred0
      }
    }

    # return data.frame (or matrix) with column of derivatives
    return(out)
  }
