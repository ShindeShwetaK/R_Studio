##########################################
##                                      ##
##  TB Burden Correlation App           ##
##                                      ##
##########################################

library(shiny)
library(readxl)
poke <- as.data.frame(read_excel("data/TB_Burden_Country.xlsx", sheet = 1))
pokePts <- poke[,c(7:13, 15:26, 28:43, 45:46)]

ui <- fluidPage("TB Burden Correlation App", 
                selectInput(inputId = 'xData', label = "Select x-axis data:", 
                            choices = names(pokePts)),
                selectInput(inputId = 'yData', label = "Select y-axis data:", 
                            choices = names(pokePts),
                            selected = names(pokePts)[[2]]),
                plotOutput(outputId = 'scatterPlot', width = "100%", height = "500px")
)

server <- function(input, output) {
  output$scatterPlot <- renderPlot({
    title = "TB Burden Correlation"
    plot(pokePts[,input$xData], pokePts[,input$yData], main = title,
         xlab = input$xData, ylab = input$yData, pch = 19,col = 'light blue')
    abline(lm(pokePts[,input$yData] ~ pokePts[,input$xData], data = pokePts), col = "navy")
  })
}
shinyApp(ui = ui, server = server)
