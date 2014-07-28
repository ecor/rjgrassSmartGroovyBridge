# TODO: Add comment
# 
# Author: ecor
###############################################################################

NULL
#' Put Method
#' 
#' It puts a value of a variable in a S3 \code{ParsedGroovyScriptIOVar} object
#' 
#' @param x a S3 \code{ParsedGroovyScriptIOVar} object
#' @param name name of the variable
#' @param value value of the variable
#' @param inputVar list with the value input of the input variables
####
#' @param io.type vector of string indicating input and output types for the Groovy script file and \code{x} S3 \code{ParsedGroovyScriptIOVar} object. Default is \code{c("input","output")}. 
#' @param putOutputNames logical value. Default is \code{FALSE}. If it is \code{TRUE}, the object \code{x} is filled with the output variables and their values instead of the input ones.   
#' @param temporary_working_directory,outwpath character string containing the path of the temporary working directory. It is used to save temporary raster maps. 
#' @param overwrite logical value. If \code{TRUE} the data files are overwritten. See \code{\link{writeRaster}}.
#' 
#' @param ... further arguments
#' 
#' @rdname putValueInScript
#' 
#' @import raster
#' @seealso \code{\link{executeGroovyFile}}
#' 
#' @export 
#' 


putValueInScript <- function(x,name,value,temporary_working_directory=system.file("temporary_rastermaps",package="rjgrassGroovySmartBridge"),overwrite=TRUE,...) {
	
	if (!(name %in% names(x))) {
		
		names_string <- paste(names(x),collapse=",")
		message <- sprintf("putValueInScript: %s is not present among %s!!",name,names_string)
		warning(message)
		
	}
	
	if (class(value)=="RasterLayer") {
		filename <- paste("ascfile_for_",name,".asc",sep="")
		fileprj <- paste("ascfile_for_",name,".prj",sep="")
		filename <- paste(temporary_working_directory,filename,sep="/")
		fileprj <-  paste(temporary_working_directory,fileprj,sep="/")
		print(filename)
		print(fileprj)
		writeRaster(value, filename,overwrite=overwrite,NAflag=-9999)
		
	#	print(fileprj)
		
		crs <- proj4string(value)
		
		if (is.null(crs)) crs <- NA 
		if (!is.na(crs)) showWKT(crs,file=fileprj)  
		value <- filename
		print(value)
	}
	
	
	out <- x 
	attr(value,"io.type") <- attr(x[[name]],"io.type")
	out[[name]] <- value
	print(out)
	return(out)
	
}

NULL
#'
#' 
#' @export 
#' @rdname  putValueInScript
#' 
#' 
putInputValuesInScript <- function(x,inputVar,io.type=c("input","output"),putOutputNames=FALSE,outwpath=system.file("temporary_rastermaps",package="rjgrassGroovySmartBridge"),...) {
	
	iinpt=1
	if (putOutputNames) iinpt=2
	
	if (putOutputNames & is.null(inputVar[1])) inputVar <- NA 
	io_opt_v <- unlist(lapply(X=x,FUN=function(t){attr(t,"io.type")}))
	if (putOutputNames & is.na(inputVar[1])) {
		
		
		inputVar <- unlist(x[str_detect(unlist(lapply(X=x,FUN=function(t){attr(t,"io.type")})),io.type[iinpt])])
		print(inputVar)
		inputVar_name <- names(inputVar)
		inputVar <- lapply(X=names(inputVar),FUN=function(x,outwpath){ 
    				out <- str_replace(x," ","_") 
 					out <- paste("output",out,sep="_")
 					out <- paste(outwpath,out,sep="/")
					extension <- "asc"
 					if (str_detect(x,"Asc")) extension <- "asc"
 					if (str_detect(x,"Shp")) extension <- "shp"
 					out <- paste(out,extension,sep=".")
 					return(out)
 
 		},outwpath=outwpath)
	
		names(inputVar) <- inputVar_name
	
		# output <- groovy[str_detect(unlist(lapply(X=groovy,FUN=function(x){attr(x,"io.type")})),"output")]
# 
# names_output <- names(output)
# output <- lapply(X=names(output),FUN=function(x,outwpath){ 
#    				out <- str_replace(x," ","_") 
# 					out <- paste("output",out,sep="_")
# 					out <- paste(outwpath,out,sep="/")
# 					extension <- "asc"
# 					if (str_detect(x,"Asc")) extension <- "asc"
# 					if (str_detect(x,"Shp")) extension <- "shp"
# 					out <- paste(out,extension,sep=".")
# 					return(out)
# 
# },outwpath=outwpath)
# 
# names(output) <- names_output
# 
		
		
	}
	

##	io_opt_v <- unlist(lapply(X=x,FUN=function(t){attr(t,"io.type")}))
	
	names(io_opt_v) <- names(x)
	input <-which(str_detect(io_opt_v,io.type[iinpt])) 
	print("input:")
	print(input)
	names_input <- names(x)[input]
	
	out <- x 
	if (length(input)>0) {
		
		cond <- names(inputVar) %in% names_input
		if (length(which(cond))<length(inputVar)) {
			
			names_inputVar <- paste(names(inputVar),collapse=",")
			names_input <- paste(names_input,collapse=",")
			message <- sprintf("No Match among input/output variables of x ( %s )and inputVar( %s )!!",names_input,names_inputVar)
			warning(message)
			
		}
		inputVar <- inputVar[names(inputVar) %in% names_input]
		
		for (it in names(inputVar)) {
			
			
			out <- putValueInScript(x=out,name=it,value=inputVar[[it]],...)
			
		}
 		
		
	} else {
		
		warning("No Input Variabes to replace found!!")
		
	}
	
	return(out)
	
}