
library(tidyverse)


# Read in data (make sure read_cs, not read.csv!)

gapminder_data <- read_csv("data/gapminder_data.csv")


# Summarize ---------------------------------------------------------------

#   this reports a result only in console
summarize(gapminder_data, averagelifeExp = mean(lifeExp))

#   this saves the result as object in enviro (it exists, but doesn't SHOW us result)
gapminder_data_summarized <- gapminder_data %>%  #saves obj
  summarize(averagelifeExp = mean(lifeExp)) 
gapminder_data_summarized    #prints, meaning SHOWS the result on console

# What is the mean life exp for the most recent year
#  (1): find most recent year, where max aka highest value
#   of var
#  (2): mean lifeExp of that year

gapminder_data %>%
  summarize(recent_year = max(year))

# 2 ways to get mean lifeExp:

#   A: use filter
gapminder_data %>%
  filter(year == 2007) %>%  #would use quotes for value if str
  summarize(average = mean(lifeExp))

# another ex: sum avg GDP for the earliest year in the dataset
gapminder_data %>% 
  summarize(earliest_year = min(year))

gapminder_data %>%
  filter(year == 1952) %>%  #would use quotes for value if str
  summarize(average_gdp = mean(gdpPercap))


#   B: grouping: result for each of something

# note: embed functions by creating obj of earliest_year?

# gapminder_data %>% 
#  summarize(earliest_year = min(year))
#  summarize(avg_firstyr_lifeExp = mean(1952))
#      -- this didn't work bc "earliest_year" isn't obj yet,
#         this was naming.  Would need "<-"



# Grouping ----------------------------------------------------------------

gapminder_data %>% 
  group_by(year) %>% 
  summarize(average = mean(lifeExp)) #table: year and avg

gapminder_data %>% 
  group_by(year, country) %>% 
  summarize(average = mean(lifeExp)) #table: reports all values 

# Exercise: what is the mean LE for each continent
gapminder_data %>% 
  group_by(continent) %>% 
  summarize(average = mean(lifeExp)) #table: year and avg

#  doesn't make sense for continent, but how report diff val
#   of variable itself like continent? add missing report?
#  missing might be something w/ null, according to help notes


# to report by 2 or 3 var (e.g. )
gapminder_data %>% 
  group_by(continent) %>% 
  summarize(
    meanlifeExp = mean(lifeExp),
    maxlifeExp = max(lifeExp),
    meangdpPercap = mean(gdpPercap)
  )



# Mutate ------------------------------------------------------------------
#   this summarizes across col

gapminder_data %>% 
  mutate(double_year = year * 2, .before = pop)  
# note this has a single "=", bc creating obj
# this places obj column before existing column pop, instead of end

# exercise: what is GDP (not per capita)?
#  multiple pop X gdpPercap

gapminder_data %>% 
  mutate(gdp = pop * gdpPercap)

# exercise: new col for pop in millions
gapminder_data %>% 
  mutate(popInMillions = pop / 1000000)  #note, col added to end,
#  since no ".before" command

# add 2 new col
gapminder_data %>% 
  mutate(
    gdp = pop * gdpPercap,
    popInMillions = pop / 1000000
    )       

# to rotate view so results fit in console better, add:
#  ) %>% 
#  glimpse()

gapminder_data %>%
  filter(continent == "Asia") %>% 
  mutate(gdp = pop * gdpPercap) %>% 
  summarize(meanGDP = mean(gdp))  #will get 1 result unless have grps
    #to get by var, add group_by BEFORE sum

mysummary <- gapminder_data %>%   #to save results as obj to use further
  filter(continent == "Asia") %>% 
  mutate(gdp = pop * gdpPercap) %>% 
  group_by(country) %>% 
  summarize(meanGDP = mean(gdp))  

#to see those results another time:
mysummary
view(mysummary) #creates new pane to view

#do more w/ this now
mysummary %>% 
  mutate(meanGDPinMillions = meanGDP / 1000000)
