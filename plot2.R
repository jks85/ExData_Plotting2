# Plot 2 code

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

#extract Baltimore (Balt) data
# fips = 24510 is Baltimore ID
# note fips is a character string

NEI_Balt <- subset(NEI, fips == '24510')

# compute total emissions for each year
Balt_emissions <- NEI_Balt %>% 
                  group_by(year) %>% 
                  summarize(total.emissions = sum(Emissions, na.rm = TRUE))

# scale Emissions down into thousands of tons for plotting purposes

Balt_emissions <- Balt_emissions %>% mutate(emissions_thousands = total.emissions/1000)


#create png file

png('plot2.png')

#initialize plot
with(Balt_emissions, plot(year, emissions_thousands, type ='n', 
                           xaxt = 'n', xlab = 'Year', 
                           ylab = 'PM2.5 Emissions (thousands of tons)'))


#set axis labels
axis(1, at = seq(from = 1999, to = 2008, by = 3), las = 1)

# plot change in total emissions
with(Balt_emissions, lines(year,emissions_thousands))


# set title
title('Total Emissions by Year in Baltimore')

# turn of png graphics device
dev.off()