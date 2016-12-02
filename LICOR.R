#Emily Kyker-Snowman
#February 25th, 2014
#This script reads in LICOR data, cleans up bad data, and calculates averages and standard errors for 
#groups defined by the user (i.e. Terrace, Ring).

#Setting up packages
setwd("~/Desktop/R")
#library(lattice)
require(plyr)
library(plyr)

#Pulling in csv file
LICORraw = read.csv(file.choose())
LICOR = subset(LICORraw, Exclude !=1)
summary(LICOR) 
attach(LICOR)

#Scanning for weird values in dataset
weirdRecords1 = subset(LICOR, Exp_R2<.9)
weirdRecords1
LICOR = subset(LICOR, Exp_R2>.9)

#Replaces negative temp values with NA
LICOR$Mean.T1[LICOR$Mean.T1 < 0] <- NA

#Truncate 'Ring' at the first character to get rid of b and c
LICOR$Ring = substr(LICOR$Ring,1,1)

#Looking at correlations between variables (colored by month)
pairs(LICOR[9:20], col=Month)

#Defining the standard error function.
stdErr <- function(x) {sd(x)/ sqrt(length(x))}
#Calculating averages and standard errors for defined groupings.
#To group by one or more variables, change what's inside .() in ddply.
LICORMeans <- ddply(LICOR, .(Terrace, Ring), summarise,
            Num_Records = length(Mean.Tcham),
            Offset = mean(Offset),
            Mean_Tcham = mean(Mean.Tcham),
            stdErr_Tcham = stdErr(Mean.Tcham),
            Mean_Pressure = mean(Mean.Pressure),
            stdErr_Pressure = stdErr(Mean.Pressure),
            Mean_H2O = mean(Mean.H2O),
            stdErr_H2O = stdErr(Mean.H2O),
            Mean_RH = mean(Mean.RH),
            stdErr_RH = stdErr(Mean.RH),
            Mean_T1 = mean(Mean.T1),
            stdErr_T1 = stdErr(Mean.T1),
            Mean_V1 = mean(Mean.V1),
            stdErr_V1 = stdErr(Mean.V1),
            Mean_Exp_Flux = mean(Exp_Flux),
            stdErr_Exp_Flux = stdErr(Exp_Flux),
            Mean_Lin_Flux = mean(Lin_Flux),
            stdErr_Lin_Flux = stdErr(Lin_Flux)
            )

#Prints the table of means to the console
LICORMeans