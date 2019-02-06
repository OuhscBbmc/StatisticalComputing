# Adapted from http://shiny.rstudio.com/tutorial/written-tutorial/lesson1/
library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(

  # App title ----
  titlePanel("Hello Shiny!"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),

      sliderInput(inputId = "alpha",
                  label = "transparency",
                  min = 0,
                  max = 1,
                  value = .5,
                  step = .1)
    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Histogram ----
      plotOutput(outputId = "distPlot"),

      # Output: Histogram2 ----
      plotOutput(outputId = "distPlot2")

    )
  )
)
