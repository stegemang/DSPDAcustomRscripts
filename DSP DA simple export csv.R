main <- function(dataset, segmentAnnotations, targetAnnotations, outputFolder) {
    # Save the unaltered dataset table:
    write.csv(dataset, file = file.path(outputFolder,
                                        "dataset.csv",
                                        fsep = .Platform$file.sep)
             )
    # Save the unaltered raw segment and target annotations tables as csv files.
    write.csv(segmentAnnotations, file = file.path(outputFolder,
                                                   "segmentAnnotations.csv",
                                                   fsep = .Platform$file.sep))	
    write.csv(targetAnnotations, file = file.path(outputFolder,
                                                   "targetAnnotations.csv",
                                                   fsep = .Platform$file.sep))
}