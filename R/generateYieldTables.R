generateYieldTables <- function(cohortData, pixelGroupRef) {
  cds <- copy(cohortData)
  setkeyv(cds, c("speciesCode", "pixelGroup"))
  # Because LandR biomass will lump all age < 11 into age 0
  if ((sum(cds$age[cds$pixelGroup == 1] == 0) %% 11) == 0) {
    cds[age == 0, age := 0:10, by = c("pixelGroup", "speciesCode")]
  }
  
  # Retrieve original pixelGroups
  message("Retrieving original pixelGroups")
  cds <- merge(cds, pixelGroupRef, by.x = "pixelGroup", by.y = "newPixelGroup", allow.cartesian = TRUE)
  cds[, pixelGroup := NULL]
  setnames(cds, "oldPixelGroup", "pixelGroup")
  
  # Add cohort_id. One cohort_id per pixelGroup x species
  cds[, cohort_id:=.GRP, by = c("pixelGroup", "speciesCode")]
  
  # Create reference table
  cdSpeciesCodes <- unique(cds[, .(cohort_id, pixelGroup, speciesCode)])
  
  # Remove columns
  cds[, speciesCode := NULL]
  
  list(cds = cds, cdSpeciesCodes = cdSpeciesCodes)
}
