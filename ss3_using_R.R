library(r4ss)
# Link to intro to r4ss vignette here: https://r4ss.github.io/r4ss/articles/r4ss-intro-vignette.html

# Get info about your working directory
getwd()
list.files(getwd(), full.names = TRUE)

# This downloads the SS3 exe to your working directory
get_ss3_exe()

# This downloads the SS3 to your working directory, provided that directory is the
# cloned repository from GitHub
get_ss3_exe(dir = file.path(getwd(), "herring-just-2019-as-equilibrium"))

# Run the model, despite already having a report.sso file in there (that is why we
# set skipfinsihed = FALSE)
r4ss::run(dir = file.path(getwd(), "herring-just_2019-as-equilibrium"), exe = "ss3", 
          skipfinished = FALSE)
