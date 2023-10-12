##### Section 1: what are functions & how to read in data

library(tidyverse) #loading the tidyverse package

#the next line reads in the gapminder_1997.csv file
gapminder_1997 <- read_csv("gapminder_1997.csv")
#read.csv()
Sys.Date() #prints date & time
getwd() #prints current working directory
sum(5,6)

?round
round(3.1415,3)

#Which of these lines give you an output of 3.14? Answer: B&C
   #because round rounds the values in its first argument to 
   #the specified number of decimal places (default 0). 
#A
round(x = 3.1415)
#B
round(x = 3.145, digits = 2)
#C
round(digits = 2, x = 3.1415)
#D
round(2, 3.1415)


result <- 2+2
result

name <- "Sarah"
name

name <- "Maisie"
name

number1 <- 3
favorite_number <- 1


##### Section 2: discussing plotting (ggplot2 most common)
ggplot(data = gapminder_1997) +
  aes(x = gdpPercap, 
      y = lifeExp, 
      color = continent,
      size = pop/1000000) +
  labs(x = "GDP per capita", 
       y = "Life Expectancy",
       title = "Do people in wealthy countries live longer?",
       size = "Population (in millions)") +
  geom_point() +     #plots data
#now add plot features explore addtl relationships:
#      color by continent, unique color for each continent, &
#      specific palette selected
    scale_color_brewer(palette = "Set2")  



