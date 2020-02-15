library(rggobi)
g <- ggobi(mydata)
# Install iplots
install.packages("iplots",dep=TRUE)

# Create some linked plots
library(iplots)
cyl.f <- factor(mtcars$cyl)
gear.f <- factor(mtcars$factor)
attach(mtcars)
iplot(mpg, wt) # scatter plot
# Interacting with a scatterplot
attach(mydata)
plot(x, y) # scatterplot
identify(x, y, labels=row.names(mydata)) # identify points
coords <- locator(type="l") # add lines
coords # display list