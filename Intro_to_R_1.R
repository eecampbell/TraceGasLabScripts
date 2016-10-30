#R Script paired with Introduction to R
#series for the Trace Gas Biogeochem Lab
#Last updated 10/30/2016
#created by Nell Campbell

#clear workspace
rm(list=ls())

#Set working directory
setwd("C:/Users/Tom/Documents/GitHub/RScriptsLab")

#For intro to Rstudio: load workspace
#load("C:\\Users\\Tom\\Documents\\GitHub\\RScriptsLab\\.RData")

#Part 1- Introduction to data objects

#####SCALAR
#scalar is a single piece of information
ex_num_scalar<- 3
ex_char_scalar<- "hello"

#check scalar objects
ex_num_scalar
ex_char_scalar

#####VECTOR
#vector is a list of information (e.g. single row or single column)
# 'c' concatenates information separated by commas in parentheses
#use "" for character strings (e.g. words, IDs)
ex_num_vector<- c(3,5,7,19,22)
ex_char_vector<- c("hello","there","world")

#check vector objects
ex_num_vector
ex_char_vector

#information in vector can be referenced by location in list
ex_num_vector[3] #prints value 7
ex_char_vector[c(1,3)] #calls 1st and 3rd place in vector, printing "hello" "world"

#####MATRIX
#references to matrix cells is ordered: rows, columns
#matrices must have all of the same type of data, e.g. 'numeric', or 'character'

#step one, create a matrix of 2 rows and 12 columns, filled with the value '0'
ex_matrix<- matrix(0, nrow=2, ncol=12)

#check matrix object
ex_matrix

#step two, fill the first row with a sequence of values from 1 to the value of the
#total number of columns (in this case, ncol(ex_matrix)=12)

#check sequence function is set up correctly
#seq(from=start of sequence, to=end of sequence, by=units of sequence) 
seq(from=1,to=ncol(ex_matrix), by=1)

#fill in the first row of the matrix with these values
ex_matrix[1,]<- seq(from=1,to=ncol(ex_matrix), by=1)

#check matrix object
ex_matrix

#let's fill the second row with randomly selected values
#from a normal distribution, one for each column

#we'll use the rnorm function, which looks like:
#rnorm(x=number of points, mean=mean of points, sd=standard deviation of points) 
#first, check that the function is set up properly
rnorm(n=ncol(ex_matrix), mean=3, sd=.5)

#now, fill in second row of matrix
ex_matrix[2,]<-rnorm(n=ncol(ex_matrix), mean=3, sd=.5)

#check matrix object
ex_matrix

#plot results
#the plot function works with the minimum of x and y values: plot(x=x values, y=y values)
#but plotting is flexible. Here I want the type to be line, and the line to be red
plot(x=ex_matrix[1,], y=ex_matrix[2,], typ="l", col="red")


