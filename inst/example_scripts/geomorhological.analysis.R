# TODO: Add comment
# 
# Author: ecor
###############################################################################


library(rjgrassGroovySmartBridge)


file <- system.file("geoscript-groovy-examples/geomorphological.analysis.groovy",package="rjgrassGroovySmartBridge")
groovy <- parseGroovyFile(file=file)

dem  <- system.file("examples/match100m.asc",package="rjgrassGroovySmartBridge")
#dem <- "/Users/ecor/Dropbox/hydropica/sourcesR/rjgrassGroovySmartBridge/inst/examples/match100m.asc"
### INPUT VARIABLE
input <- list()
input$elevAsc <- dem
input$pThresScalar <- 10

## OUTPUT VARIABLE

###output <- list()
#outwpath <- system.file("temporary_output",package="rjgrassGroovySmartBridge")
outwpath  <- "/home/ecor/temp"
output <- groovy[str_detect(unlist(lapply(X=groovy,FUN=function(x){attr(x,"io.type")})),"output")]

names_output <- names(output)

output <- lapply(X=names(output),FUN=function(x,outwpath){
			out <- str_replace(x," ","_")
			out <- paste("output",out,sep="_")
			out <- paste(outwpath,out,sep="/")
			extension <- "asc"
			if (str_detect(x,"Asc")) extension <- "asc"
			if (str_detect(x,"Shp")) extension <- "shp"
			out <- paste(out,extension,sep=".")
			return(out)
			
		},outwpath=outwpath)

names(output) <- names_output

output_groovy <- executeGroovyFile(groovy,inputVar=input,outputVar=output)
