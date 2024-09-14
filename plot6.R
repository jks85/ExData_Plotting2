# Plot 6 code

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

# extract Baltimore (Balt) and Los Angeles (LA) data 
# fips = 24510 is Baltimore City ID
# fips = 06037 is LA County ID
# note fips is a character string

# extract Balt and LA data separately

NEI_Balt<- subset(NEI, fips == '24510')
NEI_LA <- subset(NEI, fips == '06037')


# extract motor vehicle sources

vehicle_sources <- grepl('[Vv]ehicle', SCC$EI.Sector) # logical vector indicating motor vehicle source
vehicle_IDs <- SCC[vehicle_sources, 1] # get SCC ids corresponding to vehicle sources

NEI_Balt_vehicles <- NEI_Balt[NEI_Balt$SCC %in% vehicle_IDs,] # extract vehicle sources from original data set
NEI_LA_vehicles <- NEI_LA[NEI_LA$SCC %in% vehicle_IDs,]


# compute total vehicle emissions by year for each Location

Balt_emissions_vehicles <- NEI_Balt_vehicles %>%
  group_by(year) %>%
  summarize(total.emissions = sum(Emissions, na.rm = TRUE)) %>%
  mutate(Location = 'Baltimore City')

LA_emissions_vehicles <- NEI_LA_vehicles %>%
  group_by(year) %>%
  summarize(total.emissions = sum(Emissions, na.rm = TRUE)) %>%
  mutate(Location = 'Los Angeles County')

# compute % change

baseline_Balt_1999 <- Balt_emissions_vehicles$total.emissions[1] # 1999 Balt baseline
baseline_LA_1999 <- LA_emissions_vehicles$total.emissions[1] # 1999 LA baseline

Balt_emissions_vehicles <- Balt_emissions_vehicles %>%
                           mutate('Percent.Change'=100*(total.emissions-baseline_Balt_1999)/baseline_Balt_1999)

LA_emissions_vehicles <- LA_emissions_vehicles %>% 
                         mutate('Percent.Change'=100*(total.emissions-baseline_LA_1999)/baseline_LA_1999)

# combine Balt and LA data

Balt_LA_emissions_vehicles <- rbind(Balt_emissions_vehicles,LA_emissions_vehicles)

# initialize plot

balt_la_vehicles <- ggplot(Balt_LA_emissions_vehicles, 
                            aes(x = year, y = Percent.Change,
                            color = Location))

# add axes,labels, etc

balt_la_vehicles + geom_line(linewidth = 1.25) + 
                    labs(title = '% Change in Motor Vehicle PM2.5 Emissions in Baltimore and LA') + 
                    xlab('Year') + 
                    ylab('% Change in PM2.5 from 1999') + 
                    theme(plot.title = element_text(size = 11.5, hjust=0.5)) + 
                    scale_x_continuous(seq(from = 1999, to = 2008, by = 3)) +
                    geom_hline( yintercept = 0, color = 'black', linetype = 'dashed')

ggsave(filename = 'plot6.png', device = 'png')