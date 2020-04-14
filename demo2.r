# Basic test script:

# Library dependencies:
library(ggplot2)
library(purrr)
library(dplyr)

main <- function(dataset, segmentAnnotations, targetAnnotations, outputFolder) {
  # This section saves a text file, records the objects available in the DSPDA R space and their structurs
    # Also recrods the R version and packages.
  # 5.24.8 - The DSPDA_SW shall pass a data frame with the target count matrix from the currently selected dataset to R.Active
  # 5.24.9 - The DSPDA_SW shall pass a data frame with segment annotations from the currently selected dataset to R.Active
  # 5.24.10 - The DSPDA_SW shall pass a data frame with target annotations from the currently selected dataset to R.Active
  # 5.24.14 - The DSPDA_SW shall accept text files as a saved file associated with the dataset, including CSV and TXT format.
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

  # 5.24.8 - The DSPDA_SW shall pass a data frame with the target count matrix from the currently selected dataset to R.
    # Save the unaltered dataset table:
    write.csv(dataset, file = file.path(outputFolder, "dataset count matrix.csv", fsep = .Platform$file.sep))
    # Save the unaltered raw segment and target annotations tables as csv files.
  # 5.24.9 - The DSPDA_SW shall pass a data frame with segment annotations from the currently selected dataset to R.
    write.csv(segmentAnnotations, file = file.path(outputFolder, "sample annotations.csv", fsep = .Platform$file.sep))	
  # 5.24.10 - The DSPDA_SW shall pass a data frame with target annotations from the currently selected dataset to R.
    write.csv(targetAnnotations, file = file.path(outputFolder, "target annotations.csv", fsep = .Platform$file.sep))

	# 5.24.2 - User shall be able to specify input data and choose a custom script from a menu of available scripts.
		# List all non-base packages and save:
		ip <- as.data.frame(installed.packages()[,c(1,3:4)])
		rownames(ip) <- NULL
		# ip <- ip[is.na(ip$Priority),1:2,drop=FALSE] # This line drops base and recommended packages from list
		write.csv(ip, file = file.path(outputFolder, "packages list.csv", fsep = .Platform$file.sep))
	
  #	Not great, this assumes ggplot2 is installed, which it should be- Where are specs for R packages?
  # 5.24.13 - The DSPDA_SW shall accept plots as a saved file associated with the dataset, including PNG, JPEG, TIFF, PDF, that the user can download.
    # Images -In future plot something more relevant
    p <- ggplot(segmentAnnotations, aes(AOIArea, AOINucleiCount)) + geom_point()
    prefix <- file.path(outputFolder, 'test.', fsep = .Platform$file.sep)
    devices <- c('eps', 'ps', 'pdf', 'jpeg', 'tiff', 'png', 'bmp')
    walk(devices, ~ggsave(filename = file.path(paste(prefix, .x), fsep = .Platform$file.sep), device = .x))

  
    
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
  
  # Save relabelled Count Matrix attached to dataset
  write.csv(targetCountMatrix, file = file.path(outputFolder, "targetCountMatrix.csv", fsep = .Platform$file.sep))
  
  # 5.24.11 - The DSPDA_SW shall accept a transformed target count matrix from R script output to a new dataset.
    # Update the count matrix for when "create new dataset" is checked
    dataset2 <- dataset*10
    return(dataset2)
}
