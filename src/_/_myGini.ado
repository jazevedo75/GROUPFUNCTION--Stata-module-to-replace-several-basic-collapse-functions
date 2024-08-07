*!version 1.0 (7 Aug 2024)
* Created _myGini program to call python function for Gini calculation. Adjusted the main code to call this new function.

program _myGini
	version 16
	syntax varlist(max=1 numeric) [if] [in] [aw pw fw]
	marksample touse1					 
	local vlist: list uniq varlist
	local wvar : word 2 of `exp'
	if "`wvar'"=="" {
		tempvar w
		gen `w' = 1
		local wvar `w'
	}
	
	python: from __main__ import gini ; gini("`vlist'","`wvar'","`touse1'")
		
end


python:
from sfi import Data
import numpy as np
from numpy import cumsum
from sfi import Scalar

def gini(y,w, touse):
	y = np.matrix(Data.get(y, selectvar=touse))
	w = np.matrix(Data.get(w, selectvar=touse))
	t = np.array(np.transpose(np.concatenate([y,w])))
	t = t[t[:,0].argsort()]
	y = t[:,0]
	w= t[:,1]
	yw = y*w
	rxw = cumsum(yw) - yw/2
	gini = 1-2*((np.transpose(rxw).dot(w)/np.transpose(y).dot(w))/sum(w))
	Scalar.setValue("r(gini)", gini)
end

