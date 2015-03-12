####### Working directory where .csv file is located ############
setwd("D:/Documents/Josselyn Lab/Touchscreen/NOPQR/Probe day 1")

#load variables.
stimulus<-read.csv("Probe Index.csv", header = TRUE, sep = ",", quote="\"", dec=".", na.strings=c("-"))
touch.lat<-read.csv("Probe Sample Touch Latency.csv", header = TRUE, sep = ",", quote="\"", dec=".", na.strings=c("-"))
left<-read.csv("Probe Left Touch Latency.csv", header = TRUE, sep = ",", quote="\"", dec=".", na.strings=c("-"))
right<-read.csv("Probe Right Touch Latency.csv", header = TRUE, sep = ",", quote="\"", dec=".", na.strings=c("-"))
regular.cues<-read.csv("Probe VMCL data.csv", header = TRUE, sep = ",", quote="\"", dec=".", na.strings=c("-"))

#normalize column names.
names.evaluations<-c("AnimalID","ScheduleRunDate",1:51)
names(stimulus)<-names.evaluations
names(touch.lat)<-names.evaluations
names(left)<-names.evaluations
names(right)<-names.evaluations

names.evaluations<-c("AnimalID","ScheduleRunDate",1:59)
names(regular.cues)<-names.evaluations

#normalize dates.
stimulus$AnimalID<-toupper(stimulus$AnimalID)
stimulus<-stimulus[order(stimulus$AnimalID,strptime(stimulus$ScheduleRunDate,format="%m/%d/%Y %I:%M:%S %p")),]


touch.lat$AnimalID<-toupper(touch.lat$AnimalID)
touch.lat<-touch.lat[order(touch.lat$AnimalID,strptime(touch.lat$ScheduleRunDate,format="%m/%d/%Y %I:%M:%S %p")),]

left$AnimalID<-toupper(left$AnimalID)
left<-left[order(left$AnimalID,strptime(left$ScheduleRunDate,format="%m/%d/%Y %I:%M:%S %p")),]

right$AnimalID<-toupper(right$AnimalID)
right<-right[order(right$AnimalID,strptime(right$ScheduleRunDate,format="%m/%d/%Y %I:%M:%S %p")),]

regular.cues$AnimalID<-toupper(regular.cues$AnimalID)
regular.cues<-regular.cues[order(regular.cues$AnimalID,strptime(regular.cues$ScheduleRunDate,format="%m/%d/%Y %I:%M:%S %p")),]


max.col<-c(ncol(stimulus)-1)

##massive If statement, to combine inputs into one table that lists decision making paramaters for each stimulus and animal.
if(identical(stimulus$AnimalID,touch.lat$AnimalID)){

	if(identical(touch.lat$AnimalID,left$AnimalID)){
		if(identical(left$AnimalID,right$AnimalID)){
		num.cues<-c(5) 
		newtable<-matrix(nrow=(nrow(stimulus)*15),ncol=8)	
		row.stimulus<-1
		new.row<-1
		sess.num<-1
		while(row.stimulus<=nrow(stimulus)){
			new.col<-1
			col.stimulus<-1 #for AnimalID
			rowname<-stimulus[row.stimulus,col.stimulus]
			if(sess.num==1){
			flag.name<-rowname	
			}
			else{
				if(flag.name!=rowname){
					sess.num<-1
					flag.name<-rowname
				}
			}
			new.col<-2
			col.stimulus<-3
			while(col.stimulus<=max.col){ ####IT IS TAKING IN COUNT THAT THERE IS ONE MORE COLUMN
				new.col<-1
				if(sum(is.na(stimulus[row.stimulus,col.stimulus]))==0){
					if(stimulus[row.stimulus,col.stimulus]!=0){
					newtable[new.row,new.col]<-flag.name
					new.col<-2
					newtable[new.row,new.col]<-sess.num
					new.col<-3
					newtable[new.row,new.col]<-stimulus[row.stimulus,col.stimulus]#					
					new.col<-4		
					newtable[new.row,new.col]<-regular.cues[row.stimulus,c(col.stimulus)+7]
					#Previous Cue Size, is always a regular cue, +7 is due to the stimulus file that has 8 columns that are not needed by now and -1 because we want the previous
					if(newtable[new.row,new.col]==0){
					newtable[new.row,new.col]<-stimulus[new.row,c(col.stimulus)-1]
					}
					new.col<-5
					newtable[new.row,new.col]<-c(col.stimulus)-2
					new.col<-6
					newtable[new.row,new.col]<-touch.lat[row.stimulus,col.stimulus]
					new.col<-7
					if(is.na(left[row.stimulus,col.stimulus])){
						if(sum(is.na(right[row.stimulus,col.stimulus]))==0){ ##changed ==
						newtable[new.row,new.col]<-c("RIGHT")
						new.col<-8
						newtable[new.row,new.col]<-right[row.stimulus,col.stimulus]
						}
					}
					else{
					newtable[new.row,new.col]<-c("LEFT")
					new.col<-8
					newtable[new.row,new.col]<-left[row.stimulus,col.stimulus]
						}		
					new.row<-c(new.row+1)
					}
				}
				col.stimulus<-c(col.stimulus+1)		
			}
			sess.num<-c(sess.num+1)
			row.stimulus<-c(row.stimulus+1)
		}
	}
}
}
newtable<-data.frame(newtable)

names(newtable)<-c("AnimalID","Session","CueSize","PrevCue","Position","TouchLatency","Decision","DecisionLatency")

#Write in the table into a csv file. Also make a csv file that tabulates decision frequencies...
write.table(newtable,file="OrderedData.csv", append = FALSE, sep = ",",eol = "\n", dec = ".", row.names = FALSE,col.names = TRUE)
freq<-xtabs(~AnimalID+CueSize+Decision, data=newtable)
write.table(freq,file="Frequencies.csv", append = FALSE, sep = ",",eol = "\n", dec = ".", row.names = FALSE,col.names = TRUE)
