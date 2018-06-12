cd /Volumes/~jng2/www/workshop
set more off
clear all

sysuse auto

/* Here's what I want to do
*Scatter plot of price vs mpg
twoway scatter price mpg, title(Price vs MPG)
graph export price_vs_mpg.png, replace

*Scatter plot of price vs foreign
twoway scatter price weight, title(Price vs weight)
graph export price_vs_weight.png, replace
*/

*This is how to do it using a program

capture program drop printgraph
program define printgraph
	twoway `1' `2' `3', title(`2' vs `3')
	graph export `2'_vs_`3'.png, replace
end

*Call the program as needed
printgraph scatter price mpg
printgraph scatter price weight
printgraph histogram mpg


*Modify the program to provide better titles
capture program drop printgraph
program define printgraph
	if "`1'" == "histogram" {
		local gtitle = "`1' of `2'"
	}
	else if "`1'" != "histogram"  {
		local gtitle = "`1' plot of `2' vs `3'"
	}
	twoway `1' `2' `3', title(`gtitle')
	graph export `1'_`2'_`3'.png, replace
end

printgraph scatter price mpg
printgraph histogram mpg
