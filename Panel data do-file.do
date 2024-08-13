*************************Final Merging of the Panel Data ********************
****Handling duplicates - observations with missing pid 
* Load your dataset (long shaped family econ data )
use "/path/to/your/dataset.dta", clear

* List observations with missing pid to investigate
list if missing(pid)

* Drop observations with missing pid
drop if missing(pid)

* Verify no duplicates remain
duplicates report pid year


use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/all_year_fameco_long.dta", clear 

merge m:1 pid year using "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/all_year_individual_long.dta", gen(mmerge) update
tabulate mmerge

 *check conflict values 
 * get the names of variables in the using data set other than the merge kay 
 //nonmissing variable 以master data为主来取值
 

use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/all_year_individual_long.dta", clear 
ds pid year, not 			//list variables not speicifed in varlist
local using_vars `r(varlist)'
// ds command - compactly list all variables with specified properties 
 // not command - list variables not in the varlist
 // this will go back to a macro variable r(varlist) - all eligible variables 

 *find common variables in both master and using data 

use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/all_year_fameco_long.dta", clear 
ds pid year, not //
local master_vars `r(varlist)'
local common: list master_vars & using_vars

* rename the common variables in the master data set 
foreach v of varlist `common' {
	rename `v' `v'_master
	}
	
//variables with _master are those with nonmissing conflicts 
merge m:1 pid year using "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/all_year_individual_long.dta", gen(mmerge) update
tabulate mmerge

*check the conflict values // 含_master的变量
foreach var in birthy gender ethnicity entrayear fidbaseline psu subsample subpopulation deceased death_year death_month inroster indsurvey selfrpt co_a_p tb6_a_p marriage urban_master hk20r employ Ngenetype coremember alive provcd {
		count if `var'!=`var'_master & `var'!=. 
				}
//label value of hk? 

* Save the final merged panel dataset
save "/path/to/final_merged_panel_data.dta", replace

//employ_master employ employment_status 

****Resolving conflicting values
//employment status 
* Generate indicators for mismatches
gen mismatch_employ_master = (employ != employ_master)
gen mismatch_employ_status = (employ != employment_status)
gen mismatch_master_status = (employ_master != employment_status)

* List the mismatches
list pid year employ employ_master employment_status if mismatch_employ_master | mismatch_employ_status | mismatch_master_status

* Create a new variable for resolved employment status
gen resolved_employment_status = employment_status 

* Replace with values from other variables if employ_master is missing
replace resolved_employment_status = employ if missing(employment_status)
replace resolved_employment_status = employ_master if missing(resolved_employment_status)

drop employ_master employ mismatch_employ_master mismatch_employ_status resolved_employment_status
replace employment_status = . if inlist(employment_status, -10, -8, -1)
* Verify the new variable
list pid year employ employ_master employment_status resolved_employment_status if mismatch_employ_master | mismatch_employ_status | mismatch_master_status

//gender
drop gender
rename gender_master gender

//urban 
replace urban = . if inlist(urban, -9)
replace urban_master = . if inlist(urban_master, -9, -8)
* Generate an indicator for mismatches
gen mismatch_urban = (urban != urban_master)
* List the mismatched observations
list pid year urban urban_master if mismatch_urban

* Create a new variable for the combined urban status
gen urban_combined = .

* Use urban_master as the base
replace urban_combined = urban_master

* Use urban when urban_master is missing
replace urban_combined = urban if missing(urban_combined)

* Verify the new variable
list pid year urban urban_master urban_combined if missing(urban) | missing(urban_master)

drop mismatch_urban urban urban_master
rename urban_combined urban

//Education 
* Create a new variable for consolidated highest level of education
gen consolidated_edu = .

* Use the most recent value, assuming cfpsedu_master is the most recent
replace consolidated_edu = cfpsedu_master

* Fill in with other variables if cfpsedu_master is missing
replace consolidated_edu = cfpsedu if missing(consolidated_edu)
replace consolidated_edu = edu2016 if missing(consolidated_edu)
replace consolidated_edu = education if missing(consolidated_edu)

* Verify the new variable
list pid year cfpsedu cfpsedu_master edu2016 education consolidated_edu if missing(cfpsedu_master) | missing(cfpsedu) | missing(edu2016) | missing(education)

* Drop or rename original variables if no longer needed
drop cfpsedu cfpsedu_master edu2016 education 
rename consolidated_edu education 

