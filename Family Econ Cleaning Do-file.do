****** Dissertation Data Cleaning*********
* Topic: the reversed relationship betweent happiness and hedonic consumption in China
* Dataset: CFPS 2010,2012, 2014, 2016, 2018
*******

*** set file path 
global root = "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science"
global rawdata = "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Public Data/"
global data = "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/"
global logfiles = "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Log"

*****************************Family Data Cleaning**********************
********CFPS2020 Family Data cleaning 
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Public Data/[CFPS2020_in_STATA_(Chinese)/cfps2020famecon_202306.dta", clear
*********Variables check 
describe 
codebook, compact

//Keep relevant variables 
keep fid20 provcd20 countyid20 cid20 urban20 resp1pid ft200 ft201 ft202 fincome1 fincome1_per fincome1_per_p fp514 familysize20 fr1 fr101 fq2 

*** explore descriptives
summarize,detail 

*********Missing values 
//variable: whether hold financial product
tab ft200
label list ft200 
**** missing values are coded as -10,-9,-8,-2,-1,79
//variable: family income (annual), fr1 
tab fincome1 fincome1_per fincome1_per_p
label list fincome1 
****missing values: -10,-9,-8,-2,-1

//variable: family risky investment 
label list ft201 fp514 fr101 fq2
***missing values: -10,-9,-8,-2,-1

***** process missing values
* Replace specified values with missing values
replace ft200=. if ft200==79 
foreach var of varlist ft200 ft201 ft202 fincome1 fincome1_per fincome1_per_p fp514 fr101 fq2 {
    replace `var' = . if inlist(`var', -10, -9, -8, -2, -1)
}

replace fr1 = . if inlist(fr1, -10,-9,-8,-2,-1,79)

*Recode dummies
recode ft200 (1 = 1 "Yes") (5 = 0 "No"), gen (hold_fin_product)
drop ft200 

recode fr1(5 = 0 "No") (1 = 1 "Yes"), gen (other_property)
drop fr1 

recode fq2 (1 = 1 "Yes") (2 = 0 "No") (3 = 0 "No") (4 = 0 "No") (5 = 0 "No") (6 = 0 "No") (7 = 0 "No") (8 = 0 "No"), gen (property_ownership) 
drop fq2


* List of old and new variable names
local oldnames "ft201 ft202 fp514 fr101"
local newnames "value_fin_product invetsment_return insurance num_of_property"

* Renaming variables
local i = 1
foreach oldvar of local oldnames {
    local newvar : word `i' of `newnames'
    rename `oldvar' `newvar'
    local i = `i' + 1
}

*Merge and keep the only identifiers for merging dataset
rename fid20 fid

///Rename variables for merging - drop year suffix
* Iterating over each variable
foreach var of varlist provcd20 countyid20 cid20 urban20 familysize20 {
    * Create a new variable name by removing the last two characters
    local newvar = substr("`var'", 1, length("`var'") - 2)
    
    * Display the old and new variable names for verification
    display "`var' -> `newvar'"
    
    * Rename the variable
    rename `var' `newvar'
}

* This also makes it easier in case of the addition and removal of variable 
//generare year identifier 
gen year = 2020
order fid year 
summarize, detail 


********CFPS2018 Family Data cleaning
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Public Data/ecfps2018famecon_202101.dta", clear

*********Variables check 
describe 
codebook, compact

//Keep relevant variables 
keep fid18 provcd18 countyid18 cid18 urban18 resp1pid ft200 ft201 ft202 fincome1 fincome1_per fincome1_per_p fp514 familysize18 fr1 fr101 fq2 
//new control variables added: onweship of other properties and ownership of the house they live in 

*** explore descriptives
summarize,detail 

*********Missing values 
//variable: whether hold financial product
tab ft200
label list ft200 
**** missing values are coded as -10,-9,-8,-2,-1,79
//variable: family income (annual), fr1 
tab fincome1 fincome1_per fincome1_per_p
label list fincome1 
****missing values: -10,-9,-8,-2,-1

//variable: family risky investment 
label list ft201 fp514 fr101 fq2
***missing values: -10,-9,-8,-2,-1

***** process missing values
* Replace specified values with missing values
replace ft200=. if ft200==79 
foreach var of varlist ft200 ft201 ft202 fincome1 fincome1_per fincome1_per_p fp514 fr101 fq2 {
    replace `var' = . if inlist(`var', -10, -9, -8, -2, -1)
}

replace fr1 = . if inlist(fr1, -10,-9,-8,-2,-1,79)

*Recode dummies
recode ft200 (1 = 1 "Yes") (5 = 0 "No"), gen (hold_fin_product)
drop ft200 

recode fr1(5 = 0 "No") (1 = 1 "Yes"), gen (other_property)
drop fr1 

recode fq2 (1 = 1 "Yes") (2 = 0 "No") (3 = 0 "No") (4 = 0 "No") (5 = 0 "No") (6 = 0 "No") (7 = 0 "No") (8 = 0 "No"), gen (property_ownership) 
drop fq2


* List of old and new variable names
local oldnames "ft201 ft202 fp514 fr101"
local newnames "value_fin_product invetsment_return insurance num_of_property"

* Renaming variables
local i = 1
foreach oldvar of local oldnames {
    local newvar : word `i' of `newnames'
    rename `oldvar' `newvar'
    local i = `i' + 1
}

*Merge and keep the only identifiers for merging dataset
rename fid18 fid

///Rename variables for merging - drop year suffix
* Iterating over each variable
foreach var of varlist provcd18 countyid18 cid18 urban18 familysize18 {
    * Create a new variable name by removing the last two characters
    local newvar = substr("`var'", 1, length("`var'") - 2)
    
    * Display the old and new variable names for verification
    display "`var' -> `newvar'"
    
    * Rename the variable
    rename `var' `newvar'
}

* This also makes it easier in case of the addition and removal of variable 
//generare year identifier 
gen year = 2018
order fid year 
summarize, detail 

save '$data/family_2018.dta', replace

********CFPS2016 Family Data cleaning
use " /Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Public Data/CFPS2016 in STATA (English)/ecfps2016famecon_201807.dta", clear

local yr = 16

keep fid16 provcd16 countyid16 cid16 urban16 resp1pid ft200 ft201 ft202 fincome1 fincome1_per fincome1_per_p fp514 familysize16 fr1 fr101 fq2 


*Missing values
describe, varlist
local varlist "ft200 ft201 ft202 fp514 fincome1 fincome1_per fincome1_per_p familysize16 fr101 fq2"
display "varlist"
foreach var of local varlist {
	replace `var' =. if inlist(`var', -10, -9, -8, -2, -1)
}
replace ft200=. if ft200==79 

replace fr1 = . if inlist(fr1, -10,-9,-8,-2,-1,79) 


*recode dummies
recode ft200 (1 = 1 "Yes") (5 = 0 "No"), gen (hold_fin_product)
drop ft200

recode fr1(5 = 0 "No") (1 = 1 "Yes"), gen (other_property)
drop fr1 

recode fq2 (1 = 1 "Yes") (2 = 0 "No") (3 = 0 "No") (4 = 0 "No") (5 = 0 "No") (6 = 0 "No") (7 = 0 "No") (8 = 0 "No"), gen (property_ownership) 
drop fq2


*List of old and new variable names
local oldnames "ft201 ft202 fp514 fr101"
local newnames "value_fin_product investment_return insurance num_of_property"

* Renaming variables
local i = 1
foreach oldvar of local oldnames {
    local newvar : word `i' of `newnames'
    rename `oldvar' `newvar'
    local i = `i' + 1
}

*Merge and keep the only identifiers for merging dataset
rename fid16 fid

///Rename variables for merging - drop year suffix
* Iterating over each variable
foreach var of varlist provcd16 countyid16 cid16 urban16 familysize16 {
    * Create a new variable name by removing the last two characters
    local newvar = substr("`var'", 1, length("`var'") - 2)
    
    * Display the old and new variable names for verification
    display "`var' -> `newvar'"
    
    * Rename the variable
    rename `var' `newvar'
}

****review of data 
summarize, detail 

//generare year identifier 
gen year = 2016
order fid year 


***************CFPS2014 Family Data cleaning
local yr = 14

keep fid`yr' provcd`yr' countyid`yr' cid`yr' urban`yr' fresp1pid fincome1 fincome1_per fincome1_per_p ft2_s_1 ft2_s_2 ft2_s_3 ft2_s_4 ft2_s_5 ft201 ft202 fp514 familysize
*** fresp1pid - Respondent of family's economic consitions section - this is different from the 2018&2016 wave
* ft201 - total value of financial product 

*Missing Value
//double check value labels for all variables 
describe, varlist
local varlist " fincome1 fincome1_per fincome1_per_p ft2_s_1 ft2_s_2 ft2_s_3 ft2_s_4 ft2_s_5 ft201 ft202 fp514 familysize"
display "varlist"

label list ft2_s_1 ft2_s_2 ft2_s_3 ft2_s_4 ft2_s_5
/// -1, -2, -8-, -9, -10, 78 are all missing values 
foreach var of local varlist {
    replace `var' = . if inlist(`var', -10, -9, -8, -2, -1)
}
replace ft2_s_1 = . if ft2_s_1 == 78
replace ft2_s_2 = . if ft2_s_2 == 78
replace ft2_s_3 = . if ft2_s_3 == 78
replace ft2_s_4 = . if ft2_s_4 == 78
replace ft2_s_5 = . if ft2_s_5 == 78
***** Create dummy variable
* Initialize the dummy variable to 0
gen hold_fin_product = 0

* Set the dummy variable to 1 if any of the ft2_s_* variables indicate holding a risky financial product
replace hold_fin_product = 1 if inlist(ft2_s_1, 1, 3, 5, 6, 7, 77)
replace hold_fin_product = 1 if inlist(ft2_s_2, 1, 3, 5, 6, 7, 77)
replace hold_fin_product = 1 if inlist(ft2_s_3, 1, 3, 5, 6, 7, 77)
replace hold_fin_product = 1 if inlist(ft2_s_4, 1, 3, 5, 6, 7, 77)
replace hold_fin_product = 1 if inlist(ft2_s_5, 1, 3, 5, 6, 7, 77)

* Verify the results
tab hold_fin_product

*List of old and new variable names
local oldnames "ft201 ft202 fp514"
local newnames "value_fin_product investment_return insurance"

* Renaming variables
local i = 1
foreach oldvar of local oldnames {
    local newvar : word `i' of `newnames'
    rename `oldvar' `newvar'
    local i = `i' + 1
}

*Merge and keep the only identifiers for merging dataset
rename fid14 fid

///Rename variables for merging - drop year suffix
foreach var of varlist provcd14 countyid14 cid14 urban14 {
* Create a new variable name by removing the last two characters
local newvar = substr("`var'", 1, length("`var'") - 2)
    
* Display the old and new variable names for verification
display "`var' -> `newvar'"
    
* Rename the variable
rename `var' `newvar'
}

//generare year identifier 
gen year = 2014
order fid year 

*****CFPS2012 Family Data cleaning
//This dataset is very different from the others because some of the questions in the fp section is asking about monthly expenditure - variables need to be recomputed
local yr = 12

keep fid`yr' provcd countyid cid urban`yr' fresp1 fincome1 fincome1_per ft3 ft301 ft301est ft4 ft401 ft401est ft5 ft501 ft501est ft6 ft601 ft7 ft701 fp515 fp516 familysize
*fresp1 = respondent respid1
*fp515+fp516 = commercial insurance
*taotal value = ft301/ft301est + ft401/ft401est + ft501/ft501est + ft601 + ft701 

********Missing values
label list ft3 ft4 ft5 ft6 ft7 
/// -10, -9, -8, -2, 79 are all missing 
/// but do not treat -1 as missing value because there is the estimated value for them 
describe, varlist
local varlist "fincome1 fincome1_per ft3 ft301 ft301est ft4 ft401 ft401est ft5 ft501 ft501est ft6 ft601 ft7 ft701 fp515 fp516 familysize"

display "varlist" 
foreach var of local varlist {
    replace `var' = . if inlist(`var', -10, -9, -8, -2)
}

replace ft3 =. if ft3 == 79
replace ft4 =. if ft4 == 79
replace ft5 =. if ft5 == 79
replace ft6 =. if ft6 == 79
replace ft7 =. if ft7 == 79

******Recode varaibles and gerate the 
* Initialize the sum variable using the actual values
gen total_fin_product = ft301 + ft401 + ft501 + ft601 + ft701
* Replace ft301 with est_ft301 for unsure respondents
replace ft301 = ft301est if ft301 == -1
* Replace ft401 with est_ft401 for unsure respondents
replace ft401 = ft401est if ft401 == -1
* Replace ft501 with est_ft501 for unsure respondents
replace ft501 = ft501est if ft501 == -1

* Recalculate the sum using the updated values
replace total_fin_product = ft301 + ft401 + ft501 + ft601 + ft701

gen insurance = fp515+fp516
drop fp515 fp516

* Renaming variables
local i = 1
foreach oldvar of local oldnames {
    local newvar : word `i' of `newnames'
    rename `oldvar' `newvar'
    local i = `i' + 1
}

*Merge and keep the only identifiers for merging dataset
rename fid12 fid

///Rename variables for merging - drop year suffix
* Iterating over each variable
foreach var of varlist provcd16 countyid16 cid16 urban16 familysize16 {
    * Create a new variable name by removing the last two characters
    local newvar = substr("`var'", 1, length("`var'") - 2)
    
    * Display the old and new variable names for verification
    display "`var' -> `newvar'"
    
    * Rename the variable
    rename `var' `newvar'
}
/////// OR
rename urban12 urban 

//generare year identifier 
gen year = 2012
order fid year 

***************CFPS2010 Family Data cleaning
//not necessary as this is the baseline survey 
local yr = 10
//keep relevant variables 
keep fid provcd countyid cid urban tb7 faminc faminc_net indinc indinc_net familysize ff3_s_1 ff3_s_2 ff3_s_3 ff301_a_1 ff301_a_2 ff302_a_1 ff302_a_2 fh409
*faminc - adjusted total family income
*faminc_net - adjusted net family income
*indinc - adjusted total family income per capita
*indinc_net - adjusted net family income per capita
*fh409 - commercial insurance 
*tb7 

*** fresp1pid - Respondent of family's economic consitions section - this is different from the 2018&2016 wave
* ft201 - total value of financial product 


***Merge variables and create dummy for the first dependent variable of whether households hold financial products 
* Step 1: Initialize the binary variable to 0
gen hold_fin_product = 0

* Step 2: Update the binary variable to 1 if any of the variables indicate holding a financial product
replace hold_fin_product = 1 if inlist(ff3_s_1, 1, 3, 5)
replace hold_fin_product = 1 if inlist(ff3_s_2, 1, 3, 5)
replace hold_fin_product = 1 if inlist(ff3_s_3, 5)

* Verify the results
tab hold_fin_product

*Missing Value
//double check value labels for all variables 
describe, varlist
local varlist " ff301_a_1 ff301_a_2 fh409 faminc faminc_net indinc indinc_net familysize"
display "varlist"

foreach var of local varlist {
    replace `var' = . if inlist(`var', -10, -9, -8, -2, -1)
}

* Generate variable for the total value of financial products 
gen total_fin_product = ff301_a_1 + ff301_a_2
gen investment_return = ff302_a_1 + ff302_a_2
* Renaming variables
rename fh409 insurance


*Merge and keep the only identifiers for merging dataset
///Rename variables for merging - drop year suffix
//generare year identifier 
gen year = 2010
order fid year

********************************** Merging wide family econ data *********************
//Merging 2020 and 2018 data
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/Family Econ Data/famecon_2018_clean .dta", clear 
append using "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/Family Econ Data/famecon_2020_clean.dta"
tab year

append using "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/Family Econ Data/famecon_2016_clean.dta"
tab year

                                      
//Merging 2018 and 2016 data
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/Family Econ Data/famecon_2018_clean .dta", clear 
append using "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/2016 clean.dta"
tab year

//Merging 2014 data 
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/2018&16.dta"
append using "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/2014 clean.dta"
tab year 


//Merging 2012 data
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/2018&16.dta"
append using "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/2012 clean.dta"
tab year 

//Merging 2010 data 
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/2018&16.dta"
append using "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/2010 clean.dta"
tab year 
//Merging all the data 2018, 2016, 2014, 2012,2010 
//the end of merging family data 


************************************ Merging Data Using Cross Year Dataset************************ 
****** use the cross year data利用个人核心变量进行跨表匹配/Merging family and individual data****** 
**use the identifier to create a panel identifier: pid year 
******2020 the latest 
//use pid year to merge 
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Public Data/[CFPS2020_in_STATA_(Chinese)/cfps2020crossyearid_202312.dta", clear 
*1. reshape 
*prepare variable names for reshape 
rename (co_a*_p tb6_a*_p cfps20*edu cfps20*sch cfps20*eduy cfps20*eduy_im genetype*r) (co_a_p* tb6_a_p* cfpsedu* cfpssch* cfpseduy* cfpseduy_im* genetyper*)

* Prepare variable labels before reshape
unab varlist: *20 // Unabbreviate variable list
display "`varlist'"
local varlist: subinstr local varlist "20" "", all
display "'varlist'"

foreach v of local varlist {
    local var `v'20
//  display "`v'18"
    * Get the variable label
    local `v'label: variable label `var'

    * Remove unwanted substrings from the variable label
    local `v'label: subinstr local  `v'label "2020" ""
    local `v'label: subinstr local  `v'label "20" ""
    local `v'label: subinstr local  `v'label "(" ""
    local `v'label: subinstr local  `v'label ")" ""
//  local `v'label = trim (" ``v'label' ")
	display "``v'label'"
}

*Reshape long: unique identifier: id and year 
local pvariable fid inroster indsurvey selfrpt co_a_p tb6_a_p marriage_ cfpsedu cfpssch cfpseduy cfpseduy_im urban hk employ genetyper genetype coremember alive
reshape long `pvariable' , i(pid) j(year)

*label variables 
foreach var of local pvariable {
	label variable `var' "``var'label'"
}

replace year = 2000 + year 

rename marriage_ marriage 


***** 2018版本
//use pid year to merge 
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Public Data/2018stata数据/ecfps2018crossyearid_202104.dta", clear

*1. reshape 
*prepare variable names for reshape 
rename (co_a*_p tb6_a*_p cfps20*edu cfps20*sch cfps20*eduy cfps20*eduy_im genetype*r) (co_a_p* tb6_a_p* cfpsedu* cfpssch* cfpseduy* cfpseduy_im* genetyper*)

* Prepare variable labels before reshape
unab varlist: *18 // Unabbreviate variable list
display "`varlist'"
local varlist: subinstr local varlist "18" "", all
display "'varlist'"

foreach v of local varlist {
    local var `v'18
//  display "`v'18"
    * Get the variable label
    local `v'label: variable label `var'

    * Remove unwanted substrings from the variable label
    local `v'label: subinstr local  `v'label "2018" ""
    local `v'label: subinstr local  `v'label "18" ""
    local `v'label: subinstr local  `v'label "(" ""
    local `v'label: subinstr local  `v'label ")" ""
//  local `v'label = trim (" ``v'label' ")
	display "``v'label'"
}


*Reshape long: unique identifier: id and year 
local pvariable fid inroster indsurvey selfrpt co_a_p tb6_a_p marriage_ cfpsedu cfpssch cfpseduy cfpseduy_im urban hk employ genetyper genetype coremember alive
reshape long `pvariable' , i(pid) j(year)

*label variables 
foreach var of local pvariable {
	label variable `var' "``var'label'"
}

