****** Dissertation Data Cleaning*********
* Topic: the reversed relationship betweent happiness and hedonic consumption in China
* Dataset: CFPS 2010,2012, 2014, 2016, 2018
*******

*** set file path 
global root = "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science"
global rawdata = "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Public Data/"
global data = "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Clean Data/"
global logfiles = "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Log"

********CFPS2020 Individual Data cleaning
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Public Data/[CFPS2020_in_STATA_(Chinese)/cfps2020person_202306.dta", clear 

*********Variables check 
describe 
codebook, compact 

//keep relevant variables 
keep pid code fid20 fid_base age gender selfrpt interrupt subsample subpopulation rswt_natcs20n rswt_natpn1020n rswtps_natcs20n rswtps_natpn1020n provcd20 urban20 employ marriage_last marriage_last_update child16n_2 cfps2020edu cfps2020eduy cfps2020eduy_im qp201 qm2016 qn412 qn416 qn12012 qn12016 qn1001 qf5_a_1 qf5_a_2 qm2011 qq1002 qn411 qq4010 qq403a
//we only need 1 family identifier for this year

*** explore descriptives
summarize,detail 

*********Missing values 
//variable:  gender, age, employ, cfps2020eduy, cfps2020eduy_im, qp201, qm2016, qn412, qn416, qn12012, qn12016, qn1001, qm2011,qq1002,qn411,qq4010,qq403a
//-10, -9, -8, -2, -1
foreach var of varlist gender age cfps2020eduy cfps2020eduy_im qp201 qm2016 qn412 qn416 qn12012 qn12016 qn1001 qm2011 qq1002 qn411 qq4010 qq403a {
	replace `var' = . if inlist(`var', -10, -9, -8, -2, -1)
}

//variables: cfps2020edu, marriage_last, marriage_last_update
//-10,-9,-8,-2,-1,0
foreach var of varlist cfps2020edu marriage_last marriage_last_update {
	replace `var' = . if inlist(`var', -10, -9, -8, -2, -1, 0)
}

//variable: qf5_a_1, qf5_a_2
//-10,-9,-8,-2,-1,6,7
foreach var of varlist qf5_a_1 qf5_a_2 {
    replace `var' = . if inlist(`var', -10, -9, -8, -2, -1, 6, 7)
}

*Recode dummies 
recode employ (2 = 0 "Unemployed") (3 = 0 "Unemployed") (8 = 0 "Umployed") (9 = 0 "Umployed") (1 = 1 "Employed"), gen (employment_status)
recode qn1001 (5 = 0 "Little trust") (1 = 1 "Mostly trust"), gen (trust) 
drop employ 
drop qn1001

*List of old and new variables 
local oldnames "rswt_natcs20n rswt_natpn1020n rswtps_natcs20n rswtps_natpn1020n cfps2020edu cfps2020eduy cfps2020eduy_im qp201 qm2016 qn412 qn416 qn12012 qn12016 qq1002 qf5_a_1 qf5_a_2 qm2011 qn411 qq4010 qq403a" 
local newnames "cross_sec_weight panel_weight cross_sec_weight_stra panel_weight_stra education edu_yrs edu_yrs_im health_status happiness_xinfu happiness_yukuai happiness_enjoylife life_satis confidence_future dine_fam father_relation mother_relation interper_relation sleep_quality sleep_duration bed_time"
*Renaming variables 
local i = 1
foreach oldvar of local oldnames {
    local newvar : word `i' of `newnames'
    rename `oldvar' `newvar'
    local i = `i' + 1
}
 
rename provcd20 provcd
rename urban20 urban 

*Reverse the coding of sleep_quality (negatively phrased)
gen reversed_sleep_quality = 5 - sleep_quality
// Verify the changes
list sleep_quality reversed_sleep_quality in 1/10
// Rename the variable back to its old name 
drop sleep_quality
rename reversed_sleep_quality sleep_quality 

* Reverse the health_status variable
gen reversed_health_status = 6 - health_status
//Define the new value labels
label define health_label 1 "Poor" 2 "Fair" 3 "Good" 4 "Very good" 5 "Excellent"
//Apply the value labels to the reversed variable
label values reversed_health_status health_label
//Verify the reversed variable and labels
tabulate reversed_health_status, missing
list health_status reversed_health_status in 1/10
//Rename the variable to its old name 
drop health_status
rename reversed_health_status health_status
*** explore descriptives again after cleaning 
summarize,detail 

*Generate year identifier 
gen year = 2020
order pid year 

//drop interpersonal relationship 
drop interper_relation
rename fid20 fid 

********CFPS2018 Individual Data cleaning
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Public Data/2018stata数据/ecfps2018person_202012.dta", clear

*********Variables check 
describe 
codebook, compact 

//Keep relevant variables 
keep pid code fid18 selfrpt interrupt subsample subpopulation rswt_natcs18n rswt_natpn1018n provcd18 urban18 respc1pid gender age marriage_last marriage_last_update cfps2018edu cfps2018eduy cfps2018eduy_im employ qp201 qm2016 qn412 qn416 qn12012 qn12016 qm106m qm107m qn1001 qq1002 qf5_a_1 qf5_a_2 qn411 qq4010 qq403a
//relationship with mother and father missing 

*** explore descriptives
summarize,detail 

*********Missing values 
//variable:  gender, age
//-10, -9, -8, -2, -1, 79
foreach var of varlist gender age {
    replace `var' = . if inlist(`var', -10, -9, -8, -2, -1, 79)
}

