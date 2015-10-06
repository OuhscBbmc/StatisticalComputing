# Example from Gallery: http://shiny.rstudio.com/gallery/telephones-by-region.html
library(shiny)

# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)

# Define a server for the Shiny app
shinyServer(function(input, output) {

  output$continents <- renderText(
    toupper(colnames(WorldPhones))
  )
  
  # Fill in the spot we created for a plot
  output$phonePlot <- renderPlot({

    # Render a barplot
    barplot(WorldPhones[,input$region]*1000,
            main=input$region,
            ylab="Number of Telephones",
            xlab="Year")
    mtext("Margin Text", side=4)
  })
})
