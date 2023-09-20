# messy script created talk on likelihoods 
# for 2023 ICES course on Stock Synthesis
# 
# note: script assumes working directory is the ICES-course-2023 directory
# including herring model files

# required packages: r4ss, ggplot2, tidyr, cli

# load r4ss
library(r4ss)
library(ggplot2)

# check that exe is in the path (could modify script to not require this)
check_exe("ss3")
# $exe
# [1] "ss3.exe"

# $path
# [1] "C:/SS3/SSv3.30.21" # path (if found) will depend on user's location

# run herring-aspm model
run("herring-aspm", exe = "ss3", skipfinished = FALSE)
# read output from age-structure production model
herring_aspm <- SS_output("herring-aspm")
# read output from SCAA version
herring_scaa <- SS_output("herring-scaa")
SSplotComparisons(SSsummarize(list(herring_scaa, herring_aspm)),
  plot = FALSE, print = TRUE, plotdir = "compare_aspm_vs_scaa",
  legendlabels = c("herring-scaa", "herring-aspm")
)

# look at the 4 estimated parameters
max(herring_aspm$parameters$Active_Cnt, na.rm = TRUE)
# [1] 4
herring_aspm$estimated_non_dev_parameters
#                              Value Phase    Min Max       Init Status  Parm_StDev     Gradient
# SR_LN(R0)               17.3472000     1 16.000  25 17.4075000     OK  0.20117600  9.62784e-06
# SR_BH_steep              0.8474020     1  0.100   1  0.7737510     OK  0.08768130  2.77380e-05
# InitF_seas_1_flt_1Fleet  0.0312006     1  0.001   1  0.0294652     OK  0.00842462  3.03719e-05
# AgeSel_P3_Acoustics(2)   6.8189900     2 -5.000   9  0.4923930     OK 41.08950000 -8.42920e-07

### make an even simpler version of herring-aspm
# copy model input files to new directory
copy_SS_inputs(
  dir.old = "herring-aspm",
  dir.new = "herring-aspm-2d",
  use_ss_new = TRUE
) # this means that the initial values will be the MLE values

# turn off the phase for 2 of the parameters
SS_changepars(
  dir = "herring-aspm-2d",
  ctlfile = "HerringSD3031_ctlv3_30_10.ctl",
  newctlfile = "HerringSD3031_ctlv3_30_10.ctl",
  strings = c("InitF_seas_1_flt_1Fleet", "AgeSel_P3_Acoustics(2)"),
  newphs = c(-2, -2) # new phase is negative, so don't estimate
)

# run revised model
run("herring-aspm-2d", exe = "ss3", skipfinished = FALSE)

# read simplified version into R
herring_aspm_2d <- SS_output("herring-aspm-2d")
# make sure the two models match by confirming that the likelihoods are the same
all(herring_aspm$likelihoods_used$Value == herring_aspm_2d$likelihoods_used$Value)
# [1] TRUE
# current depletion (associated with endyr + 1) is not identical, but very close
herring_aspm$current_depletion
# [1] 0.6243169
herring_aspm_2d$current_depletion
# [1] 0.624316

#### create a grid of log(R0) and steepness values to explore
steep_vec <- seq(0.7, 1.0, 0.05)
log_R0_vec <- seq(17, 18, 0.1)

grid_table <- tidyr::expand_grid(R0 = log_R0_vec, h = steep_vec)
grid_table$label <- paste0("R0_", grid_table$R0, "_h_", grid_table$h)
grid_table$dir <- file.path("herring-aspm-2d/grid", grid_table$label)

ngrid <- nrow(grid_table)

