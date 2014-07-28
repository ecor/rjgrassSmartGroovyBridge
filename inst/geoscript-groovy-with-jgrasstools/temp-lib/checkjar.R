# TODO: Add comment
# 
# Author: ecor
###############################################################################
rm(list=ls())
library(stringr)

ssmatch <- function(x,y,NUM=5) { 

		### multiple y 
		if (length(y)>1) {
			
			out <- FALSE
			for (it in y) {
				
				out <- ssmatch(x=x,y=it,NUM=NUM) | out
				
			}
			
			return(out)
			
		}
		#### multiple x 
		if (length(x)>1) {
			
			out <- unlist(lapply(X=x,FUN=ssmatch,y=y,NUM=NUM))
			return(out)
		}
		
		
		## x and y are scalar 
		y <- str_sub(y,1,NUM)
		out <- str_match(x,y)[1,1]
		
		out <- (out==x) | str_length(out)>=NUM | (x==y) 
		out <- out & !is.na(out)
		if (out==TRUE) {
			print(x) 
			print(y) 
			print(out)
		}
		return(out)

}

temp_lib <- "/Users/ecor/Dropbox/hydropica/sourcesR/rjgrassGroovySmartBridge/inst/geoscript-groovy-with-jgrasstools/temp-lib/lib"
geoscript_groovy_lib <- "/Users/ecor/Dropbox/hydropica/sourcesR/rjgrassGroovySmartBridge/inst/geoscript-groovy-with-jgrasstools/lib"

temp_jar <- list.files(temp_lib,pattern=".jar")
geoscript_groovy_jar <- list.files(geoscript_groovy_lib,pattern=".jar")

out <- ssmatch(temp_jar,geoscript_groovy_jar)

temp_jar_to_save <- temp_jar[!out]