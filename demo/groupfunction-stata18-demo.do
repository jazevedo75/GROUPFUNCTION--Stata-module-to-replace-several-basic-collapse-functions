***

cd "c:/data"

capture whereis myados
if _rc == 0 global clone "`r(myados)'/groupfunction/src"
	  
log using "`r(myados)'/groupfunction/demo/stata18.log", text replace

	cls

	clear all
	set more off
	set obs 300000

	version 13
	set seed 458267

	gen region = int(runiform()*20)

	replace region = 1 if inrange(region,0,3)
	replace region = 2 if inrange(region,4,5)


	//Income per capita
	forval z=1/200{
			gen x_`z' = region*runiform()*4000 + rnormal()*200
	}


	forval z=1/300{
			gen y`z' = runiform()*100 + (rnormal()*20)^2
	}

	gen wtg = abs(rnormal())

	//time collapse
	preserve
	timer on 1
	collapse (mean) y* x_* [aw=wtg], by(region)
	timer off 1
	restore

	//time fcollapse (Weights not supported)
	preserve
	timer on 2
	fcollapse (mean) y* x_*, by(region)
	timer off 2 
	restore

	//time groupfunction
	preserve 
	timer on 3
	groupfunction [aw=wtg], mean(y* x_*) by(region)
	timer off 3
	restore


	di " Stata 18.5"

	display  in r c(version)
	which groupfunction

	timer list

	cd ${clone}
	  
	which groupfunction
	  
	  //time groupfunction
	preserve 
	timer on 4
	groupfunction [aw=wtg], mean(y* x_*) by(region)
	timer off 4
	restore

	timer list


log close