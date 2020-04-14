# Main function wrapper that DSP DA custom scripts useses:
  main <- function(dataset, segmentAnnotations, targetAnnotations, outputFolder) {
    ### Your code here ###
    dataset2 <- dataset * 100
    return(dataset2)
  }


# What DSP DA custom scripts seems to run:
#	main(dataset, segmentAnnotations, targetAnnotations, outputFolder)