//variable: marriage_last, marriage_last_update
//missing value: -10, -9, -8, -2, -1, 0
foreach var of varlist marriage_last marriage_last_update {
	replace `var' = . if inlist(`var', -10, -9, -8, -2, -1, 0)
}

//variables: cfps2018edu
//-10,-9,-8,-2,-1,0
replace cfps2018edu = . if inlist(cfps2018edu, -10, -9, -8, -2, -1, 0)

//variable: cfps2018eduy, cfps2018eduy_im, qp201, qm2016, qn412. qn416, qn12012, qn12016, qn1001, qq1002, qn411, qq4010, qq403a
//-10,-9,-8,-2,-1
foreach var of varlist cfps2018eduy cfps2018eduy_im qp201 qm2016 qn412 qn416 qn12012 qn12016 qn1001 qq1002 qn411 qq4010 qq403a {
	replace `var' = . if inlist(`var', -10, -9, -8, -2, -1)
}

//variable: employ
//-10,-9,-8,-2,-1
replace employ = . if inlist(employ, -10, -9, -8, -2, -1)
//8 shouldn't be treated as missing value but unemployement instead****

//variable:qm106m, qm107m
//-10, -9, -8, -2, -1, 79, 6
replace qm106m = . if inlist(qm106m, -10, -9, -8, -2, -1, 79, 6)
replace qm107m = . if inlist(qm107m, -10, -9, -8, -2, -1, 79, 6)

*Recode dummies 
recode employ (2 = 0 "Unemployed") (3 = 0 "Unemployed") (8 = 0 "Unemployed") (9 = 0 "Umployed") (1 = 1 "Employed"), gen (employment_status)
drop employ 

//Recode the trust variable
rename qn1001 trust
recode trust (5 = 0) (1 = 1)
//Define the value labels
label define trust_label 0 "Little trust" 1 "Mostly trust"
//Apply the value labels to the recoded variable
label values trust trust_label
//Verify the changes
tabulate trust, missing


*List of old and new variables 
local oldnames "rswt_natcs18n rswt_natpn1018n cfps2018edu cfps2018eduy cfps2018eduy_im qp201 qm2016 qn412 qn416 qn12012 qn12016 qm106m qm107m qq1002 qf5_a_1 qf5_a_2 qn411 qq4010 qq403a qq403b" 
local newnames "cross_sec_weight panel_weight education edu_yrs edu_yrs_im health_status happiness_xinfu happiness_yukuai happiness_enjoylife life_satis confidence_future posi_self satisfi_self dine_fam father_relation mother_relation sleep_quality sleep_duration bed_time"
//relationship with parents 

