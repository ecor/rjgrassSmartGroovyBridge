\name{putValueInScript}
\alias{putInputValuesInScript}
\alias{putValueInScript}
\title{Put Method}
\usage{
putValueInScript(x, name, value,
  temporary_working_directory = system.file("temporary_rastermaps", package =
  "rjgrassGroovySmartBridge"), overwrite = TRUE, ...)

putInputValuesInScript(x, inputVar, io.type = c("input", "output"),
  putOutputNames = FALSE, outwpath = system.file("temporary_rastermaps",
  package = "rjgrassGroovySmartBridge"), ...)
}
\arguments{
  \item{x}{a S3 \code{ParsedGroovyScriptIOVar} object}

  \item{name}{name of the variable}

  \item{value}{value of the variable}

  \item{inputVar}{list with the value input of the input
  variables}

  \item{io.type}{vector of string indicating input and
  output types for the Groovy script file and \code{x} S3
  \code{ParsedGroovyScriptIOVar} object. Default is
  \code{c("input","output")}.}

  \item{putOutputNames}{logical value. Default is
  \code{FALSE}. If it is \code{TRUE}, the object \code{x}
  is filled with the output variables and their values
  instead of the input ones.}

  \item{temporary_working_directory,outwpath}{character
  string containing the path of the temporary working
  directory. It is used to save temporary raster maps.}

  \item{overwrite}{logical value. If \code{TRUE} the data
  files are overwritten. See \code{\link{writeRaster}}.}

  \item{...}{further arguments}
}
\description{
It puts a value of a variable in a S3
\code{ParsedGroovyScriptIOVar} object
}
\seealso{
\code{\link{executeGroovyFile}}
}

