#Emily Kyker-Snowman
#February 26th, 2014
#This script reads in met station data, flags bad data, converts data to a time series and 
#calculates monthly and yearly averages.

#Setting up packages
setwd("~/Desktop/R")
#library(lattice)
require(plyr)
library(plyr)
require(xts)
library(xts)

#Pulling in all the .txt files of met stations records from a folder (duplicate records ok)
listOfFiles <- list.files(path = "~/Desktop/R/Mattole met station txt files", pattern= ".txt", full.names = TRUE) 
metRecordsRaw <- ldply(listOfFiles, read.table, header=TRUE, sep="\t", skip=2, fill=TRUE) #stringsAsFactors=FALSE) 
str(metRecordsRaw) 
#attach(metRecordsRaw)
#names(metRecordsRaw)
#summary(metRecordsRaw)

#Deduplicating records by date
metRecords = subset(metRecordsRaw, !duplicated(Date_Time))

#Shortening header names to everything that comes before '_' (look up 'regular expressions' to understand the first argument in gsub)
names(metRecords) <- gsub("_.*","", names(metRecords))

#Scanning for weird values in dataset
highGustSpeed = subset(metRecords, metRecords$Gust.Speed > 100)
highGustSpeed

lowTemp = subset(metRecords, metRecords$Temperature < 0)
lowTemp

#Converting data to a time series
#metTS 
metTS <- xts(metRecords[,2:8], as.POSIXct(metRecords$Date, format="%m/%d/%Y %H:%M:%S"))
rain <- xts(metRecords$Rain, as.POSIXct(metRecords$Date, format="%m/%d/%Y %H:%M:%S"))

#This is being stupid and dividing days into 3 uneven chunks, which introduces bias that affects monthly calculations
#x = apply.daily(metTS, mean)
#face = apply.daily(rain, length)

#Calculating monthly means
monthlyMeans = apply.monthly(metTS, mean)
monthlyMeans

monthlyTotalRain = apply.monthly(rain, sum)
monthlyTotalRain

#Calculating annual means. I use monthlyMeans to eliminate the bias introduced by inconsistent sampling interval. Months in which sampling interval changed are still biased.
annualMeans  = apply.yearly(monthlyMeans, mean)
annualMeans
#Using metTS biases averages towards periods of time with shorter sampling intervals.
#annualMeansb  = apply.yearly(metTS, mean)

yearlyTotalRain = apply.yearly(rain, sum)
yearlyTotalRain
