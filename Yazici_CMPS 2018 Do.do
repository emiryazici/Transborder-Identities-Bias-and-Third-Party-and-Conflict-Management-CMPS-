********************************************************************************
***Transborder Identities, Bias, and Third-Party Conflict Management Data(CMPS)
***Emir Yazici - 8/16/2018
********************************************************************************

/*
********************************************************************************
**********Conflict Management Techniques as Ordinal Variable********************
********************************************************************************

gen cm_level=3 if economic==1
recode cm_level (.=2) if diplomatic==1
recode cm_level (.=1) if verbal==1
recode cm_level (.=0)
sum cm_level


********************************************************************************
******************Now combine the variables from identity bias data*************
********************************************************************************

*Identity Ties Between Mediator and StateA

gen slang_ma=1 if gslang_am==1 | gslang_ma==1
gen srelig_ma=1 if gsrelig_am==1 | gsrelig_ma==1
gen sethnic_ma=1 if gsethnic_am==1 | gsethnic_ma==1
gen majminrel_ma=1 if majminrelig_am==1 | majminrelig_ma==1
gen majmineth_ma=1 if majminethnic_am==1 | majminethnic_ma==1
gen dep_ma=1 if deplo_am==1 | deplo_ma==1
gen dis_ma=1 if logdist_am==1 | logdist_ma==1
gen cont_ma=1 if contig_am==1 | contig_ma==1
gen all_ma=1 if alliance_am==1 | alliance_ma==1

recode slang_ma-all_ma (.=0)

*Identity Ties Between Mediator and StateB
gen slang_mb=1 if gslang_bm==1 | gslang_mb==1
gen srelig_mb=1 if gsrelig_bm==1 | gsrelig_mb==1
gen sethnic_mb=1 if gsethnic_bm==1 | gsethnic_mb==1
gen majminrel_mb=1 if majminrelig_bm==1 | majminrelig_mb==1
gen majmineth_mb=1 if majminethnic_bm==1 | majminethnic_mb==1
gen dep_mb=1 if deplo_bm==1 | deplo_mb==1
gen dis_mb=1 if logdist_bm==1 | logdist_mb==1
gen cont_mb=1 if contig_bm==1 | contig_mb==1
gen all_mb=1 if alliance_bm==1 | alliance_mb==1


recode slang_mb-all_mb (.=0)

********************************************************************************
***************Generate absolute identity bias variable*************************
********************************************************************************

*** Strength of identity ties with Side A
gen identity_bias_mat=slang_ma + srelig_ma + sethnic_ma
recode identity_bias_mat (.=0)


*** Strength of identity ties with Side B
gen identity_bias_mbt= slang_mb + srelig_mb + sethnic_mb
recode identity_bias_mbt (.=0)

*** Identity Bias (Ties with only one side)
gen identity_1_level=identity_bias_mat if identity_bias_mat>0 & identity_bias_mbt==0
recode identity_1_level (.=0)
replace identity_1_level=identity_bias_mbt if identity_bias_mbt>0 & identity_bias_mat==0


********************************************************************************
*****************************Relative Bias**************************************
********************************************************************************

gen rel_identity_bias=identity_bias_mat - identity_bias_mbt
recode rel_identity_bias (-3=3) (-2=2) (-1=1) (.=0)

********************************************************************************
**********************Equal Identity Ties with Both Sides***********************
********************************************************************************

gen equal_ties=identity_bias_mat if identity_bias_mat==identity_bias_mbt
recode equal_ties (-3=3) (-2=2) (-1=1) (.=0)

********************************************************************************
**************Specific Identity Tie variables (for robustneess check)***********
********************************************************************************
*Ethnic Bias
gen ethnic_1=1 if sethnic_ma==1 | sethnic_mb==1
recode ethnic_1 (.=0)

*Ethnic Ties with Both Sides 
gen ethnic_2=1 if sethnic_ma==1 & sethnic_mb==1
recode ethnic_2 (.=0)

*Language Bias
gen lang_1=1 if slang_ma==1 | slang_mb==1
recode lang_1 (.=0)

*Language Ties with Both Sides 
gen lang_2=1 if slang_ma==1 & slang_mb==1
recode lang_2 (.=0)

*Religious Bias
gen relig_1=1 if srelig_ma==1 | srelig_mb==1
recode relig_1 (.=0)

*Religious Ties with Both Sides 
gen relig_2=1 if srelig_ma==1 & srelig_mb==1
recode relig_2 (.=0)


*****************************Label Key Variables************************************
label variable intervention "Intervention"
label variable cm_level "Level of Intervention"
label variable rel_identity_bias "Strength of Identity Bias"
label variable equal_ties "Strength of Identity Ties with Both Sides"

label variable ethnic_1 "Ethnic Bias"
label variable ethnic_2 "Ethnic Ties with Both Sides"

label variable lang_1 "Language Bias"
label variable lang_2 "Language Ties with Both Sides"

label variable relig_1 "Religious Bias"
label variable relig_2 "Religious Ties with Both Sides"


label define cm_level 0 "No Intervention" 1 "Verbal" 2 "Diplomatic" 3 "Economic"

*/
********************************************************************************
*****************************Summary Statistics*********************************
********************************************************************************

