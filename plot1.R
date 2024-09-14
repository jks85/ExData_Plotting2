# Plot 1 code

#install necessary packages
install.packages("dplyr")
library(dplyr)


#booleans to see if  data is in working directory
file1 <- 'summarySCC_PM25.rds' %in% list.files()
file2 <- 'Source_Classification_Code.rds' %in% list.files()

#download files if needed

#check if both files are in directory
if(!(file1 & file2))
{
  #download file and unzip both files
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(url, "exdata_data_NEI_data.zip")
  unzip("exdata_data_NEI_data.zip")
  
}

#read files

NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS('Source_Classification_Code.rds')

# compute total USA emissions for each year
total_emissions <- NEI %>% group_by(year) %>% 
  summarize(total.emissions = sum(Emissions, na.rm = TRUE))

# scale Emissions down into millions of tons for plotting purposes

total_emissions <- total_emissions %>% mutate(emissions_millions = total.emissions/1000000)


#create png file

png('plot1.png')

#initialize plot
with(total_emissions, plot(year, emissions_millions, type ='n', 
                           xaxt = 'n', xlab = 'Year', 
                           ylab = 'PM2.5 Emissions (millions of tons)'))


#set axis labels
axis(1, at = seq(from = 1999, to = 2008, by = 3), las = 1)

# plot change in total emissions
with(total_emissions, lines(year,emissions_millions))


# set title
title('Total Emissions by Year in USA')

# turn of png graphics device
dev.off()