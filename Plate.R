library(methods)

setClass("Plate",
         slots = c(
           layers = "list",
           meta = "list"),
         prototype = c(
           layers = list(),
           date = list()
         )
)

setValidity("Plate", function(object) {

  # Each layer must have dimensions
  any_null_dims <- object@layers |>
    lapply(dim) |>
    lapply(is.null) |>
    unlist() |>
    any()

  if (any_null_dims) {
    return("All layers must have dimensions")
  }



  if (length(object@layers) < 1) {
    TRUE
  } else {
    unique_row_dims <- object@layers |>
      lapply(nrow) |>
      unlist() |>
      unique() |>
      length()

    unique_col_dims <- object@layers |>
      lapply(ncol) |>
      unlist() |>
      unique() |>
      length()

    if (!(unique_row_dims == 1 & unique_col_dims == 1)) {
      "All layers must have the same dimensions"
    } else {
      TRUE
    }
  }
})

concentration <- matrix(1:6, 2, 3)
name <- matrix(c("dog", "cat", "mouse", "mouse", "dog", "cat"), 2, 3)

plate <- new("Plate", layers = list(conc = concentration, name = name))

setGeneric("serve", function(x) standardGeneric("serve"))

setMethod("serve", "Plate", function(x) {
  x@layers |>
    lapply(as.vector) |>
    reduce(bind_cols) |>
    setNames(names(x@layers))
})


# Layer(s) getter ----
setGeneric("layers", function(x, ...) standardGeneric("layers"))

setMethod("layers", "Plate", function(x, n = NULL) {
  if (is.null(n)) {
    x@layers
  } else {
    x@layers[n]
  }
})

# Layer setter ----
setGeneric("layers<-", function(x, ...) standardGeneric("layers<-"))

setMethod("layers<-", "Plate", function(x, value, position = NULL) {
  if(is.null(position)) {
    x@layers <- c(x@layers, value)
  } else {
    x@layers[[position]] <- value
  }
  validObject(x)
  x
})


serve(plate)
