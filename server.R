
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(datasets)
library(data.table)
data(Titanic)

Titanic <- as.data.frame(Titanic)

mydf <- dcast(Titanic, Class+Sex+Age ~ Survived, value.var = 'Freq')
mydf$Total <- mydf$No + mydf$Yes 
mydf$PSurvival <- with(mydf, Yes / (No + Yes))
# there were no child in the crew, let's use the average Crew probabilities instead.
mydf$PSurvival[with(mydf, which(Class=="Crew" & Age == "Child"))] <- mydf$PSurvival[with(mydf, which(Class=="Crew" & Age == "Adult"))] 

shinyServer(
      function(input, output) {
            rClass <- reactive({ 
                  if (input$uiClass == 1) "1st" 
                  else 
                        if (input$uiClass == 2) "2nd" 
                        else 
                              if (input$uiClass == 3) "3rd"          
                              else "Crew"
                  })
      
            rSex <- reactive({if (input$uiSex == "Male") "Male" else "Female"})
      
            rAge <- reactive({if (input$uiAge <= 18) "Child"
                        else "Adult"})

            
            output$Message1 <- renderText({
                   paste("You are a",rSex(), rAge(), " in ", rClass(), " class.")
                   
            })
            # renderText or renderPrint ??
            output$Message2 <- renderText ({
                  set.seed(1)
                  myClass <- rClass()
                  mySex <- rSex()
                  myAge <- rAge()
                  
                  myPsurvival <- mydf$PSurvival[with(mydf,which(Class==myClass & Sex == mySex & Age == myAge ))]
                  myDeath <- (rbinom(1,1, myPsurvival))
                  result = paste("You ... ",
                                 ifelse(rbinom(1,1, myPsurvival) == 1, "survived!  Congratulations.", "did not survive. Sorry :("))
                  result
            })
            output$PiePlot <- renderPlot({
                  myClass <- rClass()
                  mySex <- rSex()
                  myAge <- rAge()
                  myPsurvival <- mydf$PSurvival[with(mydf,which(Class==myClass & Sex == mySex & Age == myAge ))]
                  myslices <- c(myPsurvival, 1- myPsurvival)
                  mylabels <- c("Survivors", "Dead")
                  mytitle <- paste( "Probability of survival for this profile was",
                                                                    as.character(round(myPsurvival*100)), "%." )
                  pie(myslices, labels = mylabels, main=mytitle)
            })
      }
)


