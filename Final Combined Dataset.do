********************************************************************************
***Identity Ties and Conflict Management Data
***Emir Yazici - 9/28/2017
********************************************************************************
/*
*Keep only interstate conflicts
keep if d17==2
*Rename some variables for merge with Melin(2011) data
rename p5a statea
rename p5b stateb
rename cm4 potinta
gen year=d3b+1900

***************Merge with Identity Bias Datasets***************************
merge m:1 potinta statea year using "C:\Users\emiry\Desktop\CMKP Data Deneme\Identity Bias (M_A) Dataset.dta"
drop if _merge==2
drop _merge

merge m:1 potinta stateb year using "C:\Users\emiry\Desktop\CMKP Data Deneme\Identity Bias (M_B) Dataset.dta"
drop if _merge==2
drop _merge

merge m:1 statea potinta year using "C:\Users\emiry\Desktop\CMKP Data Deneme\Identity Bias (A_M) Dataset.dta"
drop if _merge==2
drop _merge

merge m:1 stateb potinta year using "C:\Users\emiry\Desktop\CMKP Data Deneme\Identity Bias (B_M) Dataset.dta"
drop if _merge==2
drop _merge

*****************CM Techniques as Ordinal Variable******************************
gen cm_level=3 if economic==1
recode cm_level (.=2) if diplomatic==1
recode cm_level (.=1) if verbal==1
recode cm_level (.=0)
sum cm_level

******************Now combine the variables from identity bias data*************
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

***************Generate overall identity bias variable************************
gen identity_bias_ma=1 if slang_ma==1 | srelig_ma==1 | sethnic_ma==1 
recode identity_bias_ma (.=0)
gen identity_bias_mb=1 if slang_mb==1| srelig_mb==1| sethnic_mb==1
recode identity_bias_mb (.=0)


*/
***********************Level of Identity Bias***********************************
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


**********************Identity Ties with both side******************************
gen identity_2=1 if identity_bias_ma==1 & identity_bias_mb==1
recode identity_2 (.=0)

gen identity_3=1 if identity_bias_mat>0 & identity_bias_mbt>0
recode identity_3 (.=0)

**********************Specific Identity Tie variables***************************
*Ethnic
gen ethnic_1=1 if sethnic_ma==1 | sethnic_mb==1
recode ethnic_1 (.=0)
gen ethnic_2=1 if sethnic_ma==1 & sethnic_mb==1
recode ethnic_2 (.=0)

*Language
gen lang_1=1 if slang_ma==1 | slang_mb==1
recode lang_1 (.=0)
gen lang_2=1 if slang_ma==1 & slang_mb==1
recode lang_2 (.=0)

*Religion
gen relig_1=1 if srelig_ma==1 | srelig_mb==1
recode relig_1 (.=0)
gen relig_2=1 if srelig_ma==1 & srelig_mb==1
recode relig_2 (.=0)

*/
***********************Level of Asymmetrical Identity Bias**********************
*** Strength of identity ties with the minority in Side A
gen a_identity_bias_mat=majminrel_ma+majmineth_ma
recode a_identity_bias_mat (.=0)


*** Strength of identity ties with the minority in Side B
gen a_identity_bias_mbt= majminrel_mb+majmineth_mb
recode a_identity_bias_mbt (.=0)

*** Asymmetrical Identity Bias (Ties with only one side)
gen a_identity_1_level=a_identity_bias_mat if a_identity_bias_mat>0 & a_identity_bias_mbt==0
recode a_identity_1_level (.=0)
replace a_identity_1_level=a_identity_bias_mbt if a_identity_bias_mbt>0 & a_identity_bias_mat==0


********************************************************************************
********************************************************************************
********************************************************************************

*******************************RELATIVE BIAS************************************

*1) Relative Bias: 
gen rel_identity_bias=identity_bias_mat - identity_bias_mbt
recode rel_identity_bias (-3=3) (-2=2) (-1=1) (.=0)

**********************EQUAL IDENTITY TIES WITH BOTH SIDES***********************

