

# HPM 881

## Lecture 5 Lab: Interpretation of OLS

### Data Preparation
- **Read in the following variables** from the 2018 Full Year Consolidated File (HC-209): 
  - `DVTEXP18`: Dental care expenditures for 2018
  - `RACEV1X`: Race categories
  - `AGELAST`: Age last birthday
  - `EDUCYR`: Years of education
  - `SEX`: Gender
  - `INSCOV`: Insurance coverage type
  - `RTHLTH53`: Self-reported physical health (Likert scale)

- **Data Cleaning**:
  - Drop observations with <=0 years of education
  - Drop observations with missing/invalid responses to `RTHLTH53`

- **Descriptive Statistics**: Describe the variables of interest.

### Objective
- **Racial Disparities**: Summarize dental expenditures by race categories in `RACEV1X`.

### Visualizations
- **Bar Graph**: Create a bar graph showing the ratio of mean dental expenditures for each race category in `RACEV1X` relative to White.

### Statistical Analysis
- **Unadjusted Means Approach**: Using t-tests, test for differences in mean dental expenditures between each race category in `RACEV1X` and White. Interpret any statistically significant differences.
- **Residual Direct Effect**: Regression `DVTEXP18` on `RACEV1X`, `AGELAST`, `EDUCYR`, `SEX`, `INSCOV`, and `RTHLTH53`. Interpret any statistically significant differences.

### IOM Approach
- **Variables for Clinical Appropriateness and Need**: Suggest variables for inclusion.
- **Variables for Operation of Health Care Systems**: Suggest variables for inclusion.

### Predictions
- **Predicted Expenditures**: Generate predicted dental expenditures for the average White person and for other racial categories.

### Comparison
- **IOM vs Residual Direct Effect**: Compare differences in predictions. Identify which approach generates larger disparities and for which racial groups.


# How to Code in GitHub?

## Dev Containers in GitHub Codepaces

If you have access to GitHub CodeSpaces, click the green "<> Code" button at the top right on this repository page, and then select "Create codespace on main". (GitHub CodeSpaces is available with [GitHub Enterprise](https://github.com/enterprise) and [GitHub Education](https://education.github.com/).)

## To open RStudio Server, click the Forwarded Ports "Radio" icon at the bottom of the VS Code Online window.

![Forwarded Ports](img/forwarded_ports.png)

In the Ports tab, click the Open in Browser "World" icon that appears when you hover in the "Local Address" column for the Rstudio row.

![Ports](img/ports.png)

This will launch RStudio Server in a new window. Log in with the username and password `rstudio/rstudio`. 

* NOTE: Sometimes, the RStudio window may fail to open with a timeout error. If this happens, try again, or restart the Codepace.

In RStudio, use the File menu to open the `/workspaces`, folder and then browse to open the file `devcontainers-rstudio` / `explore-analyze-data-with-R` / `solution` /  `all-systems-check` / `test.Rmd`. Use the "Knit" submenu to "Knit as HTML" and view the rendered "R Notebook" Markdown document.

* Note: You may be prompted to install an updated version of the `markdown` package. Select "Yes".
