library(reshape2)

## This first line will likely take a few seconds. Be patient!
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

molten=melt(nei, id.vars=c("year", "type", "fips", "SCC", "Pollutant"))
ammountPerYear=dcast(molten, year ~ variable, sum)

tryCatch(
  {
    png("plot1.png")
    with(ammountPerYear, {
      barplot(Emissions, names.arg = year)
      title(xlab="Year")
      title(ylab="Total Emissions [t]")
      title(main="Total Emissions of PM2.5 in US per year")
    })
  },
  finally = {
    dev.off()
  })