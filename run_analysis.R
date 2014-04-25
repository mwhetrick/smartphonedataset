#read test data
x.test <- read.table("UCI/test/X_test.txt")

#attach column names
f.names <- read.table("UCI/features.txt")
colnames(x.test) <- f.names[,2]

#read/bind subject and activity
y.test <- read.table("UCI/test/y_test.txt")
subj.test <- read.table("UCI/test/subject_test.txt")
test <- cbind(subj.test, y.test, x.test)
colnames(test)[1] <- "Subject"
colnames(test)[2] <- "Activity"

#read train data
x.train <- read.table("UCI/train/X_train.txt")
colnames(x.train) <- f.names[,2]

#read/bind subject and activity
y.train <- read.table("UCI/train/y_train.txt")
subj.train <- read.table("UCI/train/subject_train.txt")
train <- cbind(subj.train, y.train, x.train)
colnames(train)[1] = "Subject"
colnames(train)[2] = "Activity"

#merge train and test
total <- rbind(train, test)

#keep only mean and standard deviation column names with "mean()" and "std()"
col.index.mean <- grep("mean()", names(total))
col.index.std <- grep("std()", names(total))
total <- cbind(total[,1], total[,2], total[col.index.mean], total[col.index.std])
colnames(total)[1] = "Subject"
colnames(total)[2] = "Activity"

#factor activity index to activity names
activity.labels <- read.table(file = "UCI/activity_labels.txt")
factor.labels <- activity.labels[,2]
total$ActivityName <- factor(total$Activity, labels = factor.labels)
col.index <- grep("ActivityName", names(total))
total <- total[, c(1, col.index, (4:ncol(total)-1))]

#calculate means by activity by subject
total.melt <- melt(total,id.vars=c("Subject","ActivityName"),measure.vars=c(3:ncol(total)))
total.means <- dcast(total.melt, Subject+ActivityName~variable, mean)
