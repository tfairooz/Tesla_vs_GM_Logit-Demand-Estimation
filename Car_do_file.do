** Import Car_data
import delimited "/Users/tahsinfairooz/Desktop/MA Courses/Academics/Szabo_IO/Car_HW2/car_data.csv", clear

** to compute Market Share from the market size(which in this case is the total number of cars sold in US. iow, the total number of consumers)
gen marketshare = quantity/250000000
gen log_sj = ln(marketshare)
egen totalmarketshare = total(marketshare)
gen so = 1 - totalmarketshare 
gen log_so = ln(so)

** Our main task now is to find the marginal utility of the characteristics in our choice bundle, and the linear equation.  
** Step1. compute delta_j(Relative market share)
gen delta_j = log_sj - log_so

sum delta_j

predict xi, residual

********************************//**************************************
** Step 2. to estimate marginal utility of the characteristics; ** there is 4 characteristic including price (alpha in utility function) 
reg delta_j price weight gpm hp 

// to find cye
** to test for homoskedasticity 
predict xi, resid
* to eyeball homoskedasticity
rvfplot, yline(0)
* residuals looks heteroskedastic
predict yhat
gen xisq = xi^2

** F-stat:
reg delta_j price weight gpm hp
estat hettest, fstat rhs

* performing F-test:

display (0.0522/4)
disp ((1-0.0522)/210-4-1) 

disp 0.01305/4.9954867

** F-stat: 0.00261
* f_critical: 2.37
*fail to reject H0; data holds homoskedasticity assumption

* LM test:
reg xisq price weight gpm hp
* use r^2 * No. of obs
display 0.0522*210  
* 10.962

reg delta_j price weight gpm hp 
estat hettest, iid rhs

***************************//


* for choice set Tesla sedan, gm sedan
expand 2 if j==4
replace make ="Tesla" in 211
replace gpm = 1/2*gpm in 211
replace model ="sedan" in 211

expand 2 if j==13
replace make ="GM" in 212
replace gpm = 1/2*gpm in 212
replace model ="sedan" in 212

gen evj=exp(_b[price]*price + _b[weight]*weight + _b[gpm]*gpm + _b[hp]*hp + _b[_cons]*_cons + xi)

egen totalevj=total(evj)
gen pr_j =evj/(1+totalevj)
gen n_quant = pr_j * 250000000
gen profit = n_quant*(price-marginalcost) 
egen gmprofit=total(profit) if gm==1

drop if make== "GM"| make== "Tesla"
drop evj
drop totalevj
drop pr_j
drop n_quant
drop profit
drop gmprofit


** for choice set Tesla sedan, gm suv 

expand 2 if j==4
replace make ="Tesla" in 211
replace gpm = 1/2*gpm in 211
replace model ="sedan" in 211

expand 2 if j==16
replace make ="GM" in 212
replace gpm = 1/2*gpm in 212
replace model ="suv" in 212

gen evj=exp(_b[price]*price + _b[weight]*weight + _b[gpm]*gpm + _b[hp]*hp + _b[_cons]*_cons + xi)

egen totalevj=total(evj)
gen pr_j =evj/(1+totalevj)
gen n_quant = pr_j * 250000000
gen profit = n_quant*(price-marginalcost)
egen gmprofit=total(profit) if gm==1
 

drop if make== "GM"| make== "Tesla"
drop evj
drop totalevj
drop pr_j
drop n_quant
drop profit
drop gmprofit



** for choice set Tesla Suv, gm suv
expand 2 if j==1
replace make ="Tesla" in 211
replace gpm = 1/2*gpm in 211
replace model ="suv" in 211


expand 2 if j==16
replace make ="GM" in 212
replace gpm = 1/2*gpm in 212
replace model ="suv" in 212

gen evj=exp(_b[price]*price + _b[weight]*weight + _b[gpm]*gpm + _b[hp]*hp + _b[_cons]*_cons + xi)

egen totalevj=total(evj)
gen pr_j =evj/(1+totalevj)
gen n_quant = pr_j * 250000000
gen profit = n_quant*(price-marginalcost) 
egen gmprofit=total(profit) if gm==1


drop if make== "GM"| make== "Tesla"
drop evj
drop totalevj
drop pr_j
drop n_quant
drop profit
drop gmprofit


** for choice set Tesla suv, gm sedan
expand 2 if j==1
replace make ="Tesla" in 211
replace gpm = 1/2*gpm in 211
replace model ="suv" in 211

expand 2 if j==13
replace make ="GM" in 212
replace gpm = 1/2*gpm in 212
replace model ="sedan" in 212

gen evj=exp(_b[price]*price + _b[weight]*weight + _b[gpm]*gpm + _b[hp]*hp + _b[_cons]*_cons + xi)

egen totalevj=total(evj)
gen pr_j =evj/(1+totalevj)
gen n_quant = pr_j * 250000000
gen profit = n_quant*(price-marginalcost)
egen gmprofit=total(profit) if gm==1
 


drop if make== "GM"| make== "Tesla"
drop evj
drop totalevj
drop pr_j
drop n_quant
drop profit
drop gmprofit
  
clear