*Renaming variables 
local i = 1
foreach oldvar of local oldnames {
    local newvar : word `i' of `newnames'
    rename `oldvar' `newvar'
    local i = `i' + 1
}
 
rename provcd18 provcd
rename urban18 urban 

*Reverse the coding of sleep_quality (negatively phrased)
gen reversed_sleep_quality = 5 - sleep_quality
// Verify the changes
list sleep_quality reversed_sleep_quality in 1/10
// Rename the variable back to its old name 
drop sleep_quality
rename reversed_sleep_quality sleep_quality 

* Reverse the health_status variable
gen reversed_health_status = 6 - health_status
//Define the new value labels
label define health_label 1 "Poor" 2 "Fair" 3 "Good" 4 "Very good" 5 "Excellent"
//Apply the value labels to the reversed variable
label values reversed_health_status health_label
//Verify the reversed variable and labels
tabulate reversed_health_status, missing
list health_status reversed_health_status in 1/10
//Rename the variable to its old name 
drop health_status
rename reversed_health_status health_status

*** explore descriptives again after cleaning 
summarize,detail 

rename fid18 fid 
*Generate year identifier 
gen year = 2018 
order pid year 

********CFPS2016 Individual Data cleaning
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Public Data/CFPS2016 in STATA (English)/ecfps2016adult_201906.dta", clear

*********Variables check 
describe 
codebook, compact 

*Keep relevant variables 
keep pid fid16 code_a_p subsample subpopulation provcd16 urban16 rswt_natcs16 rswt_rescs16 rswt_natpn1016 rswt_respn1016 selfrpt self_interrupt cfps_gene cfps_age cfps_gender cfps2014_marriage cfps_childn pa603 cfps2016edu cfps2016eduy cfps2016eduy_im employ qp201 qm2014 pn412 pn416 qn12012 qn12014 pm106m pm107m pn1001 qf5_a_1 qf5_a_2 qm2011 ce4 pq1002 pn411 qq4010 qq403a
//the difference between rswt_natcs16 rswt_rescs16 rswt_natpn1016 rswt_respn1016 ? 

*** explore descriptives
summarize,detail 

*********Missing values 
//variable:  gender, age, number_children, pa603, years_of_edu, years_of_edu_im, employ, qp201(health_status), qm2014, pn412, pn416, qn12012, qn12014, pn1001, qm2011, ce4, pq1002, pn411, qq4010, qq403a
//-10, -9, -8, -2, -1
foreach var of varlist cfps_age cfps_gender cfps_childn cfps2016eduy cfps2016eduy_im employ qp201 qm2014 pn412 pn416 qn12012 qn12014 pn1001 qm2011 ce4 pq1002 pn411 qq4010 qq403a {
	replace `var' = . if inlist(`var', -10, -9, -8, -2, -1)
}

//variable: marriage, highest education
//-10, -9, -8, -2, -1, 0
foreach var of varlist cfps2014_marriage cfps2016edu {
	replace `var' = . if inlist(`var', -10, -9, -8, -2, -1, 0)
}

//variable: pm106m, pm107m
////-10, -9, -8, -2, -1, 6, 79
replace pm106m = . if inlist(pm106m, -10, -9, -8, -2, -1, 79, 6)
replace pm107m = . if inlist(pm107m, -10, -9, -8, -2, -1, 79, 6)

*Recode dummies 
//double check the label values for employment 
recode employ (2 = 0 "Unemployed") (3 = 0 "Unemployed") (1 = 1 "Employed"), gen (employment_status)
recode pn1001 (5 = 0 "Little trust") (1 = 1 "Mostly trust"), gen (trust)

drop employ
drop pn1001

drop ce4
drop qm2011

*List of old and new variables 
local oldnames "rswt_natcs16 rswt_rescs16 rswt_natpn1016 rswt_respn1016 cfps_age cfps_gender cfps_childn  cfps2016edu cfps2016eduy cfps2016eduy_im qp201 qm2014 pn412 pn416 qn12012 qn12014 pm106m pm107m qf5_a_1 qf5_a_2 pq1002 pn411 qq4010 qq403a" 

