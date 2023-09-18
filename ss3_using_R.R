# optionally clone the repository with example models into the working directory
# system("git clone https://github.com/nmfs-stock-synthesis/ICES-course-2023.git ICES-course-2023")
getwd() # Find out which directory you are in
setwd("ICES-course-2023") # If you have cloned/downloaded this from GitHub, you should already be in this directory
# install r4ss if not already present
remotes::install_github("r4ss/r4ss")

# Link to intro to r4ss vignette here: https://r4ss.github.io/r4ss/articles/r4ss-intro-vignette.html
library(r4ss)

# Get info about your working directory
getwd()
list.files(getwd(), full.names = TRUE)

# This downloads the SS3 exe to your working directory
get_ss3_exe()

# This downloads the SS3 exe to a specific directory
get_ss3_exe(dir = "herring-just-2019-as-equilibrium")
# look at contents of the directory
dir("herring-just-2019-as-equilibrium")

# Run the model, despite already having a Report.sso file in there
# (that is why we set skipfinished = FALSE)
r4ss::run(
  dir = "herring-just-2019-as-equilibrium",
  exe = "ss3",
  skipfinished = FALSE, # TRUE will skip running if Report.sso present
  show_in_console = FALSE # change to true to watch the output go past
)

# Run the model using the file path of the ss3 exe
# You can also use file paths to direct to ss3 in case it is downloaded somewhere else not in your
# working directory. In that case just copy the file path of where the ss3 exe is located.
# Here I am just using the getwd() to get the file path of where our ss3 is downloaded in this example.
r4ss::run(
  dir = "herring-just-2019-as-equilibrium",
  exe = file.path(getwd(), "ss3"),
  skipfinished = FALSE, # TRUE will skip running if Report.sso present
  show_in_console = FALSE # change to true to watch the output go past
)

# run the herring-scaa model
r4ss::run(
  dir = "herring-scaa",
  exe = "ss3",
  skipfinished = FALSE, # TRUE will skip running if Report.sso present
  show_in_console = FALSE # change to true to watch the output go past
)

herring_scaa <- SS_output("herring-scaa")
SS_plots(herring_scaa)