estpost sum intervention economic diplomatic verbal rel_identity_bias equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, listwise
esttab using Summary_statistics.tex, label title(Summary Statistics table\label{tab1}) cells("mean sd min max") nomtitle nonumber
esttab , label nostar title(Summary Statistics table\label{tab1})

********************************************************************************
********************************************************************************

************************Logit and Ordered Logit Models**************************
******How Does Identity Bias Affect Likelihod and Type of CM?*******************

**Identity Bias and Overall CM
eststo clear
eststo: logit intervention rel_identity_bias alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)
esttab using IdentityBiasandCM1.tex, label star(* 0.10 ** 0.05 *** 0.001) title("Identity Bias and Conflict Management"\label{tab1})

**Identity Bias and CM TYPE
eststo clear
eststo: mlogit cm_level rel_identity_bias alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id) iterate(100)
esttab using IdentityBiasandCM2.tex, label star(* 0.10 ** 0.05 *** 0.001) title("Identity Bias and Type of Conflict Management"\label{tab1}) uns noomitted

********************************************************************************
************************Substantive Effects Graphs******************************
********************************************************************************
drop b1-b19

estsimp logit intervention rel_identity_bias alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)

********************************************************************************
************************Substantive Effect of Bias on CM************************

*Three different scenarios based on probability of conflict management (all other bias types are controlled)

postfile pv3 xaxis me1 se1 lo1 hi1 me2 se2 lo2 hi2 me3 se3 lo3 hi3 using "Predicted Probabilities--Scenarios.dta", replace

qui foreach i of numlist 0(1)3 {
	*Scenario 1: Worst Case Scenario: Cost is high and pr(success) is low = cinc score, no successful cm before, lower # of cm attempts before, no cm in previous year)

	setx rel_identity_bias `i' alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag p5 prevcm 0 prevcmsuccess 0 prevmid median dcontig median cinc p5

	simqi, prval(1) genpr(pr1)

	qui sum pr1
	local me1 = r(mean)
	local se1 = r(sd)
	
	_pctile pr1, p(2.5 97.5)
	local lo1 = r(r1)
	local hi1 = r(r2)
	
	*Scenario 2: Average Scenario: Average cost and average pr(success)= continous variables at average value, dummy variables at median value 

	setx rel_identity_bias `i' alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean

	simqi, prval(1) genpr(pr2)	

	qui sum pr2
	local me2 = r(mean)
	local se2 = r(sd)
	
	_pctile pr2, p(2.5 97.5)
	local lo2 = r(r1)
	local hi2 = r(r2)
	
	*Scenario 3: Best Case Scenario: Low cost and high pr(success)= high cinc score, successful cm before, higher # of cm attempts before, cm in previous year)

	setx rel_identity_bias `i' alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag p95 prevcm 1 prevcmsuccess 1 prevmid median dcontig median cinc p95

	simqi, prval(1) genpr(pr3)	
	
	qui sum pr3
	local me3 = r(mean)
	local se3 = r(sd)
	
	_pctile pr3, p(2.5 97.5)
	local lo3 = r(r1)
	local hi3 = r(r2)
	
	drop pr1 pr2 pr3
	post pv3 (`i') (`me1') (`se1') (`lo1') (`hi1') (`me2') (`se2') (`lo2') (`hi2') (`me3') (`se3') (`lo3') (`hi3')
}

