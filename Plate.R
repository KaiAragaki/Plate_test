library(methods)
library(purrr)
library(dplyr)


setClass("Plate",
         slots = c(
           layers = "list",
           meta = "list",
           wells = "numeric"),
         prototype = c(
           layers = list(),
           date = list(),
           wells = NA_real_
         )
)

setValidity("Plate", function(object) {

  # Ensure wells is a valid number of wells
  if (!is.na(object@wells) && !(object@wells %in% c(6, 12, 24, 48, 96, 384, 1536, 3456))) {
    return("`wells` does not match a valid form factor (6, 12, 24, 48, 96, 384, 1536, or 3456)")
  }

  # If the wells slot it set, enforce incoming layer dimensions


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
animal <- matrix(c("dog", "cat", "mouse", "mouse", "dog", "cat"), 2, 3)
ranking <- data.frame(col1 = c(1, 1), col2 = c(NA, 2), col3 = c(1, 2))
plate <- new("Plate", layers = list(conc = concentration,
                                    animal = animal,
                                    rank = ranking))

Plate <- function(layers = list(), wells = NA_real_, meta = list()) {
  new("Plate", layers = layers, wells = wells, meta = meta)
}



setGeneric("serve", function(x) standardGeneric("serve"))

setMethod("serve", "Plate", function(x) {
  x@layers |>
    lapply(as.matrix) |>
    lapply(as.vector) |>
    reduce(bind_cols) |>
    setNames(names(x@layers))
})


# Layer(s) getter ----
setGeneric("spill", function(x, ...) standardGeneric("spill"))
setMethod("spill", "Plate", function(x, n = NULL) {
  if (is.null(n)) {
    x@layers
  } else {
    x@layers[n]
  }
})

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
    x@layers[[length(salad@layers) + 1]] <- value
  } else {
    x@layers[[position]] <- value
  }
  validObject(x)
  x
})

# Well getter ----
setGeneric("wells", function(x) standardGeneric("wells"))
setMethod("wells", "Plate", function(x) {
  x@wells
})

# Well setter ----
setGeneric("wells<-", function(x, ...) standardGeneric("wells<-"))
setMethod("wells<-", "Plate", function(x, value) {
  x@wells <- value
  validObject(x)
  x
})


serve(plate)
