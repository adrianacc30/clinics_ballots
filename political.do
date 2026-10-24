* Voter turnout, family planning, and women's labour force participation
* Descriptive analysis across U.S. states; figure labels refer to 2016.
* Run from the repository root, with the four original Excel files in data/.
* This public copy removes personal paths and changes storage locations only;
* original calculations, sample-selection rules, and chart commands are retained.
* Read README.md for data requirements and checks still needed.

capture mkdir "figures"
tempfile contraception clinics turnout

clear

import excel "data/GuttmacherDataCenter_contraception.xlsx", firstrow

keep USState NoofTitleXfundedcenters2 oflikelyneedmetbypublicly

label variable oflikelyneedmetbypublicly "% of Needs Likely Met by Publicly Funded Centers in 2016"

save "`contraception'", replace

clear

* Original data source: https://data.guttmacher.org/states
* This portal was retired in July 2025; see README.md for source notes.

import excel "data/GuttmacherDataCenter_demographics.xlsx", firstrow

merge 1:1 USState using "`contraception'"

drop in 1
drop in 41/42
drop in 52/53

destring NoofTitleXfundedcenters2, replace force
destring Totalnoofwomenaged15442, replace ignore(",")
destring oflikelyneedmetbypublicly, replace force

generate clinicsper10kwomen = .
replace clinicsper10kwomen = (NoofTitleXfundedcenters2/Totalnoofwomenaged15442)*10000

replace USState = upper(USState)

save "`clinics'", replace

*data comes from https://www.census.gov/data/tables/time-series/demo/voting-and-registration/p20-580.html

import excel "data/table04a.xlsx", clear

rename I total_voted
rename C total_citizen_population
rename A USState

destring total_voted, replace force
destring total_citizen_population, replace force

drop in 1/5
drop in 53/56

generate state_turnout = .
label variable state_turnout "Voter Turnout for the 2016 Election in %"
replace state_turnout = (total_voted/total_citizen_population)*100

save "`turnout'", replace

merge 1:1 USState using "`clinics'", generate(_merge2)

correlate state_turnout oflikelyneedmetbypublicly
local r_1 = r(rho)

scatter state_turnout oflikelyneedmetbypublicly ///
    , note("Correlation = `=string(`r_1',"%4.2f")'")

graph export "figures/turnout_needs_1.png", replace

* ACS source: https://data.census.gov/table/ACSST1Y2016.S2301
* The input filename indicates 2016; verify its year and the age group of
* the female participation series against the original workbook.

import excel "data/ACSST1Y2016.S2301-2025-06-25T221018.xlsx", sheet(Data) clear

rename AA womenslbfpc
rename A USState

order USState womenslbfpc

drop in 1/5
drop if USState == "Total"
drop if USState == "Labor Force Participation Rate"
drop if USState == "Employment/Population Ratio"
drop if USState == "Margin of Error"

gen state_clean = ""
replace state_clean = USState if USState != "Estimate" & USState != ""
replace state_clean = state_clean[_n-1] if state_clean == ""
gen row_in_block = _n
by state_clean (row_in_block), sort: gen within_state_row = _n
keep if within_state_row == 3
gen womens_lfp_numeric = real(subinstr(womenslbfpc, "%", "", .))
label variable womens_lfp_numeric "Women's Labour Force Participation Rate in % in 2016"
drop USState
rename state_clean USState

replace USState = upper(USState)
keep USState womens_lfp_numeric

merge 1:1 USState using "`turnout'"

correlate state_turnout womens_lfp_numeric
local r_2 = r(rho)

scatter state_turnout womens_lfp_numeric ///
    , note("Correlation = `=string(`r_2',"%4.2f")'")

graph export "figures/turnout_womens_2.png", replace

merge 1:1 USState using "`clinics'", generate(_merge3)

correlate womens_lfp_numeric oflikelyneedmetbypublicly
local r_3 = r(rho)

scatter womens_lfp_numeric oflikelyneedmetbypublicly ///
    , note("Correlation = `=string(`r_3',"%4.2f")'")

graph export "figures/womens_needs_3.png", replace
