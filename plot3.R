# Plot 3 code


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

#extract Baltimore (Balt) data
# fips = 24510 is Baltimore ID
# note fips is a character string

NEI_Balt <- subset(NEI, fips == '24510')

# compute total emissions for each year AND each source type
Balt_emissions <- NEI_Balt %>% group_by(type,year) %>% 
  summarize(total.emissions = sum(Emissions, na.rm = TRUE))

# create gg plot object 
balt <- ggplot(Balt_emissions, aes(x =year, y = total.emissions, color = type))

# create plot for pollutant sources, one colored line for each source

# line chart
balt + geom_line(linewidth= 1.25) + 
       labs(title = 'Total Baltimore Emissions by Pollutant Type') + 
       xlab('Year') + 
       ylab('PM2.5 Emissions (tons)') + 
       theme(plot.title = element_text(hjust = 0.5)) + 
       scale_x_continuous(breaks = seq(from = 1999, to = 2008, by = 3))
    
# save plot

ggsave(filename = 'plot3.png', device = 'png')
    
  