# 1. Merges the training and the test sets to create one data set.

# grab activity metrics and labels
features <- read.table("features.txt")
features <- features$V2
activity_label <- read.table("activity_labels.txt")
activity_label <- activity_label$V2

# gather test and training data
test_subjects <- read.table("test/subject_test.txt")
test_X <- read.table("test/X_test.txt")
test_Y <- read.table("test/Y_test.txt")
train_subjects <- read.table("train/subject_train.txt")
train_X <- read.table("train/X_train.txt")
train_Y <- read.table("train/Y_train.txt")

# 4. Appropriately labels the data set with descriptive variable names. 
# Although this is step 4, this needs to be done here in order to fulfill step 2
names(train_X) <- features
names(train_Y) <- "activity_id"
names(train_subjects) <- "subject_id"
names(test_X) = features
names(test_Y) <- "activity_id"
names(test_subjects) <- "subject_id"

# bind columns for subject_id and activity_label for test and training
final_training <- cbind(train_subjects, train_Y, train_X)
final_test <- cbind(test_subjects, test_Y, test_X)

# bind rows for test and training into one data frame
stage_data <- rbind(final_training, final_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement
match_terms <- c("std", "mean")
matches <- unique (grep(paste(match_terms,collapse="|"), features, value=TRUE))
stdmean_data <- stage_data[,matches]

# Let's create a final dataset that includes stdmean_data and our
# subject_id and activity_id
final_data <- stdmean_data
final_data$subject_id <- stage_data$subject_id
final_data$activity_id <- stage_data$activity_id

# 3. Uses descriptive activity names to name the activities in the data set
final_data$activity <- activity_label[final_data$activity_id]

# Step 4 completed before step 2 (see above)

# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
#
# For grouping purposes, let's remove activity_id (we already have activity)
# Per the instructions, we're grouping by 2 dimensions -> subject_id and activity
final_data$activity_id <- NULL
tidy_data <- aggregate(.~subject_id+activity, final_data, mean)

# Uncomment to write the tidy_data.txt file
# write.table(tidy_data, file="tidy_data.txt", row.name=FALSE)

# Per the assignment -> The output should be the tidy data set you submitted for part 1
tidy_data