postclose pv3

preserve
	use "Predicted Probabilities--Scenarios.dta", clear

	twoway (line me1 xaxis) (line lo1 xaxis, lpattern(dash)) (line hi1 xaxis, lpattern(dash)), /*
	*/	xtitle("Strength of Identity Bias") ytitle("Pr(Conflict Management)") note("Dashed lines represent 95% confidence intervals") legend(off) graphregion(color(white)) bgcolor(white) scheme(s2mono)

	twoway (line me2 xaxis) (line lo2 xaxis, lpattern(dash)) (line hi2 xaxis, lpattern(dash)), /*
	*/	xtitle("Strength of Identity Bias") ytitle("Pr(Conflict Management)") note("Dashed lines represent 95% confidence intervals") legend(off) graphregion(color(white)) bgcolor(white) scheme(s2mono)

	twoway (line me3 xaxis) (line lo3 xaxis, lpattern(dash)) (line hi3 xaxis, lpattern(dash)), /*
	*/	xtitle("Strength of Identity Bias") ytitle("Pr(Conflict Management)") note("Dashed lines represent 95% confidence intervals") legend(off) graphregion(color(white)) bgcolor(white) scheme(s2mono)
	
********************************************************************************
****Substantive Effects of Identity Bias on Type of CM (In Average Scenario)****
drop b1-b54

estsimp mlogit cm_level rel_identity_bias alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id) iterate(100)

postfile pv10 xaxis me1 se1 lo1 hi1 me2 se2 lo2 hi2 me3 se3 lo3 hi3 using "Predicted Probabilities--Scenarios.dta", replace

qui foreach i of numlist 0(1)3 {
	*Pr(Verbal)
	setx rel_identity_bias `i' alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean

	simqi, prval(1) genpr(pr1)

	qui sum pr1
	local me1 = r(mean)
	local se1 = r(sd)
	
	_pctile pr1, p(2.5 97.5)
	local lo1 = r(r1)
	local hi1 = r(r2)
	
	*Pr(Diplomatic)

	setx rel_identity_bias `i' alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean

	simqi, prval(2) genpr(pr2)	

	qui sum pr2
	local me2 = r(mean)
	local se2 = r(sd)
	
	_pctile pr2, p(2.5 97.5)
	local lo2 = r(r1)
	local hi2 = r(r2)
	
	*Pr(Economic)

	setx rel_identity_bias `i' alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean

	simqi, prval(3) genpr(pr3)	
	
	qui sum pr3
	local me3 = r(mean)
	local se3 = r(sd)
	
	_pctile pr3, p(2.5 97.5)
	local lo3 = r(r1)
	local hi3 = r(r2)
	
	drop pr1 pr2 pr3
	post pv10 (`i') (`me1') (`se1') (`lo1') (`hi1') (`me2') (`se2') (`lo2') (`hi2') (`me3') (`se3') (`lo3') (`hi3')
}

postclose pv10

