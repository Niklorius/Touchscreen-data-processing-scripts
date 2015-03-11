library(lattice)
library(rms)
library(car)

setwd("D:/Documents/Josselyn Lab/Touchscreen/WXYZ")
fulldata<-read.csv("VMCL Training - Disappearing Sample Phase 2014-02-23.csv", header = TRUE, sep = ",", quote="\"", dec=".", na.strings=c("-"))
names(fulldata)<-c("AnimalID","ScheduleRunDate","PerLeftCorrect", "PerRightCorrect",
                   "LeftTouchLatency", "RightTouchLatency","LeftTouchStim1","LeftTouchStim2","LeftRewardCollectionLatency","RightRewardCollectionLatency","SampleTouchLatencyMinus","SampleTouchLatencyPlus","CorrectionTrials")
fulldata$AnimalID<-toupper(fulldata$AnimalID)

### assigning global variables

assign("databyDate", fulldata[order(strptime(fulldata$ScheduleRunDate, format="%j/%m/%Y %H:%M")),] , envir=.GlobalEnv)

assign("totalSessions",c(5), envir=.GlobalEnv)   ### Number of sessions (days of training), there should be at least 2 session to run the program
assign("num.animals",c(15),envir=.GlobalEnv)     ### Number of animals per cage
assign("IDs",sort(databyDate[1:num.animals, "AnimalID"]), envir=.GlobalEnv)
column<-names(fulldata)

###Define function to arrange data
arrangeData<-function(x){


    new.data<-data.frame(IDs) #starts a data frame containing only the animal ID column. We will add more columns through while loop, each column will be a training session.
    ##While loop
    i<-0

    while(i<totalSessions*num.animals){	      ##totalsessions * num.animals is simply carry out this while loops when i is less than number of rows.
        temp<-data.frame(databyDate[c(i+1):c(i+num.animals),]) ##Store the first 20 rows into temp
        i<-c(i+num.animals) #Increase i so i starts at 21 next time
        temp.ord<-data.frame(temp[order(temp$AnimalID),]) #re-orders temp by animalID
        sessionvalues<-data.frame(temp.ord[,x]) #from temp.ord, extract only the data from column x (e.g left correct, right correct, etc.)
        new.data<-data.frame(new.data,sessionvalues) #Make a new data frame. data.frame joins two data frames data.frame(df1,df2), i.e adding column x to column animal ID into new data frame.
    }

write.table(new.data,file=paste(x,".csv", sep=""), append = FALSE, sep = ",",eol = "\n", dec = ".", row.names = FALSE,col.names = TRUE)


}
#########################################################################################
### Run the analysis for each variable###

variables<-c(column[3:length(column)]) #Makes a variable named 'variables', in it is stored numbers 3, where the variables start, to length of full data column.
for(i in 1:length(variables)){
  arrangeData(variables[i])  }
