
# This is the user-interface definition of a Shiny web application.

# ui.R will control how the page will look like. 
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
      # Application title
      titlePanel("Did you survive the Titanic ?"),
      # Sidebar with inputs
      sidebarLayout(
            position = "left",
            sidebarPanel(
                  h3("Identify your passenger class, gender and age:"),
                  p(),
                  radioButtons("uiClass","What class do you travel in ??",
                               choices = list("First" = 1,
                                              "Second" = 2,
                                              "Third" = 3,
                                              "Part of the crew" = 4),
                               selected = 1),
                  p(),
                  radioButtons("uiSex", "What's your gender?",
                               choices = list("Female","Male"),
                               selected = "Female"),
                  
                  p(),
                  sliderInput("uiAge", "How old are you?", 0, 100, 20),
                  p()
                  ),
            mainPanel(
                  h4('Your Situation'),
                  textOutput("Message1"),
                  h4('Prediction:'), 
                  p(),
                  textOutput("Message2"),
                  plotOutput("PiePlot")
            )
      )
))
