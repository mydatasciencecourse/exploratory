library(reshape2)
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

molten=melt(nei, id.vars=c("year", "type", "fips", "SCC", "Pollutant"))
ammountPerYear=dcast(molten, year + fips + type ~ variable, sum)

# Clean up the names
ammountPerYear$type=gsub("NONPOINT", "NON-POINT", ammountPerYear$type)

tryCatch(
  {
    png("plot3.png")
    p=ggplot(subset(ammountPerYear, fips == "24510"), aes(year, Emissions))+
      geom_bar(stat = "identity")+
      facet_grid(.~ type)+
      labs(x="Year", y="Total Emissions [t]", title="Total emissions of PM2.5 in Baltimore depending on type")+
      scale_x_continuous(breaks = c(1999, 2002, 2005, 2008))
    print(p)
  },finally = {
    dev.off()
  })