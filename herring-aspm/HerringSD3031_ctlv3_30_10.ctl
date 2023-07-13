#V3.30.xx.yy;_safe;_compile_date:_Jun 23 2023;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_13.1
#_Stock_Synthesis_is_a_work_of_the_U.S._Government_and_is_not_subject_to_copyright_protection_in_the_United_States.
#_Foreign_copyrights_may_apply._See_copyright.txt_for_more_information.
#_User_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_User_info_available_at:https://vlab.noaa.gov/group/stock-synthesis
#_Source_code_at:_https://github.com/nmfs-stock-synthesis/stock-synthesis

#C control file for Herring SD 30-31 (1 fleet 2 surveys)
#_data_and_control_files: HerringSD3031_datav3_30_10.dat // HerringSD3031_ctlv3_30_10.ctl
1  # 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
1  #_N_Growth_Patterns (Growth Patterns, Morphs, Bio Patterns, GP are terms used interchangeably in SS3)
1 #_N_platoons_Within_GrowthPattern 
#_Cond 1 #_Platoon_within/between_stdev_ratio (no read if N_platoons=1)
#_Cond sd_ratio_rd < 0: platoon_sd_ratio parameter required after movement params.
#_Cond  1 #vector_platoon_dist_(-1_in_first_val_gives_normal_approx)
#
4 # recr_dist_method for parameters:  2=main effects for GP, Area, Settle timing; 3=each Settle entity; 4=none (only when N_GP*Nsettle*pop==1)
1 # not yet implemented; Future usage: Spawner-Recruitment: 1=global; 2=by area
1 #  number of recruitment settlement assignments 
0 # unused option
#GPattern month  area  age (for each settlement assignment)
 1 1 1 0
#
#_Cond 0 # N_movement_definitions goes here if Nareas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
0 #_Nblock_Patterns
#_Cond 0 #_blocks_per_pattern 
# begin and end years of blocks
#
# controls for all timevary parameters 
1 #_time-vary parm bound check (1=warn relative to base parm bounds; 3=no bound check); Also see env (3) and dev (5) options to constrain with base bounds
#
# AUTOGEN
 1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen time-varying parms of this category; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
#_Available timevary codes
#_Block types: 0: P_block=P_base*exp(TVP); 1: P_block=P_base+TVP; 2: P_block=TVP; 3: P_block=P_block(-1) + TVP
#_Block_trends: -1: trend bounded by base parm min-max and parms in transformed units (beware); -2: endtrend and infl_year direct values; -3: end and infl as fraction of base range
#_EnvLinks:  1: P(y)=P_base*exp(TVP*env(y));  2: P(y)=P_base+TVP*env(y);  3: P(y)=f(TVP,env_Zscore) w/ logit to stay in min-max;  4: P(y)=2.0/(1.0+exp(-TVP1*env(y) - TVP2))
#_DevLinks:  1: P(y)*=exp(dev(y)*dev_se;  2: P(y)+=dev(y)*dev_se;  3: random walk;  4: zero-reverting random walk with rho;  5: like 4 with logit transform to stay in base min-max
#_DevLinks(more):  21-25 keep last dev for rest of years
#
#_Prior_codes:  0=none; 6=normal; 1=symmetric beta; 2=CASAL's beta; 3=lognormal; 4=lognormal with biascorr; 5=gamma
#
# setup for M, growth, wt-len, maturity, fecundity, (hermaphro), recr_distr, cohort_grow, (movement), (age error), (catch_mult), sex ratio 
#_NATMORT
1 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate;_5=BETA:_Maunder_link_to_maturity;_6=Lorenzen_range
6 #_N_breakpoints
 0.5 1 3 5 8 15 # age(real) at M breakpoints
#
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr; 5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
0.1 #_Age(post-settlement)_for_L1;linear growth below this
999 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0  #_placeholder for future growth feature
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
#
2 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
1 #_First_Mature_Age
1 #_fecundity_at_length option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach for M, G, CV_G:  1- direct, no offset**; 2- male=fem_parm*exp(male_parm); 3: male=female*exp(parm) then old=young*exp(parm)
#_** in option 1, any male parameter with value = 0.0 and phase <0 is set equal to female parameter
#
#_growth_parms
#_ LO HI INIT PRIOR PR_SD PR_type PHASE env_var&link dev_link dev_minyr dev_maxyr dev_PH Block Block_Fxn
# Sex: 1  BioPattern: 1  NatMort
 0.1 2.4 0.563 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_1_Fem_GP_1
 0.1 2.4 0.472 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_2_Fem_GP_1
 0.1 2.4 0.332 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_3_Fem_GP_1
 0.1 2.4 0.29 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_4_Fem_GP_1
 0.1 2.4 0.267 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_5_Fem_GP_1
 0.1 2.4 0.257 0.15 0.8 0 -1 0 0 0 0 0 0 0 # NatM_break_6_Fem_GP_1