gen equal_ties=identity_bias_mat if identity_bias_mat==identity_bias_mbt
recode equal_ties (-3=3) (-2=2) (-1=1) (.=0)


********************************************************************************
********************************************************************************
********************************************************************************


*************Identity Ties with subnational groups in both sides****************
gen a_identity_2=1 if a_identity_bias_ma==1 & a_identity_bias_mb==1
recode a_identity_2 (.=0)

*****Label Variables
label variable intervention "Intervention"
label cm_level "Level of Intervention"
label variable identity_1_level "Level Identity Bias"
label variable identity_2 "Identity Ties with Both Sides"
label variable a_identity_1_level "Level of Asymmetrical Identity Bias"
label variable a_identity_2 "Identity Ties with Minority Groups in Both Sides"
    
*/
***Summary Statistics
estpost sum cm_level intervention identity_1_level identity_2 a_identity_1_level alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc, listwise
esttab using Summary_statistics.tex, label title(Summary Statistics table\label{tab1}) cells("mean sd min max") nomtitle nonumber
esttab , label nostar title(Summary Statistics table\label{tab1})

*/
************************Logit and Ordered Logit Models**************************
******How Does Identity Bias Affect Likelihod and Intrusiveness Level of CM?****
eststo clear
eststo: logit intervention rel_identity_bias equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc , cluster(id)

***Identity Ties and Likelihood Different CM Techniques
eststo clear
eststo: logit economic rel_identity_bias equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc , cluster(id)
eststo: logit diplomatic rel_identity_bias equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc , cluster(id)
eststo: logit verbal rel_identity_bias equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc , cluster(id)
esttab using IdentityTiesandCM2.tex, label star(* 0.10 ** 0.05 *** 0.001) title("Role of Identity Ties in Occurence of Diffrent Types of Conflict Management"\label{tab1})


