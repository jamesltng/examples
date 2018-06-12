cd /Volumes/~jng2/www/workshop
set more off
clear all

********************************************************************************
*Manipulate happiness data and save in new file
use "http://www3.nd.edu/~jng2/workshop/gss_happy.dta", clear

tab happy
tab happy, nolabel

/* Notice that 1-very happy, 2-pretty, 3-not too happy, which 
is the opposite of what's in Figure 1. Need to recode. */
gen happynew = happy
replace happynew = 3 if happy == 1
replace happynew = 1 if happy == 3
label var happynew "3-very, 2-pretty, 1-not too happy"

*Alternatively, recode happy (1=3)(3=1), gen(happynew)

*Check that recode was done correctly:
tab happy happynew, nolabel

collapse (mean) meanhappy=happynew, by(year)
label var meanhappy "Mean happiness: 3-very, 2-pretty, 1-not too"

*Alternatively: by year: egen meanhappy = mean(happy) 
*and then do a 1:m merge using gss

keep if year>=1975 & year<=1997

save gsshappy, replace

*Check that years are unique
duplicates report year

********************************************************************************
*Manipulate GDP data, then merge with happiness file
use "http://www3.nd.edu/~jng2/workshop/pwt_gdp.dta", clear

keep if year>=1975 & year<=1997

*Check that years are unique
duplicates report year

gen rgdppc = rgdpna/pop
label var rgdppc "Real GDP per capita"

merge 1:1 year using gsshappy

********************************************************************************
*if you browse the data, you will find that it looks exactly like Table 1
*to output the data verbatim to a comma-delimited file, use the outsheet command

outsheet year rgdppc meanhappy using table1.csv, comma replace

********************************************************************************
*Draw Figure 1
/*for detailed help on how to customize the appearance of graphs, check:
help twoway options
help axis options
help area options
help legend options
help title options
help graph 
*/

local title1 "Mean Happiness and Real GDP Per Capita between 1975 and 1997" 
local title2 "for Repeated Cross-Sections of (Different) Americans"
local note1 "Notes: Right-hand scale is the average of the answers to the question from the United Sates General Social Survey:"
local note2 "Taken all together, how would you say things are these days--would you say that you are (3) very happy"
local note3 "(2) pretty happy, or (1) not too happy? Real GDP per capita is measured in 2005 US dollars."

twoway ///
connected rgdppc year, yaxis(1) ylabel(#4, axis(1)) ///
msymbol(O) yscale(range(20000 35000) axis(1)) ///
ytitle("Real GDP per capita", box bcolor(white) bmargin(0 4 0 0) axis(1))  ///
||    ///
connected meanhappy year, yaxis(2) ylabel(1.8(0.2)2.6, axis(2)) ///
msymbol(X) yscale(range(1.8 2.6) axis(2)) ///
ytitle("Mean happiness", box bcolor(white) bmargin(4 0 0 0) axis(2)) ///
, ///
legend(cols(1) rows(2) position(0) bplace(nwest) bmargin(7 0 0 0) label(2 "Mean happiness")) ///
graphregion(color(white)) plotregion(color(white)) xtitle("") ysize(2) xsize(3) ///
title("`title1'" "`title2'", justification(left) bmargin(-13 15 5 0) box bcolor(white)) ///
note("`note1'" "`note2'" "`note3'", justification(left)  bmargin(-13 15 0 3) box bcolor(white))

graph save happygdp, replace
*this saves the graph in StataÕs .gph file format

graph export happygdp.png, replace
*this exports the graph to an external file format for use by other software. supported formats include PNG and PDF.