replace year = 2000 + year 

rename marriage_ marriage 

* 2. 变量构造variable composition: e.g. genetype
*2012 - 2018 genetype, 2012 genetyper， these two variables are the same thing but with different names. Therefore we need to generate a new variable to merge the two together 
order genetyper, after (genetype)
clonevar Ngenetype = genetype
order Ngenetype , before (genetype)
replace Ngenetype = genetyper if year==2012
recode Ngenetype (-10/-1 = .) (1/7 = 1) if year==2012 
recode Ngenetype (-8/-1 = .) (1/7 = 1) (8 = .) if year!=2012
label define Ngenetype 1 "Gene Member" 0 "Non-Gene Member", modify 
label values Ngenetype Ngenetype
*Ngenetype = new genetype variable
// for continuous variables - calculate lns/root square

*3. 变量核查
*同类变量相互验证
tab cfpsedu cfpssch

*check for missing values
egen miss = rowmiss (marriage cfpsedu hk employ)
tab miss
drop miss

egen miss = rowmiss (gender ethnicity selfrpt urban )
tab miss 
drop miss 

** //it's the most common to have 1 missing value - maybe go back and see if there is one specific variable with a lot of missing values, and what do we do to deal with it (e.g. replace)

* keep relevant variables 
drop genetype genetyper
drop releaseversion 

