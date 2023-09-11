# ICES Course

This repository contains model files and associated material for the 2023 ICES course on Stock Synthesis held in Copenhagen, Denmark. 

The preferred method of working with this repository is to clone or download it to your personal machine. To clone the repository, go to the <> Code button, Local tab, and copy the git link to clone using Git or your preferred IDE (VSCode, RStudio, etc.). The other option is to Download Zip under the Local tab which includes all of the repository files. 

However, if you can't download R and RStudio or VSCode (both are IDEs to work with R in) or are having other technical issues, then there is the option to use the repository as a template, create your own GitHub repository based on this one, and spin up a codespace with R and necessary packages (r4ss, ss3diags, etc.) loaded. You **must** create your own repository using this one as a template to save your work in your own GitHub repo, otherwise, it will be deleted.

| Model Name | Model Description |
| -----| ----- |
| herring-scaa (simple) | This example demonstrates SS3 configured to be similar to the approach used by SAM. It has no length data and gets body weight as empirical input from wtatage.ss. |
| herring-just-2019-as-equlibirum | This example demonstrates SS3 ability to operate with just one year of data. Here the model is estimating F for that year using the composition data. |
| herring-scaa-2dar-noTV | This shows a highly flexible approach to selectivity: [Two Dimensional Autoregressive (2DAR)](https://nmfs-stock-synthesis.github.io/doc/SS330_User_Manual_release.html#two-dimensional-auto-regressive-selectivity-semi-parametric-selectivity). Base selectivity is a flat line and age-specific deviations are estimated. "noTV" means that deviations are only in age and not in time (years). |
| herring-scaa-2dar | This example uses 2DAR with deviations for each age and each year within a defined range. |
| herring-aspm | This example shows SS3 doing Age-Structured Production Model. The composition data are ignored and recruitments are not estimated. Here the model is trying to estimate the trend in CPUE caused only by the catch. |
| predators | This example demonstrates SS3 ability to model the overall natural mortality (M) to include explicit mortality caused by major predators (M2) |
