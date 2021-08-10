# plate

# Planned Features

An object-oriented way of thinking about well-plates in R. 

Features should include:
- The ability to set what dimensions a plate is
- The ability to store an arbitrary number of 'data layers' of a plate
- Metadata storage
- Tidy retrieval
- Plate ID?

## Plate Layers

Unlike a SummarizedExperiment, that assumes that the assay data is tidy (that is, a column and row MEANS something), plate data often does not follow this format, yet echoes it with its rectangular form factor. 

Rather, each well is its own entity, that is generally only physically bound by the plate. Sometimes experiments span multiple plates, or don't use the full plate.

An idea would be to allow for storage of data for each well as a series of layers that can be applied to the whole plate. This would likely take the form of a list of matrices, such as 'Concentration (uM)' and 'Seeding density', etc. Likely each matrix could have its own datatype associated with it, so it would not require a dataframe - a matrix for each should do.

These data should be able to be retrieved in a tidy manner, taking all (or perhaps a selection? this could be done later though, but might be helpful for many plate layers to do it up front) layers and 'unwrapping' the plate into a long format, where each column is a layer, and each row is a well.

This would provide a sensible framework for all plate-based scripts to build upon, as well as a toolset for people just working with plate data on their own.

## Verbs

* `serve`: return plate tidily

* `spill`: A helper function for `plate@layers`. May be nice to `spill(1)` or `spill("concentration")` to allow for a certain layer to be spilled.

* `portion`: Getter/setter function that allows for rectangular regions to be extracted (will likely need to drop/rewrite dimension argument or chaos will ensue) or set (either on a new layer, `portion(plate, upper_left, bottom_right)` or an existing layer `portion(plate, layer, upper_left, bottom_right)`). `upper_left`/`bottom_right` will probably take either a character (`"A1"`) or numeric vector (`c(2, 1)`). The issue is that it makes equal sense to define `c(1, 1)` as the top left OR bottom left, but bottom left seems easier to implement
