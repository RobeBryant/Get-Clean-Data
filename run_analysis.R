#Load Data
activlabels <- read.table("activity_labels.txt")
features <- read.table("features.txt")
testsubj <- read.table("test\\subject_test.txt")
testdata <- read.table("test\\X_test.txt")
testactiv <- read.table("test\\y_test.txt")
trainsubj <- read.table("train\\subject_train.txt")
traindata <- read.table("train\\X_train.txt")
trainactiv <- read.table("train\\y_train.txt")
#Merge training and test sets to create one dataset
testdatalbl <- cbind(testsubj, testactiv, testdata)
traindatalbl <- cbind(trainsubj, trainactiv, traindata)
alldata <- rbind(testdatalbl, traindatalbl)
names(alldata)[1] <- "individual"
names(alldata)[2] <- "activityno"
names(alldata)[3:563] <- as.character(features$V2)
#Extract only measurements on mean and std deviation
meanstdcolumns <- append(c(1,2),grep("(.*)[Mm]ean|std(.*)", names(alldata)))
meanstddata <- alldata[,meanstdcolumns]
#Use descriptive activity names to name the activities
library("dplyr", lib.loc="~/R/win-library/3.3")
meanstddatalbl <- inner_join(meanstddata, activlabels, by = c("activityno" = "V1"))
names(meanstddatalbl)[89] <- "activity"
meanstddatalbl <- meanstddatalbl[,c(1,2,89,3:88)]
#Label the data set with descriptive variable names
names(meanstddatalbl) <- sub("tBodyAcc", "bodyacceleration(time)", names(meanstddatalbl))
names(meanstddatalbl) <- sub("tGravityAcc", "gravityacceleration(time)", names(meanstddatalbl))
names(meanstddatalbl) <- sub("tBodyGyro", "angularvelocity(time)", names(meanstddatalbl))
names(meanstddatalbl) <- sub("fBodyAcc", "bodyacceleration(freq)", names(meanstddatalbl))
names(meanstddatalbl) <- sub("fBodyGyro", "angularvelocity(freq)", names(meanstddatalbl))
names(meanstddatalbl) <- sub("fBodyBodyAcc", "bodyacceleration(freq)", names(meanstddatalbl))
names(meanstddatalbl) <- sub("fBodyBodyGyro", "angularvelocity(freq)", names(meanstddatalbl))
names(meanstddatalbl) <- sub("\\()", "", names(meanstddatalbl))
#create independent tidy dataset with avg of each variable for each activity and subject
finaldata <- aggregate(meanstddatalbl[,4:89], by=list(meanstddatalbl$individual, meanstddatalbl$activity), FUN=mean, na.rm=TRUE)
names(finaldata)[1] <- "individual"
names(finaldata)[2] <- "activity"
write.table(finaldata, "FinalData.txt", row.name=FALSE)