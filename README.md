# ExData_Plotting2
Exploratory Data Analysis Course Project #2



source data is particulate matter emissions and sources from 1999, 2002, 2005, and 2008

See https://ofmpub.epa.gov/sccwebservices/sccsearch/docs/SCC-IntroToSCCs.pdf

for detailed info regarding SCC classifiers

Plot 1
-- show decrease in "Total" PM2.5 emissions in USA from 1998 to 2005
-- computed total emissions in dplyr
-- plotted to png file using base plot package
-- customized axes, labels etc
-- note: scaled emissions down to millions for plotting

Plot 2
-- show decrease in "Total" PM2.5 emissions from 1998 to 2005 in *Baltimore*
-- subset data to extract Baltimore then repeat plot 1 steps
-- note: scaled emissions down to thousands


Plot 3
-- Examine pollution by source type within Baltimore emissions data from 1998 to 2005  
-- sources: non-road, non-point, on-road, point

Plot 4
-- Examine pollution from coal sources within USA emissions data
-- used SCC text file to identify coal sources; extracted from pollution data
-- plotted totals by year using ggplot2

Plot 5
-- Examine changed in motor vehicle emissions in baltimore
-- note: I elected only to include on road vehicles. I took a subset of the "mobile" category
from EI.Sector variable in the SCC data
-- note I think this plot is the "on road" line from plot 4. I did not realize this initially and I extracted the motor vehicle data from the original dataset. I could probably just have plotted the desired facet from plot 4, but this was not too much extra works as I mostly reused code to subset the data

Plot 6
-- Compare motor vehicle emissions in Baltimore and Los Angeles
-- extracted vehicle sources and locations separately
-- computed percent change in emissions with 1999 as baseline
-- combined data sets
-- added Location column for plotting
