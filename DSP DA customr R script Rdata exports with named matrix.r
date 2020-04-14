# Library dependencies:
library(ggplot2)
library(purrr)
library(dplyr)

main <- function(dataset, segmentAnnotations, targetAnnotations, outputFolder) {
   # Make a table to check the passed dataframes from DSP
  targetCountMatrix <- dataset

  # Make unique segment identifiers instead of GUIDs
  # This MODIFIES SEGMENT ANNOTATIONS - may affect future functionality of custom scripts.
  segmentAnnotations <- segmentAnnotations %>%
    mutate(segmentDisplayName = paste(ScanName, ROIName, SegmentName, sep=" | "))
  
  # Update count matrix column names with new segment unique ID instead of GUID. 
  names(targetCountMatrix) <- segmentAnnotations[match(names(targetCountMatrix), segmentAnnotations[ , "segmentID"]), "segmentDisplayName"]  
  
  #names(df) <- df_names[match(names(df), df_names[ ,'segmentID']), 'name']
  # Update count matrix rownames with targetNames
  rownames(targetCountMatrix) <- targetAnnotations[match(rownames(targetCountMatrix), targetAnnotations[ , "TargetGUID"]), "TargetName"]
  
  save(dataset,
       segmentAnnotations,
       targetAnnotations,
       targetCountMatrix,
       file = file.path(outputFolder, 
                        "export.RData", 
                        fsep = .Platform$file.sep)
      )
  }
