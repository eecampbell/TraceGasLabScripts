###Intro to R session 2, 3
###Reading in .csv file
###Manipulating data frames
###for loop basics
###
###last modified 11/13/16
###created by Nell Campbell

#clear workspace
rm(list=ls())

#load library
library(dplyr)

#Laptop working directory
setwd("C:/Users/Tom/Documents/GitHub/RScriptsLab")

#load data
Csoil_data<-read.csv("./Intro_to_R_2_data.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)

#plot data, 1
plot(Csoil_data$Year, Csoil_data$Csoil, col="blue", pch=20)

#plot data, 2
#add labels to axes
plot(Csoil_data$Year, Csoil_data$Csoil, col="black", pch=18,
     xlab="Year", ylab=expression(paste("Soil Carbon (g C ", m^-2, ")")))


###example for loop
#create vector for for loop results
forloop_test<-vector(mode="numeric", length=nrow(Csoil_data))
forloop_test

for(m in 1:nrow(Csoil_data)){
  forloop_test[m]=Csoil_data$Year[m]+3
}

#check that for loop updated
forloop_test

####adding colors by island name
#Create a new column for colors
Csoil_data$colors <-vector(mode="character", length=nrow(Csoil_data))

#look at top of data frame to see that empty column was added
head(Csoil_data)

#read in data frame matching island name to colors
ColorMatch<-read.csv("./Intro_to_R_2_colors.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)


####run for loop to match Csoil_data$TreasureIsland with colors in the
#ColorMatch dataframe. Outer loop (j) steps through each row of Csoil_data
#while inner loop (k) compares the value in the row to ColorMatch
#outer loop for fcons table, where j steps through each row
for(j in 1:nrow(Csoil_data)){
  
  #inner loop for stepping through Intro_to_R_2_colors
  for(k in 1:nrow(ColorMatch)){
    #is the current value of Csoil_data$TreasureIsland row 'j' 
    #the same as the ColorMatch$TreasureIsland at location 'k'?
    if(Csoil_data$TreasureIsland[j]==ColorMatch$TreasureIsland[k]){
      #set row in Csoil_data$colors to color for that name
      Csoil_data$colors[j]=ColorMatch$Color[k]
      print(paste("Row ",j, " of Csoil_data and row",k, " of ColorMatch do match."))
    } else {
      print(paste("Row ",j, " of Csoil_data and row",k, " of ColorMatch don't match."))
    }
  }
}

head(Csoil_data)

#plot using colors column
plot(Csoil_data$Year, Csoil_data$Csoil, col=Csoil_data$colors, pch=18,
     xlab="Year", ylab=expression(paste("Soil Carbon (g C ", m^-2, ")")))


####introduction to dplyr
#tool for data analysis, exploration

#create dplyr object
csoil_wrapped<-tbl_df(Csoil_data)

#Filter out only data on Captain Hook
csoil_wrapped %>%
  filter(TreasureIsland=="CAPTAIN HOOK")

#Filter Captain Hook data, and then only select year data
csoil_wrapped %>%
  filter(TreasureIsland=="CAPTAIN HOOK") %>%
  select(Year)

#Filter data by Captain hook and only years 1990 and later
#create a new data object with data subset
CH_1990<- csoil_wrapped %>%
  filter(TreasureIsland=="CAPTAIN HOOK" & Year>=1990)

CH_1990

