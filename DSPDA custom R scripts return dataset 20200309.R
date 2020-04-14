# Just returnt a new dataset

main <- function(dataset, segmentAnnotations, targetAnnotations, outputFolder) {
  # 5.24.11 - The DSPDA_SW shall accept a transformed target count matrix from R script output to a new dataset.
    # Update the count matrix for when "create new dataset" is checked
    dataset <- dataset*10
    return(dataset)
}