grid_table
# # A tibble: 88 × 4
#       R0     h label         dir
#    <dbl> <dbl> <chr>         <chr>
#  1  16     0.3 R0_16_h_0.3   herring-aspm-2d/grid/R0_16_h_0.3
#  2  16     0.4 R0_16_h_0.4   herring-aspm-2d/grid/R0_16_h_0.4
#  3  16     0.5 R0_16_h_0.5   herring-aspm-2d/grid/R0_16_h_0.5
#  4  16     0.6 R0_16_h_0.6   herring-aspm-2d/grid/R0_16_h_0.6
#  5  16     0.7 R0_16_h_0.7   herring-aspm-2d/grid/R0_16_h_0.7
#  6  16     0.8 R0_16_h_0.8   herring-aspm-2d/grid/R0_16_h_0.8
#  7  16     0.9 R0_16_h_0.9   herring-aspm-2d/grid/R0_16_h_0.9
#  8  16     1   R0_16_h_1     herring-aspm-2d/grid/R0_16_h_1
#  9  16.5   0.3 R0_16.5_h_0.3 herring-aspm-2d/grid/R0_16.5_h_0.3
# 10  16.5   0.4 R0_16.5_h_0.4 herring-aspm-2d/grid/R0_16.5_h_0.4
# # ℹ 78 more rows
# # ℹ Use `print(n = ...)` to see more rows


# create a directory to store grid models
dir.create("herring-aspm-2d/grid")
# read model input files into R
mod_files <- SS_read("herring-aspm-2d")
# make copy in which to make changes
mod_files2 <- mod_files
# loop over rows and modify the files and write to new directory
cli::cli_progress_bar("Creating model directories", total = ngrid)
for (irow in 1:ngrid) {
  cli::cli_progress_update()
  # change initial value for log(R0)
  mod_files2$ctl$SR_parms["SR_LN(R0)", "INIT"] <- grid_table$R0[irow]
  # change initial value for steepness
  mod_files2$ctl$SR_parms["SR_BH_steep", "INIT"] <- grid_table$h[irow]
  # write modified files to new directory
  SS_write(mod_files2, dir = grid_table$dir[irow])
}

# loop over rows and modify the files and write to new directory
cli::cli_progress_bar("Running models", total = ngrid)
# cli::cli_progress_step("Running model {irow}/{ngrid}.")
for (irow in 1:ngrid) {
  cli::cli_progress_update()
  r4ss::run(
    dir = grid_table$dir[irow],
    exe = "ss3",
    extras = "-stopph 0 -nohess", # no estimation and no Hessian
    verbose = FALSE,
    skipfinished = FALSE
  )
}

grid_out <- SSgetoutput(dirvec = grid_table$dir)
grid_summary <- SSsummarize(grid_out, verbose = FALSE)

# get table of likelihoods
# transpose table from SSsummarize()
like_table <- data.frame(t(grid_summary$likelihoods[, 1:ngrid]))
names(like_table) <- paste0("like_", grid_summary$likelihoods$Label)
# combine the two tables
grid_table <- cbind(grid_table, like_table)


like_contour <- function(like_type = "like_TOTAL") {
  z <- grid_table[[like_type]]
  v <- ggplot(grid_table, aes(h, R0, z = z)) +
    geom_contour_filled() +
    geom_point(aes(x = herring_aspm_2d$parameters["SR_BH_steep", "Value"]),
      y = herring_aspm_2d$parameters["SR_LN(R0)", "Value"],
      color = "red"
    )
  return(v)
}
v <- like_contour()

# re-write input files for minimized model with ParmTrace to see minimization path
mod_files$start$parmtrace <- 4
# change initial values to make it slightly harder to find MLE
mod_files$ctl$SR_parms["SR_LN(R0)", "INIT"] <- 17.2
mod_files$ctl$SR_parms["SR_BH_steep", "INIT"] <- 0.7
SS_write(mod_files, dir = mod_files$dir, overwrite = TRUE)
run(mod_files$dir, exe = "ss3", show_in_console = TRUE, skipfinished = FALSE)

# read parameter trace (the column names don't cover all columns, so extra work is needed)
parmtrace <- read.table("herring-aspm-2d/ParmTrace.sso", fill = TRUE)
# remove additional columns
parmtrace <- parmtrace[, 1:(-1 + which(parmtrace[1, ] == "Component_like_starts_here"))]
# use first row as column names
names(parmtrace) <- parmtrace[1, ]
# remove first row
parmtrace <- parmtrace[-1, ]
# parentheses were causing problems with ggplot
names(parmtrace)[names(parmtrace) == "SR_LN(R0)"] <- "lnR0"
# convert strings to numeric
parmtrace <- type.convert(parmtrace, as.is = TRUE)

# ggplot() +
#   geom_contour_filled(data = grid_table, aes(h, R0, z = like_TOTAL))