********************************************************************************
********************************************************************************
*******************Censored Probit (Mixed Process Regression********************




probit economic rel_identity_bias equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc , cluster(id)
predict p
margins, dydx(*)
cmp (economic = rel_identity_bias equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc) (intervention = rel_identity_bias equal_ties alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc), ind($cmp_probit $cmp_probit) qui
predict p2, pr
margins, dydx(*) predict(pr)




********************************************************************************
********************************************************************************
********************************************************************************

***************************Substantive Effects**********************************
*********Effect of Identity Ties on Likelihood of CM Across Three Scenarios*****
********************************************************************************
drop b1-b20
estsimp logit intervention identity_1_level identity_2 a_identity_1_level alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc , cluster(id)

***Base Probability
setx identity_1_level 0 identity_2 median a_identity_1_level 0 alliance1 0 alliance2 median trade1_ds 0 trade2_ds median jointdem1 0 jointdem2 median border1 median border2 median colony 0 prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean
simqi, prval(1)

*Scenario 1: Worst Case Scenario: Cost is high and pr(success) is low = low cinc score, no successful cm before, lower # of cm attempts before, no cm in previous year)
*** First differences
setx identity_1_level 0 identity_2 median a_identity_1_level 0 alliance1 0 alliance2 median trade1_ds 0 trade2_ds median jointdem1 0 jointdem2 median border1 0 border2 0 colony 0 prevmidtp median nmgmt_lag p5 prevcm 0 prevcmsuccess 0 prevmid median dcontig median cinc p5
simqi, prval(1)

simqi, fd(prval(1)) changex(identity_1_level 0 3)
simqi, fd(prval(1)) changex(a_identity_1_level 0 2)
simqi, fd(prval(1)) changex(alliance1 0 1)
simqi, fd(prval(1)) changex(trade1_ds 0 1)
simqi, fd(prval(1)) changex(jointdem1 0 1)
simqi, fd(prval(1)) changex(colony 0 1)
simqi, fd(prval(1)) changex(border1 0 1)
simqi, fd(prval(1)) changex(border2 0 1)


*Scenario 2: Average Scenario: Average cost and average pr(success)= continous variables at average value, dummy variables at median value 
*** First differences
setx identity_1 0 identity_2 median a_identity_1 0 alliance1 0 alliance2 median trade1_ds 0 trade2_ds median jointdem1 0 jointdem2 median border1 0 border2 0 colony 0 prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean
simqi, prval(1)

simqi, fd(prval(1)) changex(identity_1_level 0 3)
simqi, fd(prval(1)) changex(a_identity_1_level 0 2)
simqi, fd(prval(1)) changex(alliance1 0 1)
simqi, fd(prval(1)) changex(trade1_ds 0 1)
simqi, fd(prval(1)) changex(jointdem1 0 1)
simqi, fd(prval(1)) changex(colony 0 1)
simqi, fd(prval(1)) changex(border1 0 1)
simqi, fd(prval(1)) changex(border2 0 1)




*Scenario 3: Best Case Scenario: Low cost and high pr(success)= high cinc score, successful cm before, higher # of cm attempts before, cm in previous year)
setx identity_1_level 0 identity_2 median a_identity_1 0 alliance1 0 alliance2 median trade1_ds 0 trade2_ds median jointdem1 0 jointdem2 median border1 0 border2 0 colony 0 prevmidtp median nmgmt_lag p95 prevcm 1 prevcmsuccess 1 prevmid median dcontig median cinc p95
simqi, prval(1)

simqi, fd(prval(1)) changex(identity_1_level 0 3)
simqi, fd(prval(1)) changex(a_identity_1_level 0 2)
simqi, fd(prval(1)) changex(alliance1 0 1)
simqi, fd(prval(1)) changex(trade1_ds 0 1)
simqi, fd(prval(1)) changex(jointdem1 0 1)
simqi, fd(prval(1)) changex(colony 0 1)
simqi, fd(prval(1)) changex(border1 0 1)
simqi, fd(prval(1)) changex(border2 0 1)


*********Effect of Identity Ties on Level of CM Across Three Scenarios*****
********************************************************************************
drop b1-b20
estsimp ologit cm_level identity_1_level identity_2 a_identity_1_level alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc , cluster(id)

*Scenario 1: Worst Case Scenario: Cost is high and pr(success) is low = low cinc score, no successful cm before, lower # of cm attempts before, no cm in previous year)
*** First differences
setx identity_1_level 0 identity_2 median a_identity_1_level 0 alliance1 0 alliance2 median trade1_ds 0 trade2_ds median jointdem1 0 jointdem2 median border1 0 border2 0 colony 0 prevmidtp median nmgmt_lag p5 prevcm 0 prevcmsuccess 0 prevmid median dcontig median cinc p5
simqi, prval(1)

simqi, fd(prval(1)) changex(identity_1 0 1)
simqi, fd(prval(1)) changex(a_identity_1_level 0 2)
simqi, fd(prval(1)) changex(alliance1 0 1)
simqi, fd(prval(1)) changex(trade1_ds 0 1)
simqi, fd(prval(1)) changex(jointdem1 0 1)
simqi, fd(prval(1)) changex(colony 0 1)
simqi, fd(prval(1)) changex(border1 0 1)
simqi, fd(prval(1)) changex(border2 0 1)

*Scenario 2: Average Scenario: Average cost and average pr(success)= continous variables at average value, dummy variables at median value 
*** First differences
setx identity_1_level 0 identity_2 median a_identity_1_level 0 alliance1 0 alliance2 median trade1_ds 0 trade2_ds median jointdem1 0 jointdem2 median border1 0 border2 0 colony 0 prevmidtp median nmgmt_lag mean prevcm median prevcmsuccess median prevmid median dcontig median cinc mean
simqi, prval(1)

simqi, fd(prval(1)) changex(identity_1 0 1)
simqi, fd(prval(1)) changex(a_identity_1_level 0 2)
simqi, fd(prval(1)) changex(alliance1 0 1)
simqi, fd(prval(1)) changex(trade1_ds 0 1)
simqi, fd(prval(1)) changex(jointdem1 0 1)
simqi, fd(prval(1)) changex(colony 0 1)
simqi, fd(prval(1)) changex(border1 0 1)
simqi, fd(prval(1)) changex(border2 0 1)

*Scenario 3: Best Case Scenario: Low cost and high pr(success)= high cinc score, successful cm before, higher # of cm attempts before, cm in previous year)
setx identity_1_level 0 identity_2 median a_identity_1_level 0 alliance1 0 alliance2 median trade1_ds 0 trade2_ds median jointdem1 0 jointdem2 median border1 0 border2 0 colony 0 prevmidtp median nmgmt_lag p95 prevcm 1 prevcmsuccess 1 prevmid median dcontig median cinc p95
simqi, prval(1)

simqi, fd(prval(1)) changex(identity_1 0 1)
simqi, fd(prval(1)) changex(a_identity_1_level 0 2)
simqi, fd(prval(1)) changex(alliance1 0 1)
simqi, fd(prval(1)) changex(trade1_ds 0 1)
simqi, fd(prval(1)) changex(jointdem1 0 1)
simqi, fd(prval(1)) changex(colony 0 1)
simqi, fd(prval(1)) changex(border1 0 1)
simqi, fd(prval(1)) changex(border2 0 1)

***************************Robustness Check*************************************

***Specific Identity Ties and Likelihood of CM Techniques
eststo clear
eststo: logit intervention ethnic_1 ethnic_2 lang_1 lang_2 relig_1 relig_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc , cluster(id)
eststo: logit intervention lang_1 lang_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc , cluster(id)
eststo: logit intervention relig_1 relig_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc , cluster(id)
esttab using IdentityTiesandCM3.tex, label star(* 0.10 ** 0.05 *** 0.001) title("Role of Specific Identity Ties in Conflict Management Occurence"\label{tab1})

logit economic ethnic_1 ethnic_2 lang_1 lang_2 relig_1 relig_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc , cluster(id)
logit economic lang_1 lang_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc , cluster(id)
logit economic relig_1 relig_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc , cluster(id)

logit diplomatic ethnic_1 ethnic_2 lang_1 lang_2 relig_1 relig_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc , cluster(id)
logit diplomatic lang_1 lang_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc , cluster(id)
logit diplomatic relig_1 relig_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc , cluster(id)

logit verbal ethnic_1 ethnic_2 lang_1 lang_2 relig_1 relig_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc , cluster(id)
logit verbal lang_1 lang_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc , cluster(id)
logit verbal relig_1 relig_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc , cluster(id)

*****************How Specific Identity Ties Affect Level of CM?*****************
eststo clear
eststo: ologit cm_level ethnic_1 ethnic_2 lang_1 lang_2 relig_1 relig_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc , cluster(id)
eststo: ologit cm_level lang_1 lang_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc , cluster(id)
eststo: ologit cm_level relig_1 relig_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmsuccess prevmid dcontig cinc , cluster(id)
esttab using IdentityTiesandCM4.tex, label star(* 0.10 ** 0.05 *** 0.001) title("Effect of Specific Identity Ties on Intrusiveness Level of Conflict Management"\label{tab1})

****************************Duration Models (Melin(2011)************************
*pooled*
stset t2, failure(intervention)
eststo: streg  identity_1 identity_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc , nohr strata(eventtype) cluster(id) distribution(weibull)
*Figure 1
sts graph, hazard by(eventtype) tmax(8000) legend(label(1 "Verbal") label(2 "Diplomatic") label(3 "Economic")) scheme(s2mono)

*Table 2
*economic*
stset t2, failure(economic)
eststo: streg  identity_1 identity_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc , nohr strata(eventtype) cluster(id) distribution(weibull)

*Table 2
*diplomatic*
stset t2, failure(diplomatic)
eststo: streg  identity_1 identity_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc, nohr strata(eventtype) cluster(id) distribution(weibull)

*Table 2
*verbal*
stset t2, failure(verbal)
eststo: streg  identity_1 identity_2 alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc, nohr strata(eventtype) cluster(id) distribution(weibull)

esttab using IdentityTiesandCM2.tex, label star(* 0.10 ** 0.05 *** 0.001) title("Role of Identity Bias in Conflict Management Timing"\label{tab1})