preserve
	use "Predicted Probabilities--Scenarios.dta", clear

	twoway (line me1 xaxis) (line lo1 xaxis, lpattern(dash)) (line hi1 xaxis, lpattern(dash)), /*
	*/	xtitle("Strength of Identity Bias") ytitle("Pr(Verbal CM)") note("Dashed lines represent 95% confidence intervals") legend(off) graphregion(color(white)) bgcolor(white) scheme(s2mono)
	
	twoway (line me2 xaxis) (line lo2 xaxis, lpattern(dash)) (line hi2 xaxis, lpattern(dash)), /*
	*/	xtitle("Strength of Identity Bias") ytitle("Pr(Diplomatic CM)") note("Dashed lines represent 95% confidence intervals") legend(off) graphregion(color(white)) bgcolor(white) scheme(s2mono)

	twoway (line me3 xaxis) (line lo3 xaxis, lpattern(dash)) (line hi3 xaxis, lpattern(dash)), /*
	*/	xtitle("Strength of Identity Bias") ytitle("Pr(Economic CM)") note("Dashed lines represent 95% confidence intervals") legend(off) graphregion(color(white)) bgcolor(white) scheme(s2mono)

********************************************************************************
******How Does Equal Identity Ties Affect Likelihod and Type of CM?*************

**Equal Identity Ties and Overall CM

eststo clear
eststo: logit intervention equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)
esttab using IdentityBiasandCM3.tex, label star(* 0.10 ** 0.05 *** 0.001) title("Equal Identity Ties and Conflict Management"\label{tab1})


**Equal Identity Ties and Type of CM

eststo clear
eststo: mlogit cm_level equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id) iterate(100)
esttab using IdentityBiasandCM4.tex, label star(* 0.10 ** 0.05 *** 0.001) title("Equal Identity Ties and Type of Conflict Management"\label{tab1}) uns noomitted


********************************************************************************
************************Substantive Effects Graphs******************************
********************************************************************************

********************************************************************************
*************Substantive Effect of Equal Identity Ties with Both Sides on CM**********

*Three different scenarios based on probability of conflict management:
drop b1-b18

estsimp logit intervention equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)

postfile pv7 xaxis me1 se1 lo1 hi1 me2 se2 lo2 hi2 me3 se3 lo3 hi3 using "Predicted Probabilities--Scenarios.dta", replace

qui foreach i of numlist 0(1)3 {
	*Scenario 1: Worst Case Scenario: Cost is high and pr(success) is low = low cinc score, no successful cm before, lower # of cm attempts before, no cm in previous year)

	setx equal_ties `i' alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag p5 prevcm 0 prevcmsuccess 0 prevmid median dcontig median cinc p5

	simqi, prval(1) genpr(pr1)

	qui sum pr1
	local me1 = r(mean)
	local se1 = r(sd)
	
	_pctile pr1, p(2.5 97.5)
	local lo1 = r(r1)
	local hi1 = r(r2)
	
	*Scenario 2: Average Scenario: Average cost and average pr(success)= continous variables at average value, dummy variables at median value 

	setx equal_ties `i' alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean

	simqi, prval(1) genpr(pr2)	

	qui sum pr2
	local me2 = r(mean)
	local se2 = r(sd)
	
	_pctile pr2, p(2.5 97.5)
	local lo2 = r(r1)
	local hi2 = r(r2)
	
	*Scenario 3: Best Case Scenario: Low cost and high pr(success)= high cinc score, successful cm before, higher # of cm attempts before, cm in previous year)

	setx equal_ties `i' alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag p95 prevcm 1 prevcmsuccess 1 prevmid median dcontig median cinc p95

	simqi, prval(1) genpr(pr3)	
	
	qui sum pr3
	local me3 = r(mean)
	local se3 = r(sd)
	
	_pctile pr3, p(2.5 97.5)
	local lo3 = r(r1)
	local hi3 = r(r2)
	
	drop pr1 pr2 pr3
	post pv7 (`i') (`me1') (`se1') (`lo1') (`hi1') (`me2') (`se2') (`lo2') (`hi2') (`me3') (`se3') (`lo3') (`hi3')
}

postclose pv7

