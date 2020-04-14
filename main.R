main <- function(dataset, segmentAnnotations, targetAnnotations, outputFolder) {
	source("normalize.R")
	
	dataset2 = normalize(dataset, names(dataset))
	
	print(targetAnnotations[1])
	
    return (dataset2);
}
