#Basic Data Manipulation training
#From https://ourcodingclub.github.io/tutorials/data-manip-intro/
#Data is obtained from https://github.com/ourcodingclub/CC-3-DataManip and downloaded as a zip file

#Loading the elongation data
elongation <- read.csv("C:/Users/AnneA/Documents/R projects/R-training/Part1/CC-3-DataManip-master/EmpetrumElongation.csv") 

#Check import and preview data
head(elongation) #displays the first 6 variables 
str(elongation) #shows the col names and types of variables

elongation$Indiv   # prints out all the ID codes in the dataset
length(unique(elongation$Indiv))   # returns the number of distinct shrubs in the data

#[row,column]

# Here's how we get the value in the second row and fifth column
elongation[2,5]

# Here's how we get all the info for row number 6
elongation[6, ]

# And of course you can mix it all together! 
elongation[6, ]$Indiv   # returns the value in the column Indiv for the sixth observation
# (much easier calling columns by their names than figuring out where they are!

#You can also subet data using logical operators

# Let's access the values for Individual number 603
elongation[elongation$Indiv == 603, ]

# Subsetting with two conditions
elongation[elongation$Zone == 2 | elongation$Zone == 7, ]    # returns only data for zones 2 and 7
elongation[elongation$Zone == 2 & elongation$Indiv %in% c(300:400), ]    # returns data for shrubs in zone 2 whose ID numbers are between 300 and 400

#Other useful vector sequence are:

x<-seq(200,500,20) #This creates a sequence, incrementing by any specified amount
x2<-rep(c(1,2),3) #This creates repetition of elements
#can also combine these sequences
x3<-rep(seq(2,5,1),3)

#can change variable names 
elong2<-elongation

#to change the 1st column you can do this
names(elong2)[1]<-"zone" #changing from Zone to zone
names(elong2)[2:3]<-c("ID","Col3")#can change multiple columns at a time

#Creating a factor for statistical models
elong2$zone<-as.factor(elong2$zone)

#Changing factor levels
levels(elong2$zone)#To check the factor levels
levels(elong2$zone) <- c("A", "B", "C", "D", "E", "F")   # you can overwrite the original levels with new names

#How to tidy data

install.packages("tidyr")  # install the package
library(tidyr)             # load the package


elongation_long <- gather(elongation, Year, Length,                           # in this order: data frame, key, value
                          c(X2007, X2008, X2009, X2010, X2011, X2012))        # we need to specify which columns to gather

# Here we want the lengths (value) to be gathered by year (key) 

# Let's reverse! spread() is the inverse function, allowing you to go from long to wide format
elongation_wide <- spread(elongation_long, Year, Length) 

#Can also specify column headers
elongation_long2 <- gather(elongation, Year, Length, c(3:8))

#having the long format makes it easier to visualise the data

boxplot(Length ~ Year, data = elongation_long, 
        xlab = "Year", ylab = "Elongation (cm)", 
        main = "Annual growth of Empetrum hermaphroditum")

#Most common and useful functions of dplyr

