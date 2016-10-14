###Two pool soil model with non-linear
###explicit microbial feedback
###drawn from Wang et al. (2014) yearly
###version of German et al. (2012) model

#clear workspace
rm(list=ls())

#load needed packages
library(deSolve)
library(ggplot2)

#Laptop
setwd("C:/Users/Tom/Documents/GitHub/TraceGasLabScripts")

#load data
Csoil_data<-read.csv("./data.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)


#model function
  Soil_Mic <- function(t, y, parms){
    #set initial state values
      Cmic  <-  y[1]
      Csoil <-  y[2]
      
    #set parameter values
      Input_litter   <-  parms[1] #carbon input (g C m^-2 year^-1)
      Temp_soil      <-  parms[2] #mean soil temp top 1m (Celcius)
      U              <-  parms[3] #turnover rate of microbial biomass (year^-1)
      Eps            <-  parms[4] #microbial growth efficency
    
    #calculated values
      #maximum rate of soil C assimilation per unit microbial biomass per year (g C m^-2)
        V   <-  (8*(10^-6)*exp(5.47+(0.063*Temp_soil))*(24*365))*8 
      #half-saturation constant for soil C assimilation by microbial biomass (g C m^-2)
        K   <-  (10*exp(3.19+(0.007*Temp_soil))*1000)*0.2 

    #model equations
      dCmic   <-  Eps*((Cmic*V*Csoil)/(Csoil+K))-(U*Cmic)
      dCsoil  <-  Input_litter+(U*Cmic)-((Cmic*V*Csoil)/(Csoil+K))
      
      return(list(c(dCmic, dCsoil)))
  }
  
  
#model setup
  times <- seq(0,50,1) #annual time step
  Pars  <- c(Input_litter=350, Temp_soil=15, U=4.38, Eps=0.5)
    ####Suggested ranges for variation
      ####Input_litter 50-500, larger values stabilize more quickly
      ####Temp_soil -5 to 35. Higher temps stabilize more quickly
      ####U poorly understood rate. This value set based on other studies.
      ####Eps 0.2 - 0.6. Lower values (less efficient microbial growth) cause longer time to stabilization
  yini  <- c(Cmic=100, Csoil=1000)

  
#Run model
  out<-lsoda(func=Soil_Mic, y=yini, parms=Pars, times=times)
  
#plot model outputs
  plot(out,ylab=expression(paste("Carbon (g C ", m^-2, ")")), xlab="year")
  
#change plot to single pane
  par(mfrow=c(1,1))
  #plot Csoil model results 
  plot(out[,1], out[,3], typ="l", 
       ylab=expression(paste("Carbon (g C ", m^-2, ")")), xlab="year",
       main="Csoil")
  #add points to plot for measured data
  points(Csoil_data[,1], Csoil_data[,2], col="red", pch=18)
  
  
  