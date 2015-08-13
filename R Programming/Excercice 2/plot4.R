# For this to work, just put the file household_power_consumption.txt on
# the same directory as this script, and hit "source"...
#
# On this exercise, I tried to make something more meaningfull to analyse the Emissions across US. For this,
# I've calculated  the total emissions per state/year, and then, the correlation between those two variables.
# As the correlation ranges from -1 to +1 (meaning, -1 a strong correlation going down and +1 a strong 
# correlation going up), I "cut" the correlation into 5 intervals ranging from Strongly decreasing to Strongly
# Increasing.
#
# Finally, I've ploted a choropleth using those intervals on the US map with colors ranging from green (strongly
# decreasing) to red (strongly increasing).
#
# The packages I've used are quite experimental, and I had to install them using the "devtools" package so I
# was able to use the install_github function.
#
# The components are based on the rCharts library, and are supposed to generate dynamics SGV's 
# for using directly on the browser and to create animated charts, thus, I didn't manage to save the PNG 
# file via R code. Instead, I've used the Export >- Save as Image feature of the R Studio Viewer...
#
# This work is strongly based on this two resources:
# https://github.com/markmarkoh/datamaps/blob/master/README.md#getting-started
# http://rmaps.github.io/blog/posts/animated-choropleths/index.html

print("Starting script. Cleaning the environment...")
remove(list = ls())

#Setting the work directory for the directory where the script was open from.
#setwd(dirname(sys.frame(1)$ofile))
setwd("/Users/fabianoal/Documents/Coursera/Material/Exploratory Data Analysis/Project2")
fileName <- "summarySCC_PM25.rds"
fileName2 <- "Source_Classification_Code.rds"

if(!file.exists(fileName) | !file.exists(fileName2)){
  print(paste0("Please, put the files [", fileName, "] and [", fileName2 ,"] on the [", getwd() ,"] directory"))
}else{
  print("Loading packages...")
  #Loading necessary packages
  #install.packages("devtools","base64enc")
  #require(devtools)
  #install_github('ramnathv/rCharts@dev')
  packages <- c("data.table", "dplyr", "reshape2", "XML", "RColorBrewer", "rMaps", "rCharts")
  
  sapply(packages, require, character.only=TRUE, quietly=TRUE)
  
  print("Reading files...")
  #Reading, selecting necessary variables, filtering, tbl'ing and mutating the txt.
  pm25 <- readRDS(fileName)
  scc <- readRDS(fileName2)
  
  print("Filtering only SCC's relatad with coal...")
  pm25.Coal <- pm25[pm25$SCC %in% scc[grepl(x=scc$Short.Name, pattern="*Coal*"),"SCC"],]
  
  
  #Reading the wikipedia list of counties and states with fips codes...
  print('Reading the wikipedia list of counties and states with fips codes...')
  library(XML)
  fips_html <- "http://en.wikipedia.org/wiki/List_of_United_States_counties_and_county_equivalents"
  fips <- readHTMLTable(fips_html, header=TRUE)[[1]] #The table we're looking for is the first one...
  fips.states <- fips %>%
          mutate(StateCode = floor(as.numeric(as.character(INCITS))/1000), State = gsub("Hawai.*", "Hawaii", `State or district`))  %>%
          mutate(State = state.abb[match(as.character(State), state.name)]) %>%
          select(StateCode, State) %>%
          unique
   

  
  print("Sum emissions per state code...")
  #Here we pick the state code (same process on fips), group by year and fips, and sum the emissions.
  #Then, we join with the fips.states to pick the State abbreviation, and finally, select the tree needed variables.
  pm25.Coal_sum <- pm25.Coal %>%
          mutate(fips = floor(as.numeric(fips)/1000)) %>%
          group_by(year, fips) %>%
          summarise(Emissions = sum(Emissions)) %>%
          select(year, StateCode = fips, Emissions) %>%
          inner_join(fips.states) %>%
          filter(!is.na(State)) %>%
          select(year,State,Emissions)

  #This data set will have our final data ready for plotting. 
  #For this, we first pick the state abbreviations from the pm25.Coal_sum,
  pm25.cor <- data.frame(as.character(unique(pm25.Coal_sum$State)))

  print('Calculatting correlations...')
  #Now we calculate the correlation between year and emissions. Values > 0 meaning increasing emissions and < 0 , decreasing.
  #This calculation is made on a per state basis. So, sapply with pm25.cor...
  
  pm25.cor$Correlation <- sapply(pm25.cor[[1]], function(state) cor(pm25.Coal_sum[pm25.Coal_sum$State == state, c("Emissions", "year")], method="kendall")[1,2])

  names(pm25.cor) <- c("State",  "Correlation")
  
  pm25.cor$Correlation = as.numeric(as.character(pm25.cor$Correlation))

  #For this project, I'll consider a .5 interval for calculating the intervals for collors...
  lbl <- c("Strongly Decreasing", "Descreasing", "Steady", "Increasing", "Strongly Increasing")
  fills = setNames(rev(c(RColorBrewer::brewer.pal(5, 'RdYlGn'))),lbl)
  #Next step, cutdown the correlations values to the intervals...
  pm25.cor$fillKey <- cut(pm25.cor$Correlation, c(-1.1,-0.5,-0.2,0.2,0.5,1.1), labels=lbl)
  
  #That took me a long time to understant... Basically, the Datamaps accepts lists of lists. And each list (meaning, 
  #each state), have to be named after the State, and the sublists should be named as the properties that they represent.
  #So, the resultintg list has to be formated like:
  #
  #   $WA
  #   $WA$State
  #   [1] WA
  #   50 Levels: AK AL AR AZ CA CO CT DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR ... WY
  #   
  #   $WA$Correlation
  #   [1] -0.6666667
  #   
  #   $WA$fillKey
  #   [1] Strongly Increasing
  #   Levels: Strongly Increasing Increasing Steady Descreasing Strongly Decreasing
  # and so on....
  fd <- toJSONArray2(pm25.cor, json = FALSE, names = TRUE)
  names(fd) <- pm25.cor$State
  
  #Time to plot the map...
  print('Plotting the map...')
  options(rcharts.cdn = TRUE)  
  map <- Datamaps$new()
  map$set(dom = 'chart_1', scope = 'usa',fills = fills, data = fd, legend = TRUE, labels = TRUE)
  map
  
  print("Done!")
}
