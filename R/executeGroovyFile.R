# TODO: Add comment
# 
# Author: ecor
###############################################################################
NULL

#'  executeGrovyFile
#' 
#' Execute a Geoscript-groovy or Groovy Script File 
#' 
#' @param x a S3 \code{ParsedGroovyScriptIOVar} object 
#' @param inputVar list with input variables
#' @param outputVar list with output variables
#' @param putOutputNames logical argument. Default is \code{FALSE}. See \code{\link{putValueInScript}}.
#' @param command string containing the Groovy command with necessary arguments. 
#' @param command_path string with the full path to the directory containing the \code{command} executable file. In Unix-like system,type \code{which groovy} to find the correct path.  
#' @param generated.geoscript file neme of the generated script run by \code{command}. 
#' @param sys.setenv list of environment variable settings required by \code{command}. See examples and usage. If \code{NULL} no environmental variables are set. 
#' @param verbose verbose modality. Default is \code{TRUE}. 
#' @param ... further arguments 
#' 
#' @export 
#' @examples 
#' 
#' library(rjgrassGroovySmartBridge)
#' 
#' 
#' file <- system.file("geoscript-groovy/geomorphological.analysis.groovy",package="rjgrassGroovySmartBridge")
#' groovy <- parseGroovyFile(file=file)
#' 
#' dem  <- system.file("examples/match100m.asc",package="rjgrassGroovySmartBridge")
#' 
#' ### INPUT VARIABLE
#' input <- list()
#' input$elevAsc <- dem
#' input$pThresScalar <- 10
#' 
#' ## OUTPUT VARIABLE
#' 
#' ###output <- list() 
#' outwpath <- system.file("temporary_output",package="rjgrassGroovySmartBridge")
#' 
#' output <- groovy[str_detect(unlist(lapply(X=groovy,FUN=function(x){attr(x,"io.type")})),"output")]
#' 
#' names_output <- names(output)
#' output <- lapply(X=names(output),FUN=function(x,outwpath){ 
#'    				out <- str_replace(x," ","_") 
#' 					out <- paste("output",out,sep="_")
#' 					out <- paste(outwpath,out,sep="/")
#' 					extension <- "asc"
#' 					if (str_detect(x,"Asc")) extension <- "asc"
#' 					if (str_detect(x,"Shp")) extension <- "shp"
#' 					out <- paste(out,extension,sep=".")
#' 					return(out)
#' 
#' },outwpath=outwpath)
#' 
#' names(output) <- names_output
#' 
#' executeGroovyFile(groovy,inputVar=input,outputVar=output)
#' 
#' 

## TO DO 

executeGroovyFile <- function(x,inputVar,outputVar=NULL,putOutputNames=FALSE,command="jgrass-geoscript-groovy",command_path=system.file("geoscript-groovy-with-jgrasstools/bin",package="rjgrassGroovySmartBridge"),
		generated.geoscript=paste(system.file("temporary_output",package="rjgrassGroovySmartBridge"),"last_geoscript.groovy",sep="/"),sys.setenv=list(GROOVY_HOME="/usr/local/groovy-2.1.6:/opt/local:/usr"),verbose=TRUE,...) {
	
	#### SEARCH COMMAND GEOSCRIT-GROOVY AND GROOVY
	if (is.na(sys.setenv)) sys.stenv <- NULL
	if (!is.null(sys.setenv)) {
		
		if (!is.list(sys.setenv)) { setenv <- as.list(sys.setenv)}
		
		do.call("Sys.setenv",sys.setenv)
		
	}
	
	pathEnv <- str_split(Sys.getenv("PATH"),":")[[1]]
	pathEnv <- paste(c(pathEnv,command_path),collapse=":")
	Sys.setenv(PATH=pathEnv)
	command_path <- NULL
	### ADAPTION FOR GROOVY LANGUAGE 
	GroovyHomeEnv <- Sys.getenv("GROOVY_HOME")
	GroovyHomeEnv <- str_split(Sys.getenv("GROOVY_HOME"),":")[[1]]
	GroovyBin <- paste(GroovyHomeEnv,"/bin/groovy",sep="")
	GroovyBinExt <- which(file.exists(GroovyBin))
	print(GroovyHomeEnv)
	print(GroovyBin)
	print(GroovyBinExt)
	if (length(GroovyBinExt)==0) {
		
		stop("No correct setting for GROOVY_HOME environment variable! Re-st with sys.setenv argument!!!")
		
	} else { 
	
		
		GroovyHomeEnv <- GroovyHomeEnv[GroovyBinExt[1]]
		Sys.setenv(GROOVY_HOME=GroovyHomeEnv)
	
	}
	##searchCommand <- lapply(X=pathEnv,FUN=function(x,command) list.files())
	
	#####
	
	
	out <- putInputValuesInScript(x=x,inputVar=inputVar,putOutputNames=FALSE,...)
	
	print(out)
	out <- putInputValuesInScript(x=out,inputVar=outputVar,putOutputNames=TRUE,...)

	
	argument <- readLines(attr(out,"groovyTemplateFile"))
	
	
	for (it in names(out)) {
		
		val <- out[[it]]
		it <- paste("def",it,sep=" ")
		i <- which(str_detect(argument,it))[1]
		
		if (is.na(val)) { 
		
				st_error <- paste("Error in groovy file/object:",it,"is NA!!!",sep=" ")
				stop(st_error)
		
		}
		else if (is.numeric(val)) { 
		
			val <- paste(val,collapse=",")
			
			
		} else if (is.character(val)) {
			
			val <- paste('\"',val,'\"',sep="")
			
		}
		
		
		argument[i] <- paste(it,val,sep="=")
		
		
	}
	
	
	writeLines(argument,con=generated.geoscript)
	
	if (verbose) {
		
		print(argument)
	}
	
#	comment <- which(str_detect(argument,"//"))
#	
#	argument[comment] <- str_replace(argument[comment],"//","/*")
#	argument[comment] <- paste(argument[comment],"*/",sep=" ")
#	
#	argument <- argument[argument!=""]
#	
#	argument <- paste(argument,collapse=";")
#	
#	## passare per file esterno!!!!!
#	argument <- paste('"\"',argument,'\"',sep="")
	
	if (is.null(command_path))  command_path <- NA
	if (!is.na(command_path))   command <- paste(command_path,command,sep="/") 
	
	command <- paste(command,generated.geoscript,sep=" ")
	print(command)
	
	
	print(paste("Launching",command,sep=" "))
	out_command <- system(command,intern=TRUE)
	print(out_command)
	if (!is.null(attr(out_command,"status"))) out <- out_command
	return(out)
	## TO GO ON .... put
	
}