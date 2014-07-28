# TODO: Add comment
# 
# Author: ecor
###############################################################################
NULL
#' parseGroovyFile
#' 
#' Parsing the groovy file
#' 
#' @param file groovy file name
#' @param prefix character sting indicationg the i/o variables in the groovy template script file  
#' @param io.type character sting indicationg the input-output options in the groovy template script file  
#' @param ... further arguments
#' 
#' @export
#' 
#' @seealso \url{http://groovy.codehaus.org},\url{http://groovy.codehaus.org/Tutorial+1+-+Getting+started}(Groovy Tutorial)
#' 
#' @examples 
#'  library(rjgrassGroovySmartBridge)
#' 
#### file <- "/Users/ecor/Dropbox/hydropica/sourcesR/rjgrassGroovySmartBridge/inst/geoscript-groovy/geomorphological.analysis.groovy"
#' file <- system.file("geoscript-groovy/geomorphological.analysis.groovy",package="rjgrassGroovySmartBridge")
#' out <- parseGroovyFile(file=file)
#' 
#' 



parseGroovyFile <- function(file="/Users/ecor/Dropbox/hydropica/sourcesR/rjgrassGroovySmartBridge/inst/geoscript-groovy/geomorphological.analysis.groovy"
							,prefix="rvar_",io.type=c("input","output"),...) {
						
						names(io.type) <- c("input","output")
						out <- readLines(file,...)
						
						lines <- which(str_detect(out,prefix) & str_detect(out,"="))
						
						out <- out[lines]
						
						out <-  str_split(out,"=")
						
						out_names <- unlist(lapply(X=out,FUN=function(x){
											out <- str_split(x[1]," ")[[1]]
											if (out[1]=="def") {
												out <- out[2]
											} else { 
												out <- out[1]
											}
											out <- str_replace_all(out," ","")
											return(out)
										}))
			##			out_names <- str_replace_all(out_names," ","")
						out_attr <- lapply(X=out,FUN=function(x){x[2]})
						names(out_attr) <- out_names
						
						out <- list()
						
						for (it in out_names) {
							
							out[[it]] <- NA
							attr(out[[it]],"io.type") <- as.character(out_attr[it])
							
						}
						
						
						attr(out,"io.type") <- io.type
						
						list_attr <- list(...)
						
						nlist_attr <- names(list_attr)
						
						for (it in nlist_attr) {
							
							attr(out,it) <- list_attr[it]
						}
						
						attr(out,"groovyTemplateFile") <- file 
						
						class(out) <- "ParsedGroovyScriptIOVar"
						###  groovy -e  "a=2  ; println a "

						
						return(out)
						
					}

	
NULL

#' 
#'\code{print} S3 method for \code{ParsedGroovyScriptIOVar} object returned by \code{\link{parseGroovyFile}}
#'
#' @param x a \code{ParsedGroovyScriptIOVar} object 
#' @param ...   passed arguments to \code{\link{writeLines}}  
#' 
#' @export
#' 
#' @import methods stringr
#' 
#' @rdname print
#' @method print ParsedGroovyScriptIOVar
#' @S3method print ParsedGroovyScriptIOVar
#' @aliases print
#' 
#'  
#' @examples
#' library(rjgrassGroovySmartBridge)
#' 
#' 
#' file <- system.file("geoscript-groovy/geomorphological.analysis.groovy",package="rjgrassGroovySmartBridge")
#' groovy <- parseGroovyFile(file=file)
#' groovy

print.ParsedGroovyScriptIOVar <- function (x,...) {
	
	io_opt <- attr(x,"io.type")
	io_opt_v <- unlist(lapply(X=x,FUN=function(t){attr(t,"io.type")}))
	values <- unlist(lapply(X=x,FUN=function(t){paste(t,collapse=",")}))
	names(io_opt_v) <- names(x)
	names(values) <- names(x)
	
	input <-which(str_detect(io_opt_v,io_opt[1])) 
	output <-which(str_detect(io_opt_v,io_opt[2])) 
	
	fileprint <- system.file("template/ParsedGroovyScriptIOVar.template.txt",package="rjgrassGroovySmartBridge")  
	out <- readLines(fileprint)
	
	var_record <- "Name:%s,  Value:%s"

	iin <- which(str_detect(out,"Input:"))
	iout <- which(str_detect(out,"Output:"))
	
	
	inputlines <- sprintf(var_record,names(x)[input],x[input])
	outputlines <- sprintf(var_record,names(x)[output],x[output])
	
	out <- c(out[1:iin],inputlines,out[(iin+1):iout],outputlines,out[(iout+1):length(out)])
	
	ifile <- which(str_detect(out,"File:"))
	
	out[ifile] <- paste("File:",attr(x,"groovyTemplateFile"))
	
	iattr <- which(str_detect(out,"Other Attributes:"))
	
	attributes <- attributes(x) 
	
	attributes <- attributes[!(names(attributes) %in% c("io.type","groovyTemplateFile"))]
	if (length(attributes)>0) {
		
		
		out_attributes <- unlist(lapply(X=attributes,FUN=function(t){paste(t,collapse=",")}))
		out_attributes <- paste(names(attributes),out_attributes,sep=": ")
		out <- c(out[1:iattr],out_attributes,out[(iattr+1):length(out)])
	}
	
	writeLines(out,...)
	
	
	return(x)
}



