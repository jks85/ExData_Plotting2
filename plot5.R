# Plot 5 code

#install necessary packages
install.packages("dplyr")
library(dplyr)
install.packages("ggplot2")
library(ggplot2)


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

# extract Baltimore (Balt) data
# fips = 24510 is Baltimore ID
# note fips is a character string

NEI_Balt <- subset(NEI, fips == '24510')

# extract motor vehicle sources

vehicle_sources <- grepl('[Vv]ehicle', SCC$EI.Sector) # logical vector indicating motor vehicle source
vehicle_IDs <- SCC[vehicle_sources, 1] # get SCC ids corresponding to vehicle sources
NEI_Balt_vehicles <- NEI_Balt[NEI_Balt$SCC %in% vehicle_IDs,] # extract vehicle sources from original data set

# compute total vehicle emissions by year

Balt_emissions_vehicles <- NEI_Balt_vehicles %>%
                           group_by(year) %>%
                           summarize(total.emissions = sum(Emissions, na.rm = TRUE))


# create plot object

balt_vehicles <- ggplot(Balt_emissions_vehicles, aes( x = year, y = total.emissions))

# add axes, labels, etc

balt_vehicles + geom_line(linewidth = 1.25) + 
                labs(title = 'Total Baltimore Emissions from Motor Vehicle Sources') + 
                xlab('Year') + ylab('PM2.5 Emissions (tons)') + 
                theme(plot.title = element_text(hjust=0.5)) + 
                scale_x_continuous(breaks = seq(from = 1999, to = 2008, by = 3))

# save plot to png

ggsave(filename = 'plot5.png', device = 'png')