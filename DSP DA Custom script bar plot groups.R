# Script to make a plot:

library(ggplot2)
library(reshape2)
library(dplyr)

# User parameters:  
gene_lookup <- "KRT"
seg_column <- "SegmentName"

main <- function(dataset, segmentAnnotations, targetAnnotations, outputFolder) {
  # Make a table to check the passed dataframes from DSP
  targetCountMatrix <- dataset
  # Make unique segment identifiers instead of GUIDs
  # This MODIFIES SEGMENT ANNOTATIONS - may affect future functionality of custom scripts.
  segmentAnnotations <- segmentAnnotations %>%
    mutate(segmentDisplayName = paste(ScanName, ROIName, SegmentName, sep=" | "))
  
  # Update count matrix column names with new segment unique ID instead of GUID. 
  names(targetCountMatrix) <- segmentAnnotations[match(names(targetCountMatrix), segmentAnnotations[ , "segmentID"]), "segmentDisplayName"]  
  
  # Update count matrix rownames with targetNames
  rownames(targetCountMatrix) <- targetAnnotations[match(rownames(targetCountMatrix),
    targetAnnotations[ , "TargetGUID"]),
    "TargetName"]

  # exp: genes * Segments
  exp <- targetCountMatrix
  
  # annot: segments * annotations
  annot <- segmentAnnotations

  # Assume segments are in the same order across both
  # Check for testing, not functional in DSPDA:
  all(annot["segmentDisplayName"] == colnames(exp))   

  # merge into 1 data frame
  merge_dat <- merge(annot, t(exp), by.x = "segmentDisplayName", by.y = 0)

  # melt based on segment, only use gene columns of interest during melt
  melt_dat <- melt(merge_dat,
    id.vars = c("segmentDisplayName", seg_column),
    measure.vars = colnames(merge_dat)[grep(gene_lookup, colnames(merge_dat))],
    variable.name = "Target",
    value.name = "Expression")

  # graph
  p <- ggplot(melt_dat,
    aes_string(x = seg_column, y = "Expression")) + 
    geom_boxplot() +
    scale_y_continuous(trans = "log2") +
    facet_wrap(~Target, scales="free") +
    theme(text = element_text(size=10),
    axis.text.x = element_text(angle=45, hjust=1)) + 
    labs(x = "ROI Segment")
        
  ggsave(filename = paste("Barplot_for_", gene_lookup, ".png", sep=""),
    plot = p,
    device = "png",
    path = outputFolder)
 }
 
# end
 
 # # For testing:
 # setwd("H:\\ssd_test_space\\temp")
 # outputFolder <- getwd()
 # main(dataset, segmentAnnotations, targetAnnotations, outputFolder)