#to save this new result, overwrite existing mysummary with
# "my summary <- my summary %>%" at beginning
#do this when don't need intermediate result, just want it so modify further

#country  #still dk how to sum actual orig var, just new obj we created



# Select ------------------------------------------------------------------
#   keep a subset of columns from a dataset

gapminder_data %>% 
  select(pop, year)

gapminder_data %>% 
  select(-continent)

#exercise: create tibble w/ only country, continent
gapminder_data %>% 
  select(country, continent)


#### yay! to see the orig var in gapminder dataset:
gapminder_data %>% 
  distinct(continent)

gapminder_data %>% 
  count(continent)

gapminder_data %>% 
  filter(is.na(country))    #tibble reports 0 x 6, which means this dataset
#  has 0 missing val for all var.  Would report otherwise


# for wildcat situations, need to use tidyverse while using select 
#   when we want to only look among col
#   where as filter() looked among data val
#     this helper function is "starts_with()"

gapminder_data %>% 
  select(year, starts_with("c"))

#exercise: select col w/ names ending in "p"
#   can use "ends_with()" here

gapminder_data %>% 
  select(ends_with("p"))

#report year alongside
gapminder_data %>% 
  select(year, ends_with("p"))



# Reshaping ---------------------------------------------------------------

gapminder_data %>% 
  select(country, continent, year, lifeExp) 
# reports each value, which may use for data analysis work (1704 obs)
# but reports need to look diff

# reshaping: make long data & make it wide, or wide -> long
#    functions: pivot_wider(), pivot_longer()
# pivot_longer example:
#  ex. from 
#  country continent year lifeExp columns, TO
#  country continent 1952 1957  
#                    28.801
#                    29.2  (LE as row, now the val)
#  note she's calling year & 1952... as NAMES FROM,
#  28.801... as VALUES FROM
#    (can review help guide on pivot_longer to review opposite-thinking
#     decision-making, with NAMES & VALUES in notation)

# pick discrete categorical val for row (don't have great choices here)

gapminder_data %>% 
  select(country, continent, year, lifeExp) %>%
  pivot_wider(names_from = year, values_from = lifeExp)
#   notes we get `YEARVALUE` ticks bc R doesn't like col to start w #
#   to refer to it further, would need to use exactly as (with ``)

# ?pivot_wider tells us about names_prefix
#   so to get rid of ``:
gapminder_data %>% 
  select(country, continent, year, lifeExp) %>%
  pivot_wider(names_from = year, 
              values_from = lifeExp,
              names_prefix = "yr")  #values are now e.g. "yr1952"

#could save as new obj (new dataset) by putting before gapminder_data %>% :
# widedata <-

#note we got rid of GDP bc where would it go
# commonly use select before pivot to keep only what want



# Joins -------------------------------------------------------------------

#   to visualize: let's say data is,
#    year country pop gdpPercap
#    1952 Afghanistan # #
#    ....

#   another dataset is,
#    year countries CO2  (has some of the same col, some are not)
#    1952 Afghanistan #
#    ...
#      *note that there's 2 country col, even if named diff

# first dataset you're already using is #1, or the L one
#   function: use left_join(dataframe1, dataframe2)
#   for this join, L is important one, only want to extract CO2 values for
#    years & countries that we have from new dataset

#  if col are named differently, can do:
#     left_join(dataframe1, dataframe2, by = ("country" = "countries"))

# let's read in new data to get CO2 data to follow this ex
co2_data <- read_csv("data/co2-un-data.csv", skip = 1) %>% 
  rename(countries = `2`)
#skip deleted the first row so we can read in row 2 (which has var) as col names
#here, 1st relevant col is named "Region/Country/Area", w numeric values
#   e.g. 8=Albania, a country; 12=Algeria, a country; #=Australia...
#vaules in 2nd relevant col are those names, no col name
#  looks like want all the values, some just aren't ex. country

#  case where want to keep only countries out of regions:
#     rename(countries = `2`)     #her first try
#         not sure yet, prob need select + pivot?


joined <- left_join(gapminder_data, co2_data, by = )



