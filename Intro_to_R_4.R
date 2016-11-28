#clear workspace
rm(list=ls())

#load packages
library(dplyr)
library(tidyr)
library(ggplot2)

#set working directory
setwd("C:/Users/Tom/Documents/GitHub/RScriptsLab")





#load measured data
Measured_data<-read.csv("./Subset_Measured_Rosemount.csv", 
                        header=TRUE, sep=",", stringsAsFactors=FALSE)
#wrap using dplyr
Measured_data<-tbl_df(Measured_data)





#load modeled data
Modeled_data<-read.csv("./Subset_DayCent_Rosemount.csv", 
                       header=TRUE, sep=",", stringsAsFactors=FALSE)
#wrap using dplyr
Modeled_data<-tbl_df(Modeled_data)







#plot Soil Carbon results
ggplot(data=Modeled_data, aes(x=time, y=somsc)) +
  geom_line(aes(group=treatment, colour=treatment))+
  labs(x="Year", y=expression(paste("Soil Carbon (g C ", m^-2, ")")))



#gather data
longskinny<-Measured_data %>% 
  gather(Measure_type, Measurement, -site, -treatment, -year, -units, -SOC_order, na.rm=TRUE)  




#measured/modeled yield data
yield<-longskinny %>%
  filter(Measure_type=="grain_meas") %>%
  select(site, treatment, year, units, Measurement)


#add column for modeled results
yield$modeled<-as.numeric(matrix(0, nrow=nrow(yield), ncol=1))


#assemble modeled yield data
for(j in 1:nrow(yield)){
  modeled<-Modeled_data %>%
    filter(site==yield$site[j] & treatment==yield$treatment[j] &
             time==yield$year[j]+.75) %>%
    select(cgrain)
  yield$modeled[j]=as.numeric(modeled)/100
}

#plot measured/modeled yield results
ggplot(data=yield, aes(x=Measurement, y=modeled)) +
  geom_point(aes(group=treatment, colour=treatment))+
  geom_abline(slope=1, intercept=0)+    
  labs(x=expression(paste("Measured Grain c (Mg C ", ha^-1, ")")), 
       y=expression(paste("Modeled Grain c (Mg C ", ha^-1, ")")))+
  geom_smooth(method='lm', aes(group=treatment))



jpeg(file="./Yield_Modeled.jpg")
ggplot(data=yield, aes(x=Measurement, y=modeled)) +
  geom_point(aes(group=treatment, colour=treatment))+
  geom_abline(slope=1, intercept=0)+    
  labs(x=expression(paste("Measured Grain c (Mg C ", ha^-1, ")")), 
       y=expression(paste("Modeled Grain c (Mg C ", ha^-1, ")")))+
  geom_smooth(method='lm', aes(group=treatment))
dev.off()