ggplot() +
  geom_contour_filled(data = grid_table, aes(R0, h, z = like_TOTAL)) +
  geom_point(data = parmtrace, aes(x = lnR0, y = SR_BH_steep), color = "red") +
  geom_segment(
    data = parmtrace, aes(
      x = lnR0, y = SR_BH_steep,
      xend = after_stat(dplyr::lead(x)), yend = after_stat(dplyr::lead(y))
    ),
    arrow = arrow(length = unit(3, "mm")), color = "red"
  ) + 
  theme_minimal()
ggsave("likelihood_grid.png")

### run profiles

# run a likelihood profile over log(R0) on one of the herring models
herring_dir <- "herring-scaa" # change to "herring-aspm" or other to run different model

dir_prof <- file.path(getwd(), herring_dir, "profile")
# copy files to "profile" directory
copy_SS_inputs(
  dir.old = herring_dir,
  dir.new = dir_prof,
  create.dir = TRUE,
  overwrite = TRUE,
)
# the following commands related to starter.ss could be done by hand
# read starter file
starter <- SS_readstarter(file.path(dir_prof, "starter.ss"))
# change control file name in the starter file
starter[["ctlfile"]] <- "control_modified.ss"
# make sure the prior likelihood is calculated
# for non-estimated quantities
starter[["prior_like"]] <- 1
# write modified starter file
SS_writestarter(starter, dir = dir_prof, overwrite = TRUE)
# vector of values to profile over
log_R0_vec
Nprofile <- length(log_R0_vec)
# run profile command
profile <- profile(
  dir = dir_prof,
  oldctlfile = "HerringSD3031_ctlv3_30_10.ctl",
  newctlfile = "control_modified.ss",
  string = "R0", # subset of parameter label
  profilevec = log_R0_vec,
  exe = "ss3"
)
# read the output files (with names like Report1.sso, Report2.sso, etc.)
profilemodels <- SSgetoutput(dirvec = dir_prof, keyvec = 1:Nprofile)
# summarize output
profilesummary <- SSsummarize(profilemodels)
# plot profile using summary created above
results <- SSplotProfile(profilesummary, # summary object
  profile.string = "R0", # substring of profile parameter
  profile.label = "Log of equilibrium recruitment log(R0)",
  legendloc = "topright",
  plot = FALSE,
  print = TRUE,
  plotdir = dir_prof
)
# rename plot to avoid overwrite
file.copy(
  file.path(dir_prof, "profile_plot_likelihood.png"),
  file.path(dir_prof, "profile_plot_total_likelihood.png"),
  overwrite = TRUE
)
# plot index components of likelihood profile
PinerPlot(profilesummary, # summary object
  component = "Surv_like",
  profile.string = "R0", # substring of profile parameter
  profile.label = "Log of equilibrium recruitment log(R0)",
  legendloc = "topright",
  plot = FALSE,
  print = TRUE,
  plotdir = dir_prof
)
# rename plot to avoid overwrite
file.copy(
  file.path(dir_prof, "profile_plot_likelihood.png"),
  file.path(dir_prof, "profile_plot_surv_likelihood.png"),
  overwrite = TRUE
)
# plot index components of likelihood profile
PinerPlot(profilesummary, # summary object
  component = "Age_like",
  profile.string = "R0", # substring of profile parameter
  profile.label = "Log of equilibrium recruitment log(R0)",
  legendloc = "topright",
  plot = FALSE,
  print = TRUE,
  plotdir = dir_prof
)
# rename plot to avoid overwrite
file.copy(
  file.path(dir_prof, "profile_plot_likelihood.png"),
  file.path(dir_prof, "profile_plot_age_likelihood.png"),
  overwrite = TRUE
)
# make timeseries plots comparing models in profile
SSplotComparisons(profilesummary,
  legendlabels = c(paste("log(R0) =", log_R0_vec), "MLE"),
  plot = FALSE, print = TRUE,
  plotdir = dir_prof
)

# get steepness associated with points in profile
profile_h <- profilesummary$pars |>
  dplyr::filter(Label == "SR_BH_steep") |>
  dplyr::select(dplyr::starts_with("replist"))
plot(log_R0_vec, profile_h)
