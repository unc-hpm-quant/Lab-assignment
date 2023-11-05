version 15.1
capture log close
set more off
log using lecture5_lab.log, replace

/* This file is the lab for HPM 881 Unit 5 -- Interpretation

	Interpretation of racial categories using 3 different approaches: 
	1) unadjusted
	2) residual direct effect
	3) IOM approach

	Created: Dec. 1, 2020 */

* Read in the following variables from the 2018 Full Year Consolidated File (HC-209): 
* DVTEXP18, RACEV1X, AGELAST, EDUCYR, SEX, INSCOV, and RTHLTH53.  

	use DVTEXP18 RACEV1X AGELAST EDUCYR SEX INSCOV RTHLTH53 using /*
		*/ "C:\Users\trogdonj\OneDrive - University of North Carolina at Chapel Hill\Documents\research\data\MEPS\H209.dta", clear

*1.	Get to know your data. Drop observations with <=0 years of education and with missing/invalid responses to RTHLTH53. 
*	Describe the variables of interest (i.e., find descriptive statistics). 

	foreach X of varlist DVTEXP18 RACEV1X AGELAST SEX INSCOV  {
		* No missing values for these variables
		assert `X'~=. & `X'>=0
	}

	* Drop missings and zeros
	drop if EDUCYR <= 0
	drop if RTHLTH53 <= 0 

	* Continuous variables
	sum DVTEXP18 AGELAST
	
	* Categorical variables
	foreach X of varlist RACEV1X SEX INSCOV EDUCYR RTHLTH53 {
		tab `X', mi
	}

	save lecture5_lab, replace
	

*2.	We are interested in racial disparities in dental care expenditures. Summarize dental expenditures by race categories in RACEV1X.

	by RACEV1X, sort: sum DVTEXP18
	
	*or
	
	table RACEV1X, contents(mean DVTEXP18)


*3.	Create a bar graph showing the ratio of mean dental expenditures for each race category in RACEV1X relative to White. 
*	For example, if mean dental expenditures for White people = $150 and mean dental expenditures for Black people = $100, 
*	the Black/White ratio would = 0.67. 

	preserve

	collapse (mean) DVTEXP18, by(RACEV1X)
	l
	sum DVTEXP18 if RACEV1X==1, meanonly
	gen dvt_ratio = DVTEXP18 / r(mean)
	lab var dvt_ratio "Ratio relative to White"
	
	* Replace labels for graph
	lab def race 1 "White" 2 "Black" 3 "AI/AN" 4 "Asian/NH/PI" 6 "Multiple"
	lab val RACEV1X race
	l 
	
	graph bar (asis) dvt_ratio, over(RACEV1X) title("Ratio of Dental Expenditures to White Race")
	graph export lecture5_lab_fig3.png, replace
	
	restore


*4.	Unadjusted means approach: Using t-tests, test for differences in mean dental expenditures between each race category in RACEV1X and White. 
*   Interpret any statistically significant differences. 

	* Loop over values of RACEV1X
	foreach i in 2 3 4 6 {
		* ttest can only handle 2 groups in RACEV1X at once
		ttest DVTEXP18 if RACEV1X==1 | RACEV1X==`i', by(RACEV1X)
	}

	*On average, white persons spend $149 more on dental services than black people. 
	*Difference is statistically signifcant at 1% significance level.


*5.	Residual direct effect: Regression DVTEXP18 on RACEV1X, AGELAST, EDUCYR, SEX, INSCOV, and RTHLTH53 using White as the reference category
*	for RACEV1X. Interpret any statistically significant differences in the RACEV1X categories. Be precise in your language. 

	regress DVTEXP18 ib1.RACEV1X AGELAST EDUCYR i.SEX i.INSCOV i.RTHLTH53 

	* Don't use factor notation for other covariates to make it easier to plug in means in 'margins'
	tab SEX, gen(sex)
	tab INSCOV, gen(ins)
	tab RTHLTH53, gen(hlth)

	regress DVTEXP18 ib1.RACEV1X AGELAST EDUCYR sex2 ins2 ins3 hlth2-hlth5
	est store ols
	
	*Holding age, education, sex, health insurance, and self-reported health constant, expected dental expenditures are $121 less for
	*black persons relative to white persons. 
	*Holding age, education, sex, health insurance, and self-reported health constant, expected dental expenditures are not significantly 
	*different than white persons for other race groups.  


*6.	IOM approach: Which variables would you include in the “Clinical Appropriateness and Need” category? 
*	Which variables would you include in the “Operation of health care systems and legal and regulatory environment” category? 
*	NOTE: We do not have measures of patient preferences.

	*Clinical appropriateness and need: AGELAST SEX RTHLTH53
	*Operation: EDUCYR INSCOV


*7.	Generate predicted dental expenditures for the average White person.

	margins if RACEV1X==1
	
	*NOTE: Prediction should equal unadjusted average dental expenditures for white persons since they are the reference group
	

*8.	For each other race category in RACEV1X, generate predicted dental expenditures for the average person but use the White 
*	averages for Clinical Appropriateness and Need variables for every racial group. 

	* Replace every observations Clinical variables with white means
	preserve

	sum sex2 AGE hlth2-hlth5 if RACEV1X==1

	foreach X of var sex2 AGE hlth2-hlth5 {
		sum `X' if RACEV1X==1, meanonly
		replace `X' = r(mean)
	}

	sum sex2 AGE hlth2-hlth5

	* 'over()' option is like specifying separate 'if RACEV1X==.' options. 
	* Calculates predictions restricted to each subgroup
	* This is DIFFERENT than 'margins RACEV1X', which would pretend each person was each race
	* 'post' option is so we can use results from margin command
	margins, over(RACEV1X) post

*9.	Compare differences in predictions between race categories and White using the IOM approach vs the residual direct effect approach. 
* 	Which approach generates larger disparities? For which racial groups? 

	* Residual direct effect -- black vs white difference is -$121 (see regression from #5)
	* IOM approach
		* To see how to reference the predictions
		margins, coeflegend

		* What is the differene between white and black?
		di _b[1bn.RACEV1X] - _b[2.RACEV1X]

		* Is difference significant
		test _b[1bn.RACEV1X] = _b[2.RACEV1X]

		* Black vs white difference is -$140 and statistically significant at the 1% significance level (99% confidence level).
		* So IOM approach generates a slightly larger disparity than the residual effect approach. 

		* Check other differences
		foreach i in 3 4 6 {
			test _b[1bn.RACEV1X] = _b[`i'.RACEV1X]
		}
		* No other racial differences are statistically significant 

	restore

	* NOTE: Another way to get the difference is to focus on what's left in the prediction equations
	* E[DVTEXP18 | White] - E[DVTEXP18 | Black] = -b_Black + (b_educyr*E[EDUCYR | White] - b_educyr*E[EDUCYR | Black])
	* 											  + (b_ins*E[INSCOV | White] - b_ins*E[INSCOV | Black])

		est restore ols

		* Get means for Operation variables
		foreach X of var EDUCYR ins2 ins3 {
			sum `X' if RACEV1X==1, meanonly
			scalar `X'w = r(mean)
			sum `X' if RACEV1X==2, meanonly
			scalar `X'b = r(mean)
		}

		* Predicted difference between White and Black respondents in IOM approach
		scalar iom = -_b[2.RACEV1X] + _b[EDUCYR]*(EDUCYRw - EDUCYRb) + _b[ins2]*(ins2w - ins2b) + _b[ins3]*(ins3w - ins3b)
		di iom
	
log close
exit
