library(shiny)
library(ggplot2)

data("mtcars")
mtcars$am <- factor(mtcars$am,levels=c(0,1), labels=c("Automatic","Manual")) 
fit <- lm(mpg~., data=mtcars)
slm1 <- step(fit)
summary(slm1)
slm1$anova
mtcars$gear <- factor(mtcars$gear,levels=c(3,4,5), labels=c("3gears","4gears","5gears")) 
mtcars$cyl <- factor(mtcars$cyl,levels=c(4,6,8), labels=c("4cyl","6cyl","8cyl")) 


#paste("teste ", predict(slm1, newdata=data.frame("wt"=c(2), "qsec" = c(20), "am" = c(0))))

#qplot(wt, mpg, data=mtcars, colour=am, size=qsec) + 
#  geom_dotplot(binwidth="y", aes(y = predict(slm1, newdata=data.frame("wt"=c(2), "qsec" = c(20), "am" = c(0))), x=c(2)))

shinyServer(

  function(input, output) {
    getdf <- reactive({
      data.frame(
        "wt"=c(input$wt), 
        "qsec" = c(input$qsec), 
        "am" = factor(c(input$am),levels=c(0,1), labels=c("Automatic","Manual"))
      )
    })
    dopred <- reactive({
      predict(
        slm1, 
        newdata = getdf()
      )      
    })
    output$distPlot <- renderPlot({
      
      qplot(wt, mpg, data=mtcars, colour=am, size=qsec) + 
        geom_hline(yintercept = dopred()) +
        geom_vline(xintercept = as.numeric(input$wt)) +
        xlab("Wheight") +
        ylab("Miles per galon")
        #geom_dotplot(binwidth="y", aes(y = mpg_p, x = wt_p), data = data.frame("mpg" = dopred(), "wt" = as.numeric(input$wt)))
    })

    output$textMpg <- renderText({
      paste("The predicted mpg is ", sprintf("%.2f",dopred()), ' for the following informed values:')
    })
    
    output$valores <- renderText({
      paste("Weight:", input$wt, ", 1/4 mile time: ", input$qsec, ", transmission:", ifelse(input$am==0,"Automatic","Manual"))
    })
  }
)