local newnames "cross_sec_weight_total cross_sec_weight_rep panel_weight panel_weight_rep age gender children  edu2016 years_edu2016 years_edu_im2016 health_status happiness_xinfu happiness_yukuai happiness_enjoylife life_satis confidence_future posi_self satisfi_self relation_father relation_mother dine_fam sleep_quality sleep_duration bed_time"

*Renaming variables 
local i = 1
foreach oldvar of local oldnames {
    local newvar : word `i' of `newnames'
    rename `oldvar' `newvar'
    local i = `i' + 1
}
 
rename provcd16 provcd
rename urban16 urban 

*Reverse the coding of sleep_quality (negatively phrased)
gen reversed_sleep_quality = 5 - sleep_quality
// Verify the changes
list sleep_quality reversed_sleep_quality in 1/10
// Rename the variable back to its old name 
drop sleep_quality
rename reversed_sleep_quality sleep_quality 

* Reverse the health_status variable
gen reversed_health_status = 6 - health_status
//Define the new value labels
label define health_label 1 "Poor" 2 "Fair" 3 "Good" 4 "Very good" 5 "Excellent"
//Apply the value labels to the reversed variable
label values reversed_health_status health_label
//Verify the reversed variable and labels
tabulate reversed_health_status, missing
list health_status reversed_health_status in 1/10
//Rename the variable to its old name 
drop health_status
rename reversed_health_status health_status

*** explore descriptives again after cleaning 
summarize,detail 

*Generate year identifier 
gen year = 2016
order pid year 
rename fid16 fid 

********CFPS2014 Individual Data cleaning
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Public Data/ CFPS2014 in STATA (English)/ecfps2014adult_201906.dta", clear
//2014 data is weird a lot of values mising 


*********Variables check 
describe 
codebook, compact 

*Keep relevant variables 
keep pid fid14 fid12 fid10 provcd14 urban14 code_b_1 subsample10 subpopulation10 subsample14 rswt_natcs14 rswt_rescs14 rswt_natpn1014 rswt_respn1014 cfps_birthy cfps2014_age cfps2012_marriage cfps_gender selfrpt interrupt_sf qa603 te4 cfps2014edu cfps2014eduy cfps2014eduy_im employ2014 qp201 qm2012 qn12012 qn12014 qm1016 qm1017 qn1001 qm2011 qg1305 qq1002 qq4010 qq403a 
//the difference between rswt_natcs16 rswt_rescs16 rswt_natpn1016 rswt_respn1016 ? 
//relationship with family members and neighbours (in the survey) can't be found. number of children? 
//it has sleep duration but not sleep quality 


*** explore descriptives
summarize,detail 

*********Missing values 
//variable:  gender, age, years_of_edu, years_of_edu_im, employ, qp201(health_status), qm2012, qn12012, qn12014, , qn1001, qm2011, qg1305, qq1002, qq4010, qq403a
//-10, -9, -8, -2, -1
foreach var of varlist cfps2014_age cfps_gender cfps2014eduy cfps2014eduy_im employ2014 qp201 qm2012 qn12012 qn12014 qn1001 qm2011 qg1305 qq1002 qq4010 qq403a {
	replace `var' = . if inlist(`var', -10, -9, -8, -2, -1)
}

//variable:qa603
// -10,-9,-8,-2,-1, 5
replace qa603 = . if inlist(qa603, -10,-9,-8,-2,-1,5)

//variable: marriage, 
//-10, -9, -8, -2, -1, 0
replace cfps2012_marriage = . if inlist(cfps2012_marriage, -10, -9, -8, -2, -1, 0)

//variable: highest education (te4), highest education degree 2014 (cfps2014edu)
////-10, -9, -8, -2, -1, 0, 9 
replace te4 = . if inlist(te4, -10, -9, -8, -2, -1, 0, 9)
replace cfps2014edu = . if inlist(cfps2014edu, -10, -9, -8, -2, -1, 0, 9)

//variable: qm1016, qm1017
////-10, -9, -8, -2, -1, 6
replace qm1016 = . if inlist(qm1016, -10, -9, -8, -2, -1, 6)
replace qm1017 = . if inlist(qm1017, -10, -9, -8, -2, -1, 6)


