* Mapping part 1

cd /Users/jng2/Desktop/unhappy
* change the above path to your own

set more off

*convert shapefile to two *.dta files: usdata.dta and uscoord.dta

shp2dta using shapefile/regions.shp, ///
database(usdata.dta) coordinates(uscoord.dta) ///
gencentroids(coord) genid(id) replace
