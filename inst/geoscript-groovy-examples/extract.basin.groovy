
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




def flowAsc=rvar_input
def basinAsc =rvar_output
def pNorth=rvar_input
def pEast=rvar_input

wateroutlet=new Wateroutlet();
wateroutlet.pNorth=pNorth
wateroutlet.pEast=pEast
wateroutlet.inFlow=flowAsc; 
wateroutlet.outBasin=basinAsc;
wateroutlet.outArea=0;
wateroutlet.process();



