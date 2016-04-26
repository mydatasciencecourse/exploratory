library(reshape2)
library(ggplot2)
library(dplyr)

## This first line will likely take a few seconds. Be patient!
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

molten=melt(nei, id.vars=c("year", "type", "fips", "SCC", "Pollutant"))

# Find sccs where something with coal and combustion is mentioned and filter out the right rows.
matchingSCC=scc[grepl(".*[cC]ombustion.*", scc$SCC.Level.One)& grepl(".*[cC]oal*", scc$SCC.Level.Three),"SCC"]
matchingSubset=subset(molten, SCC %in% matchingSCC)

ammountPerYear=dcast(matchingSubset, year ~ variable, sum)

tryCatch(
  {
    png("plot4.png")
    p=ggplot(ammountPerYear, aes(year, Emissions))+
      geom_bar(stat = "identity")+
      labs(x="Year", y="Total Emissions [t]", title="Total emissions of PM2.5 of coal combustion in US")+
      scale_x_continuous(breaks = c(1999, 2002, 2005, 2008))
    print(p)
  },finally = {
    dev.off()
  })