//years of education
* Create a new variable for consolidated education years
gen consolidated_edu_years = .

* Use the most recent value, assuming cfpseduy_master is the most recent
replace consolidated_edu_years = cfpseduy_master

* Fill in with other variables if cfpseduy_master is missing
replace consolidated_edu_years = cfpseduy if missing(consolidated_edu_years)
replace consolidated_edu_years = cfpseduy_im if missing(consolidated_edu_years)
replace consolidated_edu_years = cfpseduy_im_master if missing(consolidated_edu_years)
replace consolidated_edu_years = edu_yrs if missing(consolidated_edu_years)
replace consolidated_edu_years = edu_yrs_im if missing(consolidated_edu_years)
replace consolidated_edu_years = years_edu2016 if missing(consolidated_edu_years)
replace consolidated_edu_years = years_edu_im2016 if missing(consolidated_edu_years)

* Verify the new variable
list pid year cfpseduy cfpseduy_master cfpseduy_im cfpseduy_im_master edu_yrs edu_yrs_im years_edu2016 years_edu_im2016 consolidated_edu_years if missing(cfpseduy_master) | missing(cfpseduy) | missing(cfpseduy_im) | missing(cfpseduy_im_master) | missing(edu_yrs) | missing(edu_yrs_im) | missing(years_edu2016) | missing(years_edu_im2016)

* Drop or rename original variables if no longer needed
drop cfpseduy cfpseduy_master cfpseduy_im cfpseduy_im_master edu_yrs edu_yrs_im years_edu2016 years_edu_im2016
rename consolidated_edu_years edu_yrs
replace edu_yrs = . if inlist(edu_yrs, -9, -8)

use"/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/panel_data_final.dta", clear 

//marriage 
* Create a new variable for consolidated marriage status
gen consolidated_marriage = .

* Use the most recent value, assuming marriage_master is the most recent
replace consolidated_marriage = marriage_master

* Fill in with other variables if marriage_master is missing
replace consolidated_marriage = marriage_last_update if missing(consolidated_marriage)
replace consolidated_marriage = marriage_last if missing(consolidated_marriage)
replace consolidated_marriage = marriage if missing(consolidated_marriage)
replace consolidated_marriage = cfps2014_marriage if missing(consolidated_marriage)

* Verify the new variable
list pid year cfps2014_marriage marriage marriage_last marriage_last_update marriage_master consolidated_marriage if missing(consolidated_marriage)

* Drop or rename original variables if no longer needed
drop cfps2014_marriage marriage marriage_last marriage_last_update marriage_master
rename consolidated_marriage marriage 
replace marriage = . if inlist(marriage, -8, -2, -1)

recode marriage (1 = 0 "Not Married") (2 = 1 "Married") (3 = 0 "Not Married") (4 = 0 "Not Married") (5 = 0 "Not Married"), gen(marriage_status)
drop marriage 
rename marriage_status marriage 
//father/mother relationship 
***** missing values - father/mother relationship 
* Check non-missing values for the variables
summarize father_relation relation_father mother_relation relation_mother

* Combine values for father_relation
gen father_relation_combined = father_relation
replace father_relation_combined = relation_father if missing(father_relation)

* Combine values for mother_relation
gen mother_relation_combined = mother_relation
replace mother_relation_combined = relation_mother if missing(mother_relation)

* Replace the original variables with the combined variables
replace father_relation = father_relation_combined
replace mother_relation = mother_relation_combined

* Drop the redundant variables and the temporary combined variables
drop relation_father relation_mother father_relation_combined mother_relation_combined

* Verify the changes
summarize father_relation mother_relation

*missing value 
replace father_relation = . if inlist(father_relation, -9, -8, -2, -1, 7)
replace mother_relation = . if inlist(mother_relation, -9, -8, -2, -1, 7)
replace property_ownership = . if property_ownership == 77

save "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/panel_data_final.dta", replace 

***Preparing data for the analysis 
* Create the new variable hh_id - hgousehold head id that the project is mainly interested in 

//household head
***********Household head treatment - this is optional depending on the analysis 
* Step 4: Create a variable to identify household heads
gen is_head = (resp1pid == pid)

* Step 5: Filter to keep only household heads
keep if is_head == 1
drop is_head
****************May not be necessary because of how small the sample is afterwards



