# Plot 4 code

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

# compute total USA emissions for each year
total_emissions <- NEI %>% group_by(year) %>% 
  summarize(total.emissions = sum(Emissions, na.rm = TRUE))

# scale Emissions down into millions of tons for plotting purposes

total_emissions <- total_emissions %>% mutate(emissions_millions = total.emissions/1000000)


# get ids for coal sources

coal_source <-
              grepl('Comb',SCC$SCC.Level.One) & 
              grepl('Coal|coal',SCC$SCC.Level.Three) # logical identifying coal sources

coal_IDs <- SCC[coal_source,1] # get SCC ids corresponding to coal sources
NEI_coal <- NEI[NEI$SCC %in% coal_IDs,] # extract coal sources from original data set

# compute total emissions by year

coal_emissions <- NEI_coal %>% 
                  group_by(year) %>% 
                  summarize(total.emissions = sum(Emissions, na.rm=TRUE))

# add variable for % change from 1999
baseline <- coal_emissions$total.emissions[1] # use 1999 emissions as baseline level
coal_emissions <- coal_emissions %>% 
                  mutate(Percent.Change = 100*(total.emissions - baseline)/baseline)


# create plot

coal <- ggplot(coal_emissions, aes(x = year, y = Percent.Change))


# line plot
coal + geom_line(linewidth = 1.25) +
       labs(title = '% Change in USA PM2.5 Emissions from Coal Combustion Sources') +
       xlab('Year') +
       ylab('% Change in PM2.5 from 1999') +
       theme(plot.title = element_text(hjust = 0.5)) + 
       scale_x_continuous(breaks = seq(from = 1999, to = 2008, by = 3)) +
       coord_cartesian(ylim = c(-50,20))


#save plot

ggsave(filename = 'plot4.png', device = 'png')
