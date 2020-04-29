library(shiny)

shinyServer(function(input, output, session) {
    random_password <- eventReactive(input$generate, {
        myChars <- c(LETTERS,letters)
        if (input$includeNumbers == TRUE) {
            myChars <- c(myChars, 0:9)
        }
        if (input$includeChars == TRUE) {
            myChars <- c(myChars, "!","£","$","%","^","&","*","(",")",
                         "-","_","+","=","{","}","~","#","<",">","?","/",":",";")
        }
        nbrChars <- input$chars
        rand_vect <- round(runif(nbrChars,min=1, max=length(myChars)))
        rand_pw_vect <- myChars[rand_vect]
        rand_pw <- rand_pw_vect[1]
        for (i in 2:nbrChars) {
            rand_pw <- paste(rand_pw,rand_pw_vect[i],sep="")
        }
        rand_pw
    })
    hist <- eventReactive(input$generate, {
        if (exists("password_history")) {
            if (input$clear == TRUE) {
                password_history <<- NULL
                updateCheckboxInput(session, "clear", value = FALSE)
            }
            password_history <<- rbind(password_history, data.frame(as.character(Sys.time()), random_password()))
        } else {
            password_history <<- data.frame(as.character(Sys.time()),
                                            random_password())
        }
        names(password_history) <- c("Generated Time", "Password")
        password_history[order(password_history[,1], decreasing = TRUE),]
    })
    output$password <- renderText({
        random_password()
    })
    output$history <- renderTable({
        hist()
    })
})
