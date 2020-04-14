# Library dependencies:
library(ggplot2)
library(purrr)
library(dplyr)

main <- function(dataset, segmentAnnotations, targetAnnotations, outputFolder) {
  # Log outputs from DSPDA R environment:
  # Set up a text file, capture outputs to the file.
  sink(file = file.path(outputFolder, "out.txt", fsep = .Platform$file.sep))
    out <- capture.output(ls())
    cat(out,file = file.path(outputFolder, "out.txt", fsep = .Platform$file.sep),sep="\n",append=TRUE)
    out <- capture.output(R.version.string)
    cat(out,file = file.path(outputFolder, "out.txt", fsep = .Platform$file.sep),sep="\n",append=TRUE)
    out <- capture.output(str(dataset))
    cat(out,file = file.path(outputFolder, "out.txt", fsep = .Platform$file.sep),sep="\n",append=TRUE)
    out <- capture.output(str(segmentAnnotations))
    cat(out,file = file.path(outputFolder, "out.txt", fsep = .Platform$file.sep),sep="\n",append=TRUE)
    out <- capture.output(str(targetAnnotations))
    cat(out,file = file.path(outputFolder, "out.txt", fsep = .Platform$file.sep),sep="\n",append=TRUE)
    sink()
   
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

# end
 
  # # For testing:
  # library(tcltk)
  # setwd(tk_choose.dir(caption = "Choose local directory to save outputs for testing"))
  # outputFolder <- getwd()
  # main(dataset, segmentAnnotations, targetAnnotations, outputFolder)
