# R is a object-oriented, vector-based statistical programming language
# it relies largely on base functions, user-defined functions, and packages
require(rjson)
require(ggplot2)
require(stringr)

# concatenate the numbers 1 through 5 to crete a vector, defaults to numeric
x <- c(1,2,3,4,5)	
print(x); class(x)

# create a sequence of integers 1 through 5
x <- 1:5	
print(x); class(x)

# create a sequence of integers 1 through 5
x <- seq(1,5)	
print(x); class(x)

# seq() function can also create numeric data if you specify the increment
x <- seq(1,5,0.5)	
print(x); class(x)

# boolean can be declared or can be the result of a true-false operation
x==1	
is.na(x)

# we can do va
sum(x!=1)

# create a matrix
X <- matrix(c(1:9), ncol=3, byrow=T)	
print(X); class(X)

# matrix functions are also available in the base library
t(X)%*%X	

# various vector functions also work on matrices
sqrt(X)		

# an array is a matrix in higher dimensions
X.array <- array(1:27, c(3,3,3))
print(X.array)	

# a data frame is analagous to a table.
# it is comprised of a number of vectors

# using a built-in function to read in a csv data frame
df <- data.frame(rnorm(1000), runif(1000), rexp(1000))
names(df) <- c("Normal", "Uniform", "Exponential")
names(df)
dim(df)
head(df)

# summary statistics
summary(df$Normal)
summary(df$Uniform)
summary(df$Exponential)

# a list is a data structure whose elements 
# can be any data type that shows
# up in R: vector, data frame, matrix, etc.
my.list <- list(x, head(df), X)
print(my.list)
print(my.list[[1]])
print(my.list[[3]])
my.list[[2]] == head(df)

# user-defined functions are relatively straightforward
# there's no need to declare a class, etc.
growth <- function(data=data){
	x <- c()										# create empty vector
	for(i in 1:length(data)){						# begin for loop
		x[i] <- (data[i+1] - data[i])/data[i]		# calculate percent change
	}
	return(x)
}

# R can also handle other data storage types, such as JSON
json_data <- fromJSON(paste(readLines("~/Downloads/jsonCrunch.json"), collapse=""))
json.df <- data.frame(matrix(unlist(json_data), ncol=9, byrow=TRUE))

# R makes regression analysis quite simple

# parameterize bivariate model #
set.seed(21)
true.intercept <- 30
true.x1.slope <- 1.5
true.x2.slope <- 0.04
true.err.var <- 13
n.iter <- 1000
s.sample <- 100
estimates <- matrix(NA, nrow=n.iter, ncol=2) 

# simulate x1, x2, and y variables #
s.sample <- 100
x1 <- rnorm(s.sample, 35, 8) 
x2 <- 3 + sqrt(runif(s.sample))

for(i in 1:n.iter) {
	y <- true.intercept + true.x1.slope*x1 + true.x2.slope*x2 + rnorm(s.sample, mean=0, sd=true.err.var)
}

# create and visualize dataframe # 
df <- data.frame(y, x1, x2)
plot(df)
qplot(x1, y, data=df) + stat_smooth(method="lm") + xlab("Income (thousands of dollars)") + ylab("Average Order Amount (dollars)")

# simple linear regression #
summary(lm(y ~ x1, data=df))

# R can also handle NLP. It has a strong set of base functions
# and packages dedicated to text processing. R also has Perl-like 
# regular expression capabilities as an extension
library(stringr)
x <- c("Analytics", "Engineering", "Sales", "Marketing", "Legal")
grep(".*e{2,}.*", x, value=FALSE)			# returns the element in which the pattern is matched
grep(".*e{2,}.*", x, value=TRUE)			# return the result of matched cases, else NA
gsub(".*e{2,}.*", "booYa!", x)				# replace the matched case with alternative string
str_extract(x, "e[A-Za-z]")					# return the exact matched pattern, not the entire string in which match occurs 

# standard control flow is 
# create vector of 2000 random numbers to be sorted
set.seed(111)
x <- sample(seq(1:6000), 2000)

insertSort <- function(x){				# insertion sort algorithm
for(j in 1:length(x)){
	key = x[j]
	i = j - 1
	while(i > 0 && x[i] > key){
		x[i + 1] = x[i]
		i = i - 1
	}
	x[i + 1] = key
}
return(x)
}
system.time(insertSort(x))		# time user-defined function
system.time(sort(x))			# R's base function clearly doesn't use the insertion sort algorithm