###########################################
# install.packages("devtools")
# devtools::install_github("jabbamodel/ss3diags")
# devtools::install_github("r4ss/r4ss", ref="development")
# devtools::install_github("r4ss/r4ss")

#**************************************
# Example with Central Baltic herring
#**************************************

library(ss3diags)
library(r4ss)

file.path = "C:/Users/mascar/Documents/Max/Stock_synthesis/Course/ICES 2023/"

setwd(file.path)
dir.create("Plotdiags",showWarnings = F)

# Set Reference run model folder
Runs = c('Central Baltic herring') 

#Load retro output obtained from retro function in r4ss
##### Read in output #############################################
retroModels <- SSgetoutput(dirvec=file.path(mydir, "Retrospective",paste("retro",0:-5, sep="")))
save(retroModels, file="retroModels_Run3.Rdata")
# Summarize output
retroSummary <- SSsummarize(retroModels)
# Set the ending year of each model in the set
endyrvec <- retroSummary$endyrs + 0:-5
save(retroSummary, retroModels, file="retro5.Rdata")
###################################################################

load("C:/Users/mascar/Documents/Max/Stock_synthesis/Course/ICES 2023/retro5.Rdata")

# Reference run
ss3rep = retroModels[[1]]
save(ss3rep, file="CBHref.Rdata")

# Produce r4ss
SS_plots(ss3rep,dir=getwd())

# Plot the Data
sspar()
SSplotData(ss3rep,subplots = 2)
dev.print(jpeg,paste0("Plotdiags/DataSetup_",Runs,".jpg"), width = 8, height = 6, res = 300, units = "in")

#****************************************
# Basic Residual Diags
#****************************************

# Check Runs Test and Joint residuals option for mean composition data
sspar(mfrow=c(2,2),plot.cex = 0.8)

# For cpue
SSplotRunstest(ss3rep,subplots="cpue",add=T,legendcex = 0.6)

# For age
#SSplotRunstest(ss3rep,subplots="len",add=T,legendcex = 0.6)
SSplotRunstest(ss3rep,subplots="age",add=T,legendcex = 0.6)
dev.print(jpeg,paste0("Plotdiags/RunsTestResiduals_",Runs,".jpg"), width = 8, height = 7, res = 300, units = "in")

# Check conflict between indices and mean age
sspar(mfrow=c(1,2),plot.cex = 0.8)
SSplotJABBAres(ss3rep,subplots="cpue",add=T,col=sscol(3)[c(1,3,2)])
SSplotJABBAres(ss3rep,subplots="age",add=T,col=sscol(3)[c(1,3,2)])
#SSplotJABBAres(ss3rep,subplots="age",add=T,col=sscol(3)[c(1,3,2)])
dev.print(jpeg,paste0("Plotdiags/JointResiduals_",Runs,".jpg"), width = 8, height = 3.5, res = 300, units = "in")

#****************************************************************
# Approximate uncertainty with MVLN (hessian)

# Check starter file
starter = SSsettingsBratioF(ss3rep)
# Get uncertainty from MVLN for F/F_Btrg with original F setting F_abs

sspar(mfrow=c(1,1),plot.cex = 0.9)
#Fref = c("Ftrg") #to change from FMSY to Ftrg
mvn = SSdeltaMVLN(ss3rep,plot = T, Fref = c("Btgt"))
kbproj = data.frame(mvn$kb)

#labels = mvn$labels
SSplotKobe(kbproj,fill=T,joint=F,posterior="kernel",ylab=expression(F/F[trg]),xlab=expression(SSB/SSB[trg]))

mvn$labels <- expression(SSB/SSB[trg], "F/F"[SB ~ 35], "SSB", 
                         "F", "Recruits", "Catch")
dev.print(jpeg,paste0("Plotdiags/Kobe_",Runs,".jpg"), width = 6.5, height = 6.5, res = 300, units = "in")

sspar(mfrow=c(2,3),plot.cex = 0.9)
SSplotEnsemble(mvn$kb,ylabs = mvn$labels,add=T)
dev.print(jpeg,paste0("Plotdiags/MLVN_trj_",Runs,".jpg"), width = 8, height = 6.5, res = 300, units = "in")

#*******************************************************************
#  Retrospective Analysis with Hindcasting
#*******************************************************************
# Summarize the list of retroModels
retroSummary <- r4ss::SSsummarize(retroModels)

# Now Check Retrospective Analysis with one-step ahead Forecasts
sspar(mfrow=c(2,2),plot.cex = 0.9)
SSplotRetro(retroSummary,forecastrho = T,add=T,subplots="SSB",endyrvec = 2021:2016)
SSplotRetro(retroSummary,forecastrho = T,add=T,legend = F,xmin=2005,endyrvec = 2021:2016)
SSplotRetro(retroSummary, subplots = "F",add=T,legendloc = "left",legendcex = 0.8,endyrvec = 2020:2015)
SSplotRetro(retroSummary,subplots = "F", xmin=2005,forecastrho = T,add=T,legend = F,endyrvec = 2020:2015)
dev.print(jpeg,paste0("Plotdiags/RetroForecast_",Runs,".jpg"), width = 8, height = 9, res = 300, units = "in")

# Do Hindcast with Cross-Validation of CPUE observations
sspar(mfrow=c(1,1),plot.cex = 0.9)
SSplotHCxval(retroSummary,xmin=2006,add=T,legendcex = 0.6, Season=1)
dev.print(jpeg,paste0("Plotdiags/HCxvalIndex_",Runs,".jpg"), width = 8, height = 5, res = 300, units = "in")

# Also test new feature of Hindcast with Cross-Validation for mean length
# Use new converter fuction SSretroComps()
hccomps = SSretroComps(retroModels)
sspar(mfrow=c(1,2),plot.cex = 0.7)
SSplotHCxval(hccomps,add=T,subplots = "age",legendloc="topleft",indexUncertainty = TRUE,legendcex = 0.6, Season=1, ylim=c(2,5.5))
#SSplotHCxval(hccomps,add=T,subplots = "len",legendloc="topleft",indexUncertainty = TRUE,legendcex = 0.6, Season=2, ylim=c(0.5,3.5))
dev.print(jpeg,paste0("Plotdiags/HCxvalAge",Runs,".jpg"), width = 8, height = 4, res = 300, units = "in")

sspar(mfrow=c(1,1),plot.cex = 0.7)
SSplotHCxval(retroSummary,add=T,subplots = "cpue",legendloc="topleft",indexUncertainty = TRUE,legendcex = 0.6)
#SSplotHCxval(hccomps,add=T,subplots = "len",legendloc="topleft",indexUncertainty = TRUE,legendcex = 0.6, Season=4, ylim=c(0.5,3.5))
dev.print(jpeg,paste0("Plotdiags/HCxvalCPUE",Runs,".jpg"), width = 8, height = 4, res = 300, units = "in")

#Tables (no figures)
SShcbias(retroSummary)

SSmase(hccomps,quants = "age", Season=c(1))
#SSmase(hccomps,quants = "len", Season=c(2))
#SSmase(hccomps,quants = "len", Season=c(3))
#SSmase(hccomps,quants = "len", Season=c(4))
#SSmase(hccomps,quants = "age", Season=c(4))
SSmase(retroSummary,quants = "cpue", Season=c(1))