preserve
	use "Predicted Probabilities--Scenarios.dta", clear

	twoway (line me1 xaxis) (line lo1 xaxis, lpattern(dash)) (line hi1 xaxis, lpattern(dash)), /*
	*/	xtitle("Strength of Identity Ties with Both Sides") ytitle("Pr(Conflict Management)") note("Dashed lines represent 95% confidence intervals") legend(off) graphregion(color(white)) bgcolor(white) scheme(s2mono)

	twoway (line me2 xaxis) (line lo2 xaxis, lpattern(dash)) (line hi2 xaxis, lpattern(dash)), /*
	*/	xtitle("Strength of Identity Ties with Both Sides") ytitle("Pr(Conflict Management)") note("Dashed lines represent 95% confidence intervals") legend(off) graphregion(color(white)) bgcolor(white) scheme(s2mono)

	twoway (line me3 xaxis) (line lo3 xaxis, lpattern(dash)) (line hi3 xaxis, lpattern(dash)), /*
	*/	xtitle("Strength of Identity Ties with Both Sides") ytitle("Pr(Conflict Management)") note("Dashed lines represent 95% confidence intervals") legend(off) graphregion(color(white)) bgcolor(white) scheme(s2mono)
	

********************************************************************************
******Substantive Effects of Identity Ties with Both Sides on Type of CM*******
drop b1-b54

estsimp mlogit cm_level equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id) iterate(100)

postfile pv10 xaxis me1 se1 lo1 hi1 me2 se2 lo2 hi2 me3 se3 lo3 hi3 using "Predicted Probabilities--Scenarios.dta", replace

qui foreach i of numlist 0(1)3 {
	*Pr(Verbal)
	setx equal_ties `i' alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean

	simqi, prval(1) genpr(pr1)

	qui sum pr1
	local me1 = r(mean)
	local se1 = r(sd)
	
	_pctile pr1, p(2.5 97.5)
	local lo1 = r(r1)
	local hi1 = r(r2)
	
	*Pr(Diplomatic)

	setx equal_ties `i' alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean

	simqi, prval(2) genpr(pr2)	

	qui sum pr2
	local me2 = r(mean)
	local se2 = r(sd)
	
	_pctile pr2, p(2.5 97.5)
	local lo2 = r(r1)
	local hi2 = r(r2)
	
	*Pr(Economic)

	setx equal_ties `i' alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean

	simqi, prval(3) genpr(pr3)	
	
	qui sum pr3
	local me3 = r(mean)
	local se3 = r(sd)
	
	_pctile pr3, p(2.5 97.5)
	local lo3 = r(r1)
	local hi3 = r(r2)
	
	drop pr1 pr2 pr3
	post pv10 (`i') (`me1') (`se1') (`lo1') (`hi1') (`me2') (`se2') (`lo2') (`hi2') (`me3') (`se3') (`lo3') (`hi3')
}

postclose pv10

preserve
	use "Predicted Probabilities--Scenarios.dta", clear

	twoway (line me1 xaxis) (line lo1 xaxis, lpattern(dash)) (line hi1 xaxis, lpattern(dash)), /*
	*/	xtitle("Strength of Identity Ties with Both Sides") ytitle("Pr(Verbal CM)") note("Dashed lines represent 95% confidence intervals") legend(off) graphregion(color(white)) bgcolor(white) scheme(s2mono)

	twoway (line me2 xaxis) (line lo2 xaxis, lpattern(dash)) (line hi2 xaxis, lpattern(dash)), /*
	*/	xtitle("Strength of Identity Ties with Both Sides") ytitle("Pr(Diplomatic CM)") note("Dashed lines represent 95% confidence intervals") legend(off) graphregion(color(white)) bgcolor(white) scheme(s2mono)

	twoway (line me3 xaxis) (line lo3 xaxis, lpattern(dash)) (line hi3 xaxis, lpattern(dash)), /*
	*/	xtitle("Strength of Identity Ties with Both Sides") ytitle("Pr(Economic CM)") note("Dashed lines represent 95% confidence intervals") legend(off) graphregion(color(white)) bgcolor(white) scheme(s2mono)

	
********************************************************************************
***********************Substantive Effects with First Differences***************
********************************************************************************

********************************************************************************
*********Effect of Identity Bias on Likelihood of CM in Average Scenario*****************
********************************************************************************

