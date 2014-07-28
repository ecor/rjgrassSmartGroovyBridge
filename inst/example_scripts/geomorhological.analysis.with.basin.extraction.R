# TODO: Add comment
# 
# Author: ecor
###############################################################################


library(rjgrassGroovySmartBridge)
## 
source("/Users/ecor/Dropbox/hydropica/sourcesR/rjgrassGroovySmartBridge/R/parseGroovyFile.R") 
source('/Users/ecor/Dropbox/hydropica/sourcesR/rjgrassGroovySmartBridge/R/putValueInScript.R', chdir = TRUE)
source('/Users/ecor/Dropbox/hydropica/sourcesR/rjgrassGroovySmartBridge/R/executeGroovyFile.R', chdir = TRUE)

file <- system.file("geoscript-groovy-examples/geomorphological.analysis.groovy",package="rjgrassGroovySmartBridge")
file_ExtractBasin <- system.file("geoscript-groovy-examples/extract.basin.groovy",package="rjgrassGroovySmartBridge")

groovy <- parseGroovyFile(file=file)
groovy_ExtractBasin <- parseGroovyFile(file=file_ExtractBasin)

## GET DEM 
dem_file  <- system.file("examples/match100m.asc",package="rjgrassGroovySmartBridge")
dem <- raster(dem_file)

#dem <- "/Users/ecor/Dropbox/hydropica/sourcesR/rjgrassGroovySmartBridge/inst/examples/match100m.asc"
### INPUT VARIABLE
input <- list()
input$elevAsc <- dem
input$pThresScalar <- 10

## OUTPUT VARIABLE

###output <- list()
outwpath <- system.file("temporary_output",package="rjgrassGroovySmartBridge")

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
output <- NULL
output_groovy <- executeGroovyFile(groovy,inputVar=input,outputVar=output)

##basin_extraction 

## select a possible outlet 
## Find a minimum elevation point 
tca <- getValueFromScript(x=output_groovy, name="tcaAsc")
elevDePitted <- getValueFromScript(x=output_groovy, name="elevDePittedAsc")
i <- which.max(tca+0)
xy <- xyFromCell(tca, i)
#
###
input_basin_extraction <- list()
input_basin_extraction$flowAsc <- getValueFromScript(x=output_groovy, name="flowAsc",coercion = FALSE)
input_basin_extraction$pNorth <- xy[,2]
input_basin_extraction$pEast <- xy[,1]
###
### 
### 
####
output_groovy_ExtractBasin <- executeGroovyFile(groovy_ExtractBasin,inputVar=input_basin_extraction,outputVar=NULL)

basin <- getValueFromScript(x=output_groovy_ExtractBasin, name="basinAsc")

