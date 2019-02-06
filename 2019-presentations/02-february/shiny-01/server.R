# Adapted from http://shiny.rstudio.com/tutorial/written-tutorial/lesson1/

# Define server logic required to draw a histogram ----
library(ggplot2)

server <- function(input, output) {

  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot

  output$distPlot <- renderPlot({
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

   hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
        main = "Histogram of waiting times")
  })

  output$distPlot2 <- renderPlot({
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    ggplot(faithful, aes(waiting)) +
      geom_histogram(aes(y=..density..), alpha = input$alpha,
                     bins = input$bins+1, fill = 'blue') +
      geom_density(color = 'red')
  })
}
