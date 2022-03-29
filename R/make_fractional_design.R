### Make a fractional design
library(FrF2)

# Fractional design with 7 factors and resolution IV
frac_design_1 <- FrF2(nfactors = 7, resolution = 4, randomize = FALSE) 

# Number of runs 
nrow(frac_design_1)

# Export
write.csv(frac_design_1, "data/frac_design_1.csv", row.names = FALSE)