*Average Scenario
estsimp logit intervention rel_identity_bias alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)
setx rel_identity_bias 0 alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean
simqi, prval(1)
simqi, fd(prval(1)) changex(rel_identity_bias 0 3)

drop b1-b18

*Worst Scenario
estsimp logit intervention rel_identity_bias alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)
setx rel_identity_bias 0 alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag p5 prevcm 0 prevcmsuccess 0 prevmid median dcontig median cinc p5
simqi, prval(1)
simqi, fd(prval(1)) changex(rel_identity_bias 0 3)

drop b1-b18

********************************************************************************
*********Effect of Identity Bias on Economic CM**********
********************************************************************************
estsimp mlogit cm_level rel_identity_bias alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id) iterate(100)
setx rel_identity_bias 0 alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean
simqi, prval(3)
simqi, fd(prval(3)) changex(rel_identity_bias 0 3)

drop b1-b54

********************************************************************************
*********Effect of Equal Identity Ties on CM*****
********************************************************************************

*Average Scenario

estsimp logit intervention equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id) iterate(100)
setx equal_ties 0 alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean
simqi, prval(1)
simqi, fd(prval(1)) changex(equal_ties 0 3)

drop b1-b18


*Worst Scenario
estsimp logit intervention equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id) iterate(100)
setx equal_ties 0 alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag p5 prevcm 0 prevcmsuccess 0 prevmid median dcontig median cinc p5
simqi, prval(1)
simqi, fd(prval(1)) changex(equal_ties 0 3)

drop b1-b18


********************************************************************************
*********Effect of Equal Identity Ties on Type of CM*****
********************************************************************************

**Change in the PR(CM=Verbal)
estsimp mlogit cm_level equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id) iterate(100)

setx equal_ties 0 alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean
simqi, prval(1)
simqi, fd(prval(1)) changex(equal_ties 0 3)

**Change in the PR(CM=Diplomatic)
drop b1-b54
estsimp mlogit cm_level equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id) iterate(100)

setx equal_ties 0 alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean
simqi, prval(2)
simqi, fd(prval(2)) changex(equal_ties 0 3)

**Change in the PR(CM=Economic)
drop b1-b54
estsimp mlogit cm_level equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id) iterate(100)

setx equal_ties 0 alliance1 median alliance2 median trade1_ds median trade2_ds median jointdem1 median jointdem2 median border1 median border2 median colony median prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean
simqi, prval(3)
simqi, fd(prval(3)) changex(equal_ties 0 3)

********************************************************************************
***************************Robustness Check*************************************
********************************************************************************

*Effect of Specific Identity Ties on Specific Types of Conflict Management Techniques
eststo clear
eststo: logit economic ethnic_1 ethnic_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)
eststo: logit economic lang_1 lang_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)
eststo: logit economic relig_1 relig_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)
esttab using IdentityTiesandEcon.tex, order(ethnic_1 ethnic_2 lang_1 lang_2 relig_1 relig_2) label star(* 0.10 ** 0.05 *** 0.001) title("Effect of Specific Identity Ties on Economic Intervention"\label{tab1})

eststo clear
eststo: logit diplomatic ethnic_1 ethnic_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)
eststo: logit diplomatic lang_1 lang_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)
eststo: logit diplomatic relig_1 relig_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)
esttab using IdentityTiesandDip.tex, order(ethnic_1 ethnic_2 lang_1 lang_2 relig_1 relig_2) label star(* 0.10 ** 0.05 *** 0.001) title("Effect of Specific Identity Ties on Diplomatic Conflict Management"\label{tab1})

eststo clear
eststo: logit verbal ethnic_1 ethnic_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)
eststo: logit verbal lang_1 lang_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)
eststo: logit verbal relig_1 relig_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, cluster(id)
esttab using IdentityTiesandVerbal.tex, order(ethnic_1 ethnic_2 lang_1 lang_2 relig_1 relig_2) label star(* 0.10 ** 0.05 *** 0.001) title("Effect of Specific Identity Ties on Verbal Conflict Management"\label{tab1})


