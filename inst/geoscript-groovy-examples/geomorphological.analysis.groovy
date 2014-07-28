//
//
// inspired by http://www.slideshare.net/moovida/05-geographic-scripting-in-udig-halfway-between-user-and-developer
// Author: Emanuele Cordano, Andrea Antonello
//
// suggestions here for installing groovy on mac: 
// http://www.delineneo.com/2011/01/13/installing-groovy-on-a-mac/
// http://geoscript.org/groovy/usage.html#geoscript-groovy
//
//



import geoscript.geom.*
import geoscript.proj.*
import geoscript.render.*
import geoscript.layer.*
import geoscript.style.*
import geoscript.style.io.*
import geoscript.viewer.*
import geoscript.filter.*
import geoscript.workspace.*
import org.jgrasstools.modules.*
import javax.imageio.*

// I/O variables form R environment 
// These variable must have prefix 'RVAR_'  
def elevAsc = rvar_input
def elevDePittedAsc = rvar_output
def flowAsc =rvar_output
def tcaAsc = rvar_output
def netAsc = rvar_output
def netShp = rvar_output
def pThresScalar=rvar_input

// Pit Filler http://code.google.com/p/jgrasstools/wiki/Pitfiller
pitfiller= new Pitfiller();
pitfiller.inElev=elevAsc;
pitfiller.outPit=elevDePittedAsc;
pitfiller.process();  // http://docs.oracle.com/javase/7/docs/api/javax/imageio/ImageReader.html

// calculate flowdirections and tca LeastCostFlowDirections 
leastcostflowdirections = new LeastCostFlowDirections(); 
leastcostflowdirections.inElev = elevDePittedAsc; 
leastcostflowdirections.outFlow = flowAsc; 
leastcostflowdirections.outTca = tcaAsc; 
leastcostflowdirections.process(); 

// extract the network raster 

ExtractNetwork extractnetwork = new ExtractNetwork(); 
extractnetwork.inTca = tcaAsc; 
extractnetwork.inFlow = flowAsc; 
extractnetwork.pThres = pThresScalar; 
extractnetwork.outNet = netAsc; 
extractnetwork.process(); 

