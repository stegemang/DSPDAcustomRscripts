main <- function(dataset, segmentAnnotations, targetAnnotations, outputFolder) {
  save(dataset,
       segmentAnnotations,
       targetAnnotations,
       file = file.path(outputFolder, 
                        "export.RData", 
                        fsep = .Platform$file.sep)
      )
  }