# Sex: 1  BioPattern: 1  Growth
 0 20 4 4 10 0 -2 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
 10 40 25 20 10 0 -4 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
 0.05 0.8 0.4 0.47 0.8 0 -4 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
 0.05 0.5 0.2 0.5 0.8 0 -3 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
 0.1 0.7 0.2 0.5 0.8 0 -3 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
# Sex: 1  BioPattern: 1  WtLen
 -3 3 4e-06 4e-06 0.8 0 -99 0 0 0 0 0 0 0 # Wtlen_1_Fem_GP_1
 -3 4 3.05 3.0962 0.8 0 -99 0 0 0 0 0 0 0 # Wtlen_2_Fem_GP_1
# Sex: 1  BioPattern: 1  Maturity&Fecundity
 1 6 0.13 2 0.8 0 -99 0 0 0 0 0 0 0 # Mat50%_Fem_GP_1
 -3 3 -4.149 -0.25 0.8 0 -99 0 0 0 0 0 0 0 # Mat_slope_Fem_GP_1
 -3 3 1 1 0.8 0 -99 0 0 0 0 0 0 0 # Eggs/kg_inter_Fem_GP_1
 -3 3 0 0 0.8 0 -99 0 0 0 0 0 0 0 # Eggs/kg_slope_wt_Fem_GP_1
# Hermaphroditism
#  Recruitment Distribution 
#  Cohort growth dev base
 0.1 10 1 1 1 0 -1 0 0 0 0 0 0 0 # CohortGrowDev
#  Movement
#  Platoon StDev Ratio 
#  Age Error from parameters
#  catch multiplier
#  fraction female, by GP
 1e-06 0.999999 0.5 0.5 0.5 0 -99 0 0 0 0 0 0 0 # FracFemale_GP_1
#  M2 parameter for each predator fleet
#
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
 0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
3 #_Spawner-Recruitment; Options: 1=NA; 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm; 8=Shepherd_3Parm; 9=RickerPower_3parm
0  # 0/1 to use steepness in initial equ recruitment calculation
0  #  future feature:  0/1 to make realized sigmaR a function of SR curvature
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn #  parm_name
            16            25       17.4075        12.545             2             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
           0.1             1      0.773751          0.74         0.113             2          1          0          0          0          0          0          0          0 # SR_BH_steep
             0             2           0.6          0.23          0.05             0         -2          0          0          0          0          0          0          0 # SR_sigmaR
            -5             5             0             0             1             0         -1          0          0          0          0          0          0          0 # SR_regime
             0             1             0         0.456         0.054             0         -2          0          0          0          0          0          0          0 # SR_autocorr
#_no timevary SR parameters
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1980 # first year of main recr_devs; early devs can preceed this era
2019 # last year of main recr_devs; forecast devs start in following year
-3 #_recdev phase 
1 # (0/1) to read 13 advanced options
 -17 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
 -2 #_recdev_early_phase
 -1 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
 1 #_lambda for Fcast_recr_like occurring before endyr+1
 1956 #_last_yr_nobias_adj_in_MPD; begin of ramp
 1975 #_first_yr_fullbias_adj_in_MPD; begin of plateau
 2018 #_last_yr_fullbias_adj_in_MPD
 2019 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS3 sets bias_adj to 0.0 for fcast yrs)
 0.00  #_max_bias_adj_in_MPD (typical ~0.8; -3 sets all years to 0.0; -2 sets all non-forecast yrs w/ estimated recdevs to 1.0; -1 sets biasadj=1.0 for all yrs w/ recdevs)
 0 #_period of cycles in recruitment (N parms read below)
 -5 #min rec_dev
 5 #max rec_dev
 0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
