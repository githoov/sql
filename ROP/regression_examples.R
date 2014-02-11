# read in libraries #
library(ggplot2)
library(Rcmdr)

# parameterize model #
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

# create dataframe # 
df <- data.frame(y, x1, x2)

# visualize data #
dev.new(width=6.5, height=6.5)
ggplot(df, aes(x=x1, y=y)) + geom_point() + xlab('Age') + ylab('Average Order Amount') + ggtitle('Order Amount as a Function of Age')

p + geom_abline(intercept=28, slope=1.55, color="red")

p + geom_abline(intercept=28, slope=1.55, color="red") + geom_segment(aes(x=47.1, y=75, xend=47.1, yend=101), size=0.1) + geom_segment(aes(x=45.485, y=98.5, xend=45.485, yend=112), size=0.1) + geom_text(aes(x=47.7, y=87, label="epsilon"), parse=TRUE, size=4.4) + geom_text(aes(x=46, y=106, label="epsilon"), parse=TRUE, size=4.4)

# MULTIVARIATE MODEL #

set.seed(1)
true.intercept <- -100
true.x1.slope <- 0.0025
true.x2.slope <- 0.003
true.err.var <- 10
n.iter <- 1000
s.sample <- 100
estimates <- matrix(NA, nrow=n.iter, ncol=2) 

# simulate x1, x2, and y variables #
s.sample <- 100
x1 <- rnorm(s.sample, 35, 8) 
x2 <- rnorm(s.sample, 50000, 8000)

for(i in 1:n.iter) {
y <- true.intercept + true.x1.slope*x1 + true.x2.slope*x2 + rnorm(s.sample, mean=0, sd=true.err.var)
}

# create dataframe # 
df <- data.frame(y, x1, x2)

dev.new(width=6.5, height=6.5)
ggplot(df, aes(x=x2, y=y)) + geom_point() + xlab('Age') + ylab('Average Order Amount') + ggtitle('Order Amount as a Function of Age')

scatter3d(y, x1, x2, ylab="Average Order Amount", xlab="Age", zlab="Income")


z <- seq(1,1000,1)
x <- z
y <- x^2 + z^2
scatter3d(y,x,z)

curve3D <- function(f, from.x, to.x, from.y, to.y, n = 101)
{
	x.seq <- seq(from.x, to.x, (to.x - from.x) / n)
	y.seq <- seq(from.y, to.y, (to.y - from.y) / n)
	eval.points <- expand.grid(x.seq, y.seq)
	names(eval.points) <- c('x', 'y')
	eval.points <- transform(eval.points, z = apply(eval.points, 1, function (r) {f(r['x'], r['y'])}))
	p <- ggplot(eval.points, aes(x = x, y = y, fill = z)) + geom_tile()
	print(p)
}

y <- function(x, z){x^2 + z^2}
curve3D(y,-1,1,-1,1)

g <- function(x, y) {(1 + y * 2) ^ (-x / y) * (1 + y * 1) ^ (x / y)}
library(scatterplot3d)
z <- seq(-10, 10, 0.01)
x <- cos(z)
y <- sin(z)
scatterplot3d(x, y, z, highlight.3d = TRUE, col.axis = "blue",
col.grid = "lightblue", main = "Helix", pch = 20)
