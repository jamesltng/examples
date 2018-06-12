* Mapping part 2

cd /Users/jng2/Desktop/unhappy
* change the above path to your own

set more off

use GSS2012_divisions, clear

gen unhappy = .
replace unhappy = 1 if happy==3
replace unhappy = 0 if happy==1 | happy==2

collapse (mean) unhappy [aw=wtss], by(subreg_id)

* merge the unhappiness data to the converted .dbf data

merge 1:1 subreg_id using usdata.dta
drop _merge

* modify map label coordinates. this step is not necessary; it's strictly cosmetic.

replace x_coord = x_coord+1 if subreg_id==1 //move EN Central to the right
replace y_coord = y_coord-1.5 if subreg_id==1 //move EN Central down
replace x_coord = x_coord+1 if subreg_id==5 //move New England to the right
replace x_coord = -121 if subreg_id==6 //explicitly specify position for Pacific
replace y_coord = 44 if subreg_id==6


* spmap produces the map

spmap unhappy using uscoord.dta, id(subreg_id) ///
clmethod(custom) clbreaks(0.09 0.11 0.13 0.15 0.17) ///
label(label(subreg_id) xcoord(x_coord) ycoord(y_coord) size(vsmall)) ///
fcolor(Reds) legtitle("Fraction of respondents who were unhappy") ///
title("Figure 3: Unhappiness by Census Division, 2012")

graph export unhappymap.png, replace