sort pid year 
label data "official_Jan.2020"
save "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/cfps_id.dta", replace
**this data is for the unique identifier of all the samples for the CFPS dataset - so it's very important 

*4. 跨表合并 
*** 多对一的匹配
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/cfps_id.dta", clear //pid year 1:1 merge 
merge m:1 fid year using "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/Family Econ Data/Merged_FamEcon.dta", gen (mfamecon) update

tab mfamecon


** generate mfamecon data is to save time for getting rid of the _merge variable that stata automatically generates everytime you merge the data
//data/cfps_id.dta"是整个数据的master data
//one thing we need to think about is whether to update/fill in the missing data in the master dataset using the using data. 

//not missing updated means that original data and the master data have the same variable names but there are missing values in the master data not the using data, then it is automatically replaced by the using dataset 
//non-missing conflict: same variable names but with different values - this is what we need to concern ourselves with and double check 
//the update command is to show all the merging details 

*one way to go about the non-missing conflict is to change the variable names in the two dataset to keep all the values and data point which allows further examination 

 *next step: extract the same label and variable names 
 
 //list variables with the same properties - 
 
 *check conflict values 
 * get the names of variables in the using data set other than the merge kay 
use "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/Family Econ Data/Merged_FamEcon.dta", clear 
 
ds fid year, not 			//list variables not speicifed in varlist
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
merge m:1 fid year using "/Users/yixichen/Library/CloudStorage/OneDrive-Personal/Documents/MSc Behavioural Science/MSc Dissertation/Data/Clean Data/Family Econ Data/Merged_FamEcon.dta", gen (mfamecon) update

****fixing errors 
* Check non-missing values for both variables
summarize invetsment_return investment_return

* Combine values into a new variable
gen combined_investment_return = investment_return
replace combined_investment_return = invetsment_return if missing(investment_return)

* Replace the original variable with the combined variable
replace investment_return = combined_investment_return

* Drop the incorrectly named variable and the temporary combined variable
drop invetsment_return combined_investment_return

* Verify the changes
summarize investment_return

*Check conflict 
foreach var in urban  {
		count if `var'!=`var'_master & `var'!=. 
				}
//using data 里的数据更科学还是master更科学
* Use the most recent value for the urban variable
replace urban = urban_master if !missing(urban_master)
drop urban_master 
tab urban 
replace urban = . if inlist(urban, -9, -8)
// urban is a dummy variable (0= rurual) (1 = urban)
//the use of latest urban hk - the most simple and no need to track changes overtime 

	** other notes 
	// we use subsample = 1 for national-level data analysis, because this is a dummy variable where 1 is "yes" and 0 means "no"
	

	