# read specified recr devs
#_Yr Input_value
#
# all recruitment deviations
#  1963E 1964E 1965E 1966E 1967E 1968E 1969E 1970E 1971E 1972E 1973E 1974E 1975E 1976E 1977E 1978E 1979E 1980R 1981R 1982R 1983R 1984R 1985R 1986R 1987R 1988R 1989R 1990R 1991R 1992R 1993R 1994R 1995R 1996R 1997R 1998R 1999R 2000R 2001R 2002R 2003R 2004R 2005R 2006R 2007R 2008R 2009R 2010R 2011R 2012R 2013R 2014R 2015R 2016R 2017R 2018R 2019R 2020F 2021F 2022F 2023F 2024F 2025F 2026F 2027F 2028F 2029F
#  -0.542999 -0.621047 -0.699433 -0.778649 -0.874478 -0.936103 -0.962291 -0.531232 -0.774974 -0.488686 -0.198051 -0.391415 0.365567 -0.644833 -1.10001 -1.13558 -0.169216 -0.726009 -0.316151 0.167204 0.41994 0.223281 -0.654258 0.015637 -0.726587 0.736051 0.63245 0.0426424 0.183722 0.249361 -0.208942 0.0365735 -0.177433 -0.305066 0.3187 -0.2237 0.178145 -0.0283653 0.387105 1.08058 -0.403922 -0.343881 -0.028215 0.314697 -0.00833111 0.287523 0.0961366 -0.30933 0.0167202 -0.274535 -0.137732 0.436057 -0.205171 0.125842 -0.336388 -0.15641 -0.377945 0 0 0 0 0 0 0 0 0 0
#
#Fishing Mortality info 
0.23 # F ballpark value in units of annual_F
-2008 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope midseason rate; 2=F as parameter; 3=F as hybrid; 4=fleet-specific parm/hybrid (#4 is superset of #2 and #3 and is recommended)
2.3 # max F (methods 2-4) or harvest fraction (method 1)
4  # N iterations for tuning in hybrid mode; recommend 3 (faster) to 5 (more precise if many fleets)
#
#_initial_F_parms; for each fleet x season that has init_catch; nest season in fleet; count = 1
#_for unconstrained init_F, use an arbitrary initial catch and set lambda=0 for its logL
#_ LO HI INIT PRIOR PR_SD  PR_type  PHASE
 0.001 1 0.0294652 0.1 0.1 0 1 # InitF_seas_1_flt_1Fleet
#
# F rates by fleet x season
# Yr:  1963 1964 1965 1966 1967 1968 1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029
# seas:  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
# Fleet 0.0315322 0.0268912 0.0306106 0.0264083 0.0359696 0.0414429 0.0583602 0.0577767 0.0840431 0.071851 0.0516449 0.0582605 0.0446191 0.061322 0.0615644 0.0627749 0.0504533 0.0629178 0.0428808 0.0538921 0.0456482 0.0525306 0.0500076 0.0487047 0.0411361 0.0434322 0.0360773 0.0404624 0.0318828 0.0448552 0.0470219 0.0579625 0.0653783 0.0657635 0.083377 0.0768737 0.085597 0.0884562 0.0873685 0.0794554 0.073684 0.0778732 0.0840844 0.104955 0.120117 0.109313 0.114409 0.113668 0.132088 0.17778 0.204636 0.222676 0.242454 0.290015 0.245488 0.23673 0.22811 0.14 0.14 0.14 0.14 0.14 0.14 0.14 0.14 0.14 0.14
#
#_Q_setup for fleets with cpue or survey data
#_1:  fleet number
#_2:  link type: (1=simple q, 1 parm; 2=mirror simple q, 1 mirrored parm; 3=q and power, 2 parm; 4=mirror with offset, 2 parm)
#_3:  extra input for link, i.e. mirror fleet# or dev index number
#_4:  0/1 to select extra sd parameter
#_5:  0/1 for biasadj or not
#_6:  0/1 to float
#_   fleet      link link_info  extra_se   biasadj     float  #  fleetname
         2         1         0         1         0         1  #  Acoustics
         3         1         0         1         0         1  #  Trapnet
-9999 0 0 0 0 0
#
#_Q_parms(if_any);Qunits_are_ln(q)
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
           -25            25      -6.89956             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Acoustics(2)
             0             1             0           0.1           0.1             0         -3          0          0          0          0          0          0          0  #  Q_extraSD_Acoustics(2)
           -25            25      -18.1713             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Trapnet(3)
             0             1             0           0.1           0.1             0         -3          0          0          0          0          0          0          0  #  Q_extraSD_Trapnet(3)
#_no timevary Q parameters
#
#_size_selex_patterns
#Pattern:_0;  parm=0; selex=1.0 for all sizes
#Pattern:_1;  parm=2; logistic; with 95% width specification
#Pattern:_5;  parm=2; mirror another size selex; PARMS pick the min-max bin to mirror
#Pattern:_11; parm=2; selex=1.0  for specified min-max population length bin range
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_6;  parm=2+special; non-parm len selex
#Pattern:_43; parm=2+special+2;  like 6, with 2 additional param for scaling (average over bin range)
#Pattern:_8;  parm=8; double_logistic with smooth transitions and constant above Linf option
#Pattern:_9;  parm=6; simple 4-parm double logistic with starting length; parm 5 is first length; parm 6=1 does desc as offset
#Pattern:_21; parm=2+special; non-parm len selex, read as pairs of size, then selex
#Pattern:_22; parm=4; double_normal as in CASAL
#Pattern:_23; parm=6; double_normal where final value is directly equal to sp(6) so can be >1.0
#Pattern:_24; parm=6; double_normal with sel(minL) and sel(maxL), using joiners
#Pattern:_2;  parm=6; double_normal with sel(minL) and sel(maxL), using joiners, back compatibile version of 24 with 3.30.18 and older
#Pattern:_25; parm=3; exponential-logistic in length
#Pattern:_27; parm=special+3; cubic spline in length; parm1==1 resets knots; parm1==2 resets all 
#Pattern:_42; parm=special+3+2; cubic spline; like 27, with 2 additional param for scaling (average over bin range)
#_discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead;_4=define_dome-shaped_retention
#_Pattern Discard Male Special
 0 0 0 0 # 1 Fleet
 0 0 0 0 # 2 Acoustics
 0 0 0 0 # 3 Trapnet
#
#_age_selex_patterns
#Pattern:_0; parm=0; selex=1.0 for ages 0 to maxage
#Pattern:_10; parm=0; selex=1.0 for ages 1 to maxage
#Pattern:_11; parm=2; selex=1.0  for specified min-max age
#Pattern:_12; parm=2; age logistic
#Pattern:_13; parm=8; age double logistic. Recommend using pattern 18 instead.
#Pattern:_14; parm=nages+1; age empirical
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_16; parm=2; Coleraine - Gaussian
#Pattern:_17; parm=nages+1; empirical as random walk  N parameters to read can be overridden by setting special to non-zero
#Pattern:_41; parm=2+nages+1; // like 17, with 2 additional param for scaling (average over bin range)
#Pattern:_18; parm=8; double logistic - smooth transition
#Pattern:_19; parm=6; simple 4-parm double logistic with starting age
#Pattern:_20; parm=6; double_normal,using joiners
#Pattern:_26; parm=3; exponential-logistic in age
#Pattern:_27; parm=3+special; cubic spline in age; parm1==1 resets knots; parm1==2 resets all 
#Pattern:_42; parm=2+special+3; // cubic spline; with 2 additional param for scaling (average over bin range)
#Age patterns entered with value >100 create Min_selage from first digit and pattern from remainder
#_Pattern Discard Male Special
 17 0 0 0 # 1 Fleet
 17 0 0 0 # 2 Acoustics
 17 0 0 0 # 3 Trapnet
#
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
# 1   Fleet LenSelex
# 2   Acoustics LenSelex
# 3   Trapnet LenSelex
# 1   Fleet AgeSelex
         -1002             3         -1000            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P1_Fleet(1)
           -25            25             1            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P2_Fleet(1)
            -5             9       1.28731            -1            -1          0.01          -2          0          0          0          0          0          0          0  #  AgeSel_P3_Fleet(1)
            -5             9      0.350107            -1            -1          0.01          -2          0          0          0          0          0          0          0  #  AgeSel_P4_Fleet(1)
            -5             9      0.121623            -1            -1          0.01          -2          0          0          0          0          0          0          0  #  AgeSel_P5_Fleet(1)
            -5             9      0.113425            -1            -1          0.01          -3          0          0          0          0          0          0          0  #  AgeSel_P6_Fleet(1)
            -5             9    0.00198963            -1            -1          0.01          -3          0          0          0          0          0          0          0  #  AgeSel_P7_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P8_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P9_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P10_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P11_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P12_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P13_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P14_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P15_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P16_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P17_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P18_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P19_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P20_Fleet(1)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P21_Fleet(1)
# 2   Acoustics AgeSelex
         -1002             3         -1000            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P1_Acoustics(2)
           -25            25             1            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P2_Acoustics(2)
            -5             9      0.492393            -1            -1          0.01          2          0          0          0          0          0          0          0  #  AgeSel_P3_Acoustics(2)
            -5             9      0.231816            -1            -1          0.01          -2          0          0          0          0          0          0          0  #  AgeSel_P4_Acoustics(2)
            -5             9     0.0226931            -1            -1          0.01          -2          0          0          0          0          0          0          0  #  AgeSel_P5_Acoustics(2)
            -5             9     0.0187889            -1            -1          0.01          -3          0          0          0          0          0          0          0  #  AgeSel_P6_Acoustics(2)
            -5             9      0.116399            -1            -1          0.01          -3          0          0          0          0          0          0          0  #  AgeSel_P7_Acoustics(2)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P8_Acoustics(2)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P9_Acoustics(2)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P10_Acoustics(2)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P11_Acoustics(2)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P12_Acoustics(2)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P13_Acoustics(2)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P14_Acoustics(2)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P15_Acoustics(2)
           -10             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P16_Acoustics(2)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P17_Acoustics(2)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P18_Acoustics(2)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P19_Acoustics(2)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P20_Acoustics(2)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P21_Acoustics(2)
# 3   Trapnet AgeSelex
         -1002             3         -1000            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P1_Trapnet(3)
         -1002             3         -1000            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P2_Trapnet(3)
         -1002             3         -1000            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P3_Trapnet(3)
            -5            15             1            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P4_Trapnet(3)
            -5             9     0.0990981            -1            -1          0.01          -2          0          0          0          0          0          0          0  #  AgeSel_P5_Trapnet(3)
            -5             9           0.1            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P6_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P7_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P8_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P9_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P10_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P11_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P12_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P13_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P14_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P15_Trapnet(3)
           -10             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P16_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P17_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P18_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P19_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P20_Trapnet(3)
            -5             9             0            -1            -1          0.01         -4          0          0          0          0          0          0          0  #  AgeSel_P21_Trapnet(3)
#_No_Dirichlet parameters
#_no timevary selex parameters
#
0   #  use 2D_AR1 selectivity(0/1)
#_no 2D_AR1 selex offset used
#
# Tag loss and Tag reporting parameters go next
0  # TG_custom:  0=no read and autogen if tag data exist; 1=read
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# no timevary parameters
#
#
# Input variance adjustments factors: 
 #_1=add_to_survey_CV
 #_2=add_to_discard_stddev
 #_3=add_to_bodywt_CV
 #_4=mult_by_lencomp_N
 #_5=mult_by_agecomp_N
 #_6=mult_by_size-at-age_N
 #_7=mult_by_generalized_sizecomp
#_Factor  Fleet  Value
      5      1    0.7483
      5      2    0.9224
      5      3    1.3982
 -9999   1    0  # terminator
#
4 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 0 changes to default Lambdas (default value is 1.0)
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch; 9=init_equ_catch; 
# 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin; 17=F_ballpark; 18=initEQregime
#like_comp fleet  phase  value  sizefreq_method
5 1 1 0.00000001 1
5 2 1 0.00000001 1
5 3 1 0.00000001 1
-9999  1  1  1  1  #  terminator
#
# lambdas (for info only; columns are phases)
#  0 0 0 0 #_CPUE/survey:_1
#  1 1 1 1 #_CPUE/survey:_2
#  1 1 1 1 #_CPUE/survey:_3
#  1 1 1 1 #_agecomp:_1
#  1 1 1 1 #_agecomp:_2
#  1 1 1 1 #_agecomp:_3
#  1 1 1 1 #_init_equ_catch1
#  1 1 1 1 #_init_equ_catch2
#  1 1 1 1 #_init_equ_catch3
#  1 1 1 1 #_recruitments
#  1 1 1 1 #_parameter-priors
#  1 1 1 1 #_parameter-dev-vectors
#  1 1 1 1 #_crashPenLambda
#  0 0 0 0 # F_ballpark_lambda
0 # (0/1/2) read specs for more stddev reporting: 0 = skip, 1 = read specs for reporting stdev for selectivity, size, and numbers, 2 = add options for M,Dyn. Bzero, SmryBio
 # 0 2 0 0 # Selectivity: (1) fleet, (2) 1=len/2=age/3=both, (3) year, (4) N selex bins
 # 0 0 # Growth: (1) growth pattern, (2) growth ages
 # 0 0 0 # Numbers-at-age: (1) area(-1 for all), (2) year, (3) N ages
 # -1 # list of bin #'s for selex std (-1 in first bin to self-generate)
 # -1 # list of ages for growth std (-1 in first bin to self-generate)
 # -1 # list of ages for NatAge std (-1 in first bin to self-generate)
999
