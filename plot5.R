library(reshape2)
library(ggplot2)
library(dplyr)

## This first line will likely take a few seconds. Be patient!
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

molten=melt(nei, id.vars=c("year", "type", "fips", "SCC", "Pollutant"))

# Find sccs where something with vehicle is mentioned and filter out the right 
# rows. It would also be possible to look for tpye==ONROAD, but this approach 
# seems to get more vehicle related data.
matchingSCC=scc[grepl(".*[vV]ehicle.*", scc$SCC.Level.Two) | grepl(".*[vV]ehicle.*", scc$SCC.Level.Three),"SCC"]
matchingSubset=subset(molten, SCC %in% matchingSCC)

ammountPerYear=dcast(matchingSubset, year + fips ~ variable, sum)

tryCatch(
  {
    png("plot5.png")
    p=ggplot(subset(ammountPerYear, fips == "24510"), aes(year, Emissions))+
      geom_bar(stat = "identity")+
      labs(x="Year", y="Total Emissions [t]", title="Total emissions of PM2.5 of vehicles in Baltimore")+
      scale_x_continuous(breaks = c(1999, 2002, 2005, 2008))
    print(p)
  },finally = {
    dev.off()
  })