
library(reshape2)

Dataurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
ZippedData_path <- "./Zipped_Date"
Full_ZippedData_Path <- paste(ZippedData_path, "/", "RawData.zip", sep="")
Data_path <- "./Data"


if (!file.exists(ZippedData_path)){
  dir.create(ZippedData_path)
  download.file(url = Dataurl, dest = Full_ZippedData_Path)
}


if (!file.exists(Data_path)){
  dir.create(Data_path)
  unzip(Full_ZippedData_Path, exdir = Data_path)
}


# Merging Train and Test data:

X_train = read.table(paste(Data_path,"/UCI HAR Dataset/train/X_train.txt",sep = ""))
Y_train = read.table(paste(Data_path,"/UCI HAR Dataset/train/Y_train.txt",sep = ""))
subject_train = read.table(paste(Data_path,"/UCI HAR Dataset/train/subject_train.txt",sep = ""))


X_test = read.table(paste(Data_path,"/UCI HAR Dataset/test/X_test.txt",sep = ""))
Y_test = read.table(paste(Data_path,"/UCI HAR Dataset/test/Y_test.txt",sep = ""))
subject_test = read.table(paste(Data_path,"/UCI HAR Dataset/test/subject_test.txt",sep = ""))

X_Merged = rbind(X_train, X_test)
Y_Merged = rbind(Y_train, Y_test)
subject_Merged = rbind(subject_train, subject_test)

#loading feature & activity data

# feature info
feature <- read.table(paste(sep = "", Data_path, "/UCI HAR Dataset/features.txt"))

# activity labels
a_label <- read.table(paste(sep = "", Data_path, "/UCI HAR Dataset/activity_labels.txt"))
a_label[,2] <- as.character(a_label[,2])

# extract feature & names  'mean, std'
selectedCols <- grep("-(mean|std).*", as.character(feature[,2]))

selectedColNames <- feature[selectedCols, 2]
selectedColNames <- gsub("[-()]", "", selectedColNames)

X_Merged <- X_Merged[selectedColNames]
X_Merged <- X_Merged[selectedCols]
allData <- cbind(subject_Merged, Y_Merged, X_Merged)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2])
allData$Subject <- as.factor(allData$Subject)


# generate tidy data
melt_id <- c("Subject", "Activity")
meltedData <- melt(allData, id = melt_id)
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)
nam

write.table(tidyData, "./Tidy_Data.txt")
