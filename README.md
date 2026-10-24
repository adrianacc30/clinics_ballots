# Voter turnout, family planning, and women's labour force participation

A descriptive Stata exercise combining state-level measures of voter turnout, publicly funded contraceptive services, and women's labour force participation. Figure labels refer to 2016. The original Excel workbooks are needed to verify the underlying years, variable definitions, and sample.

The project demonstrates spreadsheet imports, data cleaning, state-level merges, variable construction, and scatterplots with Pearson correlations. The associations are descriptive and do not establish causation.

## Contents

- `political.do`: analysis code using relative paths.
- `figures/`: the three original scatterplots supplied with the project.
- `data/README.md`: required input filenames and source notes. The input workbooks are not included.

## Figures

| Variables compared | Correlation printed in the original figure |
| --- | ---: |
| Voter turnout and the share of contraceptive-service need met by publicly funded centers | 0.27 |
| Voter turnout and women's labour force participation | 0.53 |
| Women's labour force participation and the share of contraceptive-service need met | 0.11 |

These figures were copied from the original project, not regenerated or independently reproduced during preparation of this public copy.

![Voter turnout and contraceptive-service needs met](figures/turnout_needs_1.png)

![Voter turnout and women's labour force participation](figures/turnout_womens_2.png)

![Women's labour force participation and contraceptive-service needs met](figures/womens_needs_3.png)

## Run the analysis

1. Install Stata. The original Stata version was not recorded.
2. Place the four original Excel input files listed in `data/README.md` in `data/`.
3. Set Stata's working directory to this repository's root folder, then run `do political.do`.

The script creates temporary intermediate datasets and writes the three PNG files to `figures/`. Rerunning it replaces the figures with new outputs.

Without the input workbooks, this repository is a code-and-results showcase, not a complete reproduction package. The script has not been rerun against the original data during preparation of this copy.

## Data sources

- Guttmacher Institute: state-level contraceptive-service and demographic indicators. The original exports came from `data.guttmacher.org/states`. The [Data Center update](https://www.guttmacher.org/data-center) explains that the old portal was retired in July 2025. A generic current link is not an exact replacement for the original exports.
- U.S. Census Bureau: [Voting and Registration in the Election of November 2016](https://www.census.gov/data/tables/time-series/demo/voting-and-registration/p20-580.html), Table 4a, Reported Voting and Registration, for States. This corrects the broken source link in the original do-file. The original workbook itself is still needed to verify that the imported columns match the intended definitions.
- U.S. Census Bureau: [2016 ACS one-year subject table S2301, Employment Status](https://data.census.gov/table/ACSST1Y2016.S2301). The input filename indicates 2016; the original do-file's source comment instead linked to the 2023 table. Verify the workbook year and precise female population/age group before final interpretation.

## Measurement and checks still needed

- Turnout is calculated as reported voters divided by the imported citizen-population column, multiplied by 100. Verify the column headings and age universe in `table04a.xlsx`.
- The contraceptive-service indicator is the share of need likely met by publicly funded centers, as labeled in the original export. It is not the same as the clinic count or clinics per 10,000 women. The code computes the latter but does not use it in these plots.
- The female participation series is selected by spreadsheet column and within-state row number. Check the original column/row labels, its age group, and its year. The figure label should state the age group once confirmed.
- Cleaning uses row-position deletions, such as `drop in 41/42`, so it depends on the original spreadsheet layout.
- Merges are not followed by explicit matching checks or assertions. Inspect match results and the number of usable observations for each plot before interpreting results.
- Several conversions use `destring, force`, which can turn unexpected text into missing values. Inspect which entries are affected.
- The third original figure has a partly clipped vertical axis label. Re-export it with a shorter axis title when the original data and Stata are available.

## Preparation of this public copy

Personal Windows paths were replaced with relative paths. Intermediate datasets now use Stata temporary files, figure exports go to `figures/`, and source comments were corrected or annotated. Statistical calculations and original row-selection rules were retained. The raw data and full analysis have not been independently validated.
