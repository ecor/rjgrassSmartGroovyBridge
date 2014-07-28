//
//
// inspired by http://www.slideshare.net/moovida/05-geographic-scripting-in-udig-halfway-between-user-and-developer
// Author: Emanuele Cordano, Andrea Antenallo
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




flowpath ="FLOWASC"
basinpath = "BASINASC" 
pNorth=YOUTLET
pEast=XOUTLET

wateroutletBrenta=new Wateroutlet();
wateroutletBrenta.pNorth=pNorth
wateroutletBrenta.pEast=pEast
wateroutletBrenta.inFlow=flowpath; 
wateroutletBrenta.outBasin=basinpath;
wateroutletBrenta.outArea=0;
wateroutletBrenta.process();



