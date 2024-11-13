##########################################
##                                      ##
##  TB Burden by Year App               ##
##                                      ##
##########################################

library(shiny)
library(readxl)
library(sqldf)
tbData <- as.data.frame(read.csv("data/TB_Burden_Country.csv"))
countryData <- tbData[,c(6,7,11,18,24,31)]
aggData <- aggregate(countryData[,2:6],by=list(Category =countryData$Year), FUN=sum)
country <- aggData
numericalData <- aggData[,2:6]

ui <- fluidPage("TB Burden by Year App",
                selectInput(inputId = 'xData', label = "Select x-axis data:",
                            choices = names(country)),
                selectInput(inputId = 'yData', label = "Select y-axis data:",
                            choices = names(numericalData),
                            selected = names(numericalData)[[2]]),
                textInput(inputId = 'addText', label = "Enter text here:"),
                textOutput(outputId = 'showText'),
                plotOutput(outputId = 'scatterPlot', width = "100%", height = "500px")
)
server <- function(input, output) {
  textData <- reactive(input$addText)
  plotData <- reactive(data.frame(country[,input$xData], numericalData[,input$yData]))
  output$showText <- renderText(textData())
  output$scatterPlot <- renderPlot({
    title = "TB Burden by Year"
    plot(plotData(), main = title,xlab="Year", ylab="Total Number by Year",
         type="b", col="navy", lwd=5, pch=15)
  })
}
shinyApp(ui = ui, server = server)