*Recode dummies 
recode employ2014 (2 = 0 "Unemployed") (3 = 0 "Unemployed") (1 = 1 "Employed"), gen (employment_status)
recode qn1001 (5 = 0 "Little trust") (1 = 1 "Mostly trust"), gen (trust)
recode cfps_gender (0 = 0 "Female") (5 = 0 "Female") (1 = 1 "Male"), gen (gender)
drop employ2014
drop qn1001

*Combine two variables on highest level of education 
gen highest_edu = cfps2014edu
replace highest_edu = te4 if missing(cfps2014edu)
drop cfps2014edu 
drop te4

*List of old and new variables 
local oldnames "rswt_natcs14 rswt_rescs14 rswt_natpn1014 rswt_respn1014 cfps2014_age cfps2012_marriage  cfps2014eduy cfps2014eduy_im qp201 qm2012 qn12012 qn12014 qm1016 qm1017 qm2011 qg1305 qq1002 qq4010 qq403a " 

local newnames "cross_sec_weight_total cross_sec_weight_rep panel_weight panel_weight_rep age marriage years_edu years_edu_im health_status happiness_xinfu life_satis confidence_future posi_self satisfi_self interper_relation dine_fam sleep_duration bed_time"

*Renaming variables 
local i = 1
foreach oldvar of local oldnames {
    local newvar : word `i' of `newnames'
    rename `oldvar' `newvar'
    local i = `i' + 1
}
 
rename provcd14 provcd
rename urban14 urban 

* Reverse the health_status variable
gen reversed_health_status = 6 - health_status
//Define the new value labels
label define health_label 1 "Poor" 2 "Fair" 3 "Good" 4 "Very good" 5 "Excellent"
//Apply the value labels to the reversed variable
label values reversed_health_status health_label
//Verify the reversed variable and labels
tabulate reversed_health_status, missing
list health_status reversed_health_status in 1/10
//Rename the variable to its old name 
drop health_status
rename reversed_health_status health_status

*** explore descriptives again after cleaning 
summarize,detail 

*Generate year identifier 
gen year = 2014
order pid year 

********CFPS2012 Individual Data cleaning
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Public Data/CFPS2012 in STATA (English)/ecfps2012adult_201906.dta"

*********Variables check 
describe 
codebook, compact 

*Keep relevant variables 
keep pid fid12 fid10 provcd urban12 rswt_natcs12 rswt_rescs12 rswt_natpn1012 rswt_respn1012 genetype cfps2010_gender cfps2012_age cfps2010_marriage nchd1 nchd2 nchd3 edu2012 sw1r sch2012 employ qp201 qq60112 qq60116 qn12012 qn12014 qf1_a_1 qf1_a_2 qf1_a_3 qf1_a_4 qf1_a_5 qf1_a_6 qf1_a_7 qf1_a_8 qf1_a_9 qf1_a_10 qn1001 qq60111 qq403a  
//without sleep duration the IV is missing - 2012 wave should be exluded 


********************************** Merging long individual econ data *********************
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/Individual Data/individual_2018_clean.dta", clear 
append using "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/Individual Data/individual_2020_clean.dta"
tab year 

append using ""/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/Individual Data/individual_2016_clean.dta""


********************跨表合并 
*** 多对一的匹配
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/cfps_id.dta", clear //pid year 1:1 merge 
merge m:1 pid year using "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/Individual Data/Merged_individual.dta", gen (mindividual) update

tab mindividual 

*check conflict values 
 * get the names of variables in the using data set other than the merge kay 
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/Individual Data/Merged_individual.dta", clear 
 
ds pid year, not 			//list variables not speicifed in varlist
local using_vars `r(varlist)'
// ds command - compactly list all variables with specified properties 
 // not command - list variables not in the varlist
 // this will go back to a macro variable r(varlist) - all eligible variables 

 *find common variables in both master and using data 
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/cfps_id.dta", clear 
ds fid year, not //
local master_vars `r(varlist)'
local common: list master_vars & using_vars

* rename the common variables in the master data set 
foreach v of varlist `common' {
	rename `v' `v'_master
	}

* merge again 
merge m:1 pid year using "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/Individual Data/Merged_individual.dta", gen (mindividual) update 











