***

cls
di " Stata 18.5"

display  in r c(version)
which groupfunction
sysuse auto, clear
groupfunction [aw=weight], mean(price) min(weight) by(foreign)
sum