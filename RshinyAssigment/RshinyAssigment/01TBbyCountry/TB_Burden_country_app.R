##########################################
##                                      ##
##  TB Burden Country App               ##
##                                      ##
##########################################

library(shiny)
library(readxl)
library(sqldf)
tbData <- as.data.frame(read.csv("data/TB_Burden_Country.csv"))
countryData <- tbData[,c(1,7,11,18,24,31)]
names(countryData)
aggData <- aggregate(countryData[,2:6],by=list(Category =countryData$Country.or.territory.name), FUN=sum)
numericalData <- aggData[,2:6]

ui <- fluidPage("TB Burden Country Appp",
                sliderInput(inputId = "sliderVal", label = "Select Number of Countries",
                            min = 0, max = 200, value = 10, step = 1, ticks = TRUE),
                selectInput(inputId = 'yData', label = "Select y-axis data:",
                            choices = names(numericalData),
                            selected = names(numericalData)[[2]]),
                plotOutput(outputId = "histPlot", width = "100%", height = "400px")
)

server <- function(input, output) {
  output$histPlot <- renderPlot({
    title <- "Histogram of TB Burden"
    aggData <- aggData[order(numericalData[,input$yData],decreasing = TRUE),]
    numericalData <- aggData[0:input$sliderVal,2:6]
    category_plot <- barplot(numericalData[,input$yData],main="Country Count",
                            cex.main = 0.8,
                            width=1,space=0.15,
                            border=NA,
                            ylab="Counts",
                            col="light blue",
                            names.arg = aggData$Category[1:input$sliderVal],
                            cex.axis = 0.7,
                            cex.names = 0.7,las =2)
  })
}

shinyApp(ui = ui, server = server)
