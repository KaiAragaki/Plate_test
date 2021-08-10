leaves <- matrix(sample(1:10, 6, replace = TRUE), 2, 3)
tomatoes <- matrix(sample(0:1, 6, replace = TRUE), 2, 3)
portions <- matrix(c("max", "jerry", "david", "larry", "beth", "judy"), 2, 3)

salad <- Plate(layers = list(leaves = leaves,
                             tomatoes = tomatoes,
                             portions = portions))

serve(salad)
spill(salad)
spill(salad, "leaves")
