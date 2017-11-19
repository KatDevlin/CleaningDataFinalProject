# Four objectives for this script:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names.

# Merges the X training and X test sets into one dataset.
# Training Data
setwd("~/Documents/Docs/Coursera/DataCleaning/ProjectDataset/train")
xtrain <- read.table("X_train.txt")
setwd("~/Documents/Docs/Coursera/DataCleaning/ProjectDataset/test")
xtest <- read.table("X_test.txt")

X <- rbind(xtrain, xtest) 
# Before I bind together the rest of the pieces I want to change labels 
# and subset further. Part 1 almost complete.

# Now let's subset the cols to include only the mean and std dev variables
# Use the feature.txt file to create the column index
setwd("~/Documents/Docs/Coursera/DataCleaning/ProjectDataset")
feature <- read.table("features.txt")

match1 <- grepl("mean", feature$V2)
match2 <- grepl("std", feature$V2)
colnum <- which(match1 | match2)

full <- X[,colnum] # subsetted dataframe
## Part 2 complete.

# Now we can put together the y test/train and subject test/train data 
setwd("~/Documents/Docs/Coursera/DataCleaning/ProjectDataset/train")
ytrain <- read.table("y_train.txt")
subtrain <- read.table("subject_train.txt")
setwd("~/Documents/Docs/Coursera/DataCleaning/ProjectDataset/test")
ytest <- read.table("y_test.txt")
subtest <- read.table("subject_test.txt")
Y <- rbind(ytrain, ytest)
SUB <- rbind(subtrain, subtest)
# And add those to the full dataset
full <- cbind(Y, full)
full <- cbind(SUB, full)
# Now we have all the correct columns in the correct order. Part 1 complete.

# Now I want to rename the first two columns since binding created redundancies.
colnames(full)[1:2] <- c("subject", "activity")
# Rename the activity variable with descriptive names. I want to keep the underlying 
# numeric values to make later analysis easier, so I opt to make this a factor with
# the activity names as labels. Best of both worlds.

full$activity <- factor(full$activity, levels = c(1:6),
                        labels = c("walking", "walking_upstairs", "walking_downstairs", 
                                   "sitting", "standing", "laying"))
## Part 3 complete.

# Now I need to add variable names to the rest of the variables. Since these 
# variables represent data that is fairly complicated for the average consumer,
# I am going to retain the original names (in the features.txt document) and 
# use the codebook to explain what they actually mean. I fear that changing the 
# names will actually make them less descriptive and more confusing to tell apart.

feature2 <- feature[colnum,]
varlist <- as.list(as.character(feature2$V2))
colnames(full)[3:81] <- c(varlist) 

# All variables labeled. Now we can write the dataframe into a new file.

write.table(full, file = "FinalFullDataset.txt", row.name=FALSE)

## Part 4 complete. End of script.
