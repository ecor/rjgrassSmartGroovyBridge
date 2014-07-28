# TODO: Add comment
# 
# Author: ecor
###############################################################################


NULL
#' Get Method
#' 
#' Gets the value of a variable in a S3 \code{ParsedGroovyScriptIOVar} object
#' 
#' @param x a S3 \code{ParsedGroovyScriptIOVar} object
#' @param name name of the variablelogical value. 
#' @param coercion logical value. If it is \code{TRUE} (Deafault) the returened variable is coerced. 
#' @param ... further arguments
#' 
#' @import raster
#' 
#' @export 
#' 


getValueFromScript <- function(x,name,coercion=TRUE,...) {
	str(x)
	out <- x[[name]] 
	
	if (str_detect(name,"Asc") & coercion) {
		str(out)
		out <- raster(out)
		
	}
	
	
	return(out)
	
}


