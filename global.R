library (dplyr) 
library(data.table)
library (lubridate)
library(zipcode)

library(ggplot2)
library (ggthemes) 

library(labeling)
library(chron)

library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(shinydashboard)

# devtools::install_github("rstudio/leaflet")
# 
# setwd("C:/Users/Pradeep Krishnan/Desktop/New folder/visionzero/Main")
# 
# 
# mvc_raw=fread("NYPD_Motor_Vehicle_Collisions.csv")
# #1015999 observartions and 29 variables
# 
# 
# mvc_raw[mvc_raw==""]<-NA
# #to fill missing values uniformly with NA
# 
# 
# names(mvc_raw)<-chartr(" ","_", names(mvc_raw))
# #to rename variable names so that space is replace by underscore
# 
# mvc_raw[,DATE:=mdy(DATE)]
# #changing the type of DATE column from character to date
# 
# mvc_raw[,MONTH:=month(DATE)]
# mvc_raw[,YEAR:=year(DATE)]
# #creating month and year columns 
# 
# #Removing 2012 and 2017 from the observations because they do not have data for the full year
# mvc_raw<-mvc_raw[YEAR %in% c(2013:2016)]
# 
# mvc_raw<- filter(mvc_raw, !is.na(BOROUGH))
# mvc_raw<- filter(mvc_raw, !is.na(LOCATION))
# mvc_raw<- filter(mvc_raw, !is.na(ZIP_CODE))
# #filtering out observations with empty borough, location, zipcode
# 
# 
# mvc_raw=select(mvc_raw,-contains("STREET"))
# 
# mvc_raw=select(mvc_raw,-contains("CONTRIBUTING_FACTOR_VEHICLE_3"))
# mvc_raw=select(mvc_raw,-contains("CONTRIBUTING_FACTOR_VEHICLE_4"))
# mvc_raw=select(mvc_raw,-contains("CONTRIBUTING_FACTOR_VEHICLE_5"))
# mvc_raw=select(mvc_raw,-contains("VEHICLE_TYPE_CODE_3"))
# mvc_raw=select(mvc_raw,-contains("VEHICLE_TYPE_CODE_4"))
# mvc_raw=select(mvc_raw,-contains("VEHICLE_TYPE_CODE_5"))
# mvc_raw=select(mvc_raw,-contains("UNIQUE_KEY"))
# 
# 
# write.csv(mvc_raw, "NY_MotorVehicleCollisions_Cleaned.csv",row.names=FALSE)

mvc=fread("NY_MotorVehicleCollisions_Cleaned.csv")


###################################################################################
#mvc2_for_plotting=mvc # Created mvc copy here to work on ggplots 
#mvc2_for_plotting contains 601258 observations of 21 variables
###################################################################################


mvc_grp=mvc %>% group_by(BOROUGH,YEAR)
Borough_by_year = mvc_grp %>% summarise(total_killed = sum(NUMBER_OF_PERSONS_KILLED))
Killed_by_years = ggplot(data = Borough_by_year, aes(x = YEAR, y = total_killed))
Killed_by_years + geom_bar(aes(fill = BOROUGH), stat = 'identity') + theme(legend.position = "right") + theme(legend.text=element_text(size=5)) + ggtitle('Fatalities') + ylab("Persons killed\n") + xlab("\nYEAR")  + theme(axis.text.x = element_text(vjust = 0.5, angle = 0, hjust = 0.5)) + theme(legend.position = "right") + theme(legend.text=element_text(size=10)) + theme(plot.title = element_text(hjust = 0.5))


##########################################
#the map part of it
##########################################

mvc=as.data.table(mvc)
location_dt=mvc[,.N,by=LOCATION]
location_sort=location_dt[order(-rank(N), LOCATION)]
location_sort

mvc_borough_ziploc=mvc[,c("BOROUGH","ZIP_CODE","LOCATION","LONGITUDE","LATITUDE")]

mvc_uniq_columns=mvc_borough_ziploc[!duplicated(mvc_borough_ziploc[,LOCATION,])]

major_intersections=merge(mvc_uniq_columns,location_sort, by="LOCATION")

n<-.05

top_intersections=head(major_intersections[order(major_intersections$N,decreasing=T),],n*nrow(major_intersections))

