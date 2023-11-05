
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
