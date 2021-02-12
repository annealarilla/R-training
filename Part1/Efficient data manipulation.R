#Efficient data manipulation
#from:https://ourcodingclub.github.io/tutorials/data-manip-efficient/index.html

library(dplyr)

#Loading data set
trees<-read.csv("C:/Users/AnneA/Documents/R projects/R-training/Part1/CC-data-manip-2-master/trees.csv", header=TRUE, sep=",")

head(trees)

#Count the number of trees for each species
trees.grouped <- group_by(trees, CommonName)    # create an internal grouping structure, so that the next function acts on groups (here, species) separately. 

trees.summary <- summarise(trees.grouped, count = length(CommonName))   # here we use length to count the number of rows (trees) for each group (species). We could have used any row name.

# Alternatively, dplyr has a tally function that does the counts for you!
trees.summary <- tally(trees.grouped)



# Count the number of trees for each species, with a pipe!

trees.summary <- trees %>%                   # the data frame object that will be passed in the pipe
  group_by(CommonName) %>%    # see how we don't need to name the object, just the grouping variable?
  tally()                     # and we don't need anything at all here, it has been passed through the pipe!

summ.all <- summarise_all(trees, mean) #only the columns with the numeric values will be summarised using the mean function

#case_when()- for reclassifying values or factors
#builds on the ifelse() function

#the ifelse()will evaluate the conditional statement you put
#and return values when the statement is true or false
vector <- c(4, 13, 15, 6)      # create a vector to evaluate

ifelse(vector < 10, "A", "B")  # give the conditions: if inferior to 10, return A, if not return B

#case_when() allows you to assign more than 2 outcomes

vector2 <- c("What am I?", "A", "B", "C", "D")

case_when(vector2 == "What am I?" ~ "I am the walrus",
          vector2 %in% c("A", "B") ~ "goo",
          vector2 == "C" ~ "ga",
          vector2 == "D" ~ "joob")

#you assign new values with ~
#so we can use this to reassign variables





