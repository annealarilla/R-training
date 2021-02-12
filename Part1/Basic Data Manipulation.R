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
install.packages("dplyr")  # install the package
library(dplyr)              # load the package

#Rename variables 
elongation_long <- rename(elongation_long, zone = Zone, indiv = Indiv, year = Year, length = Length)     # changes the names of the columns (getting rid of capital letters) and overwriting our data frame

#Filter and subset columns

elong_subset <- filter(elongation_long, zone %in% c(2, 3), year %in% c("X2009", "X2010", "X2011")) # you can use multiple different conditions separated by commas

elong_no.zone <- dplyr::select(elongation_long, -zone)

# A nice hack! select() lets you rename and reorder columns on the fly
elong_no.zone <- dplyr::select(elongation_long, Year = year, Shrub.ID = indiv, Growth = length)

#Mutate creates new columns

# CREATE A NEW COLUMN 

elong_total <- mutate(elongation, total.growth = X2007 + X2008 + X2009 + X2010 + X2011 + X2012)

#group_by() certain factors to perform operations on chunks

# GROUP DATA

elong_grouped <- group_by(elongation_long, indiv)   # grouping our dataset by individual

#summarise () data with rance of summary statistics

# SUMMARISING OUR DATA

summary1 <- summarise(elongation_long, total.growth = sum(length))
summary2 <- summarise(elong_grouped, total.growth = sum(length))

summary3 <- summarise(elong_grouped, total.growth = sum(length),
                      mean.growth = mean(length),
                      sd.growth = sd(length))
#we lose all the other columns in doing this so 
#may need to merge after this

#join () data sets based on shared attributes
#there are many types of joins you can perform
#full_join() will keep everything
#left_join() keeping everything on the left and only adding what corresponds
#with the left from the right


# Load the treatments associated with each individual

treatments <- read.csv("C:/Users/AnneA/Documents/R projects/R-training/Part1/CC-3-DataManip-master/EmpetrumTreatments.csv", header = TRUE, sep = ";")
head(treatments)

# Join the two data frames by ID code. The column names are spelled differently, so we need to tell the function which columns represent a match. We have two columns that contain the same information in both datasets: zone and individual ID.

experiment <- left_join(elongation_long, treatments, by = c("indiv" = "Indiv", "zone" = "Zone"))

# We see that the new object has the same length as our first data frame, which is what we want. And the treatments corresponding to each plant have been added!

experiment2 <- merge(elongation_long, treatments, by.x = c("zone", "indiv"), by.y = c("Zone", "Indiv"))  
# same result!

#Challenge yourself

#load dragons csv

dragons <- read.csv("C:/Users/AnneA/Documents/R projects/R-training/Part1/CC-3-DataManip-master/dragons.csv", header = TRUE, sep = ",")
head(dragons)

#make the data tidy (long format)

dragons_long<- tidyr::gather(dragons, Spices, Length, c(3:6))

#create a boxplot for each species showing the effect
#of the spices on plume size

boxplot(Length ~ Spices, data = dragons_long, 
        xlab = "Spices", ylab = "Plume Length (cm)", 
        main = "Plume Length by Spices")

#Jalapeno triggered the most fiery reaction

#change the fourth treatment from paprika to turmeric

dragons_long[dragons_long$Spices=="paprika",3]<-"turmeric"

###can also do this

dragons_long <- rename(dragons_long, turmeric = paprika)


#There was a calibration error with the measuring device for 
#the tabasco trial, but only for the Hungarian Horntail species. 
#All measurements are 30 cm higher than they should be

dragons_long[dragons_long$species=="hungarian_horntail"&& dragons_long$Spices=="tabasco",4]<-dragons_long$Length-30

##can also do this
# Fix the calibration error for tabasco by horntail
#but this is before the data is in the long format


correct.values  <- dragons$tabasco[dragons$species == 'hungarian_horntail'] - 30   # create a vector of corrected values

dragons[dragons$species == 'hungarian_horntail', 'tabasco'] <- correct.values      # overwrite the values in the dragons object


#Converting the Length cm into m

dragons_long$LM<-dragons_long$Length*0.01

#Other way to do it 
# Convert the data into meters

dragons_long <- mutate(dragons_long, LM= Length/100)    # Creating a new column turning cm into m

#creating the box plots of spices but first
#filtering by the dragon type to create seperate box plots

d1<-filter(dragons_long, species=="hungarian_horntail")
d2<-filter(dragons_long, species== "welsh_green")
d3<- filter(dragons_long, species=="swedish_shortsnout")

# Make the boxplots

par(mfrow=c(1, 3))     
# you need not have used this, but it splits 
#3 columns where the plots will appear, so all the plots will be side by side.

boxplot(LM ~ Spices, data = d1,
        xlab = 'Spice', ylab = 'Length of fire plume (m)',
        main = 'Hungarian Horntail')

boxplot(LM ~ Spices, data = d2,
        xlab = 'Spice', ylab = 'Length of fire plume (m)',
        main = 'Welsh Green')

boxplot(LM ~ Spices, data = d3,
        xlab = 'Spice', ylab = 'Length of fire plume (m)',
        main = 'Swedish Shortsnout')

