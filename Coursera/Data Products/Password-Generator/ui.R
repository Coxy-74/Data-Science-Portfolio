#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Random Password Generator"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            div("Simply follow the instructions below to generate a random password."),
            div("1. Choose how many characters for your password (between 6 and 50).", style = "color:steelblue"),
            div("2. Determine if you wish to include numbers in your password.", style = "color:steelblue"),
            div("3. Determine if you wish to include special characters in your password.", style = "color:steelblue"),
            div("4. Click the Generate Password button.", style = "color:steelblue"),
            br(),
            sliderInput("chars",
                        "Number of password characters:",
                        min = 6,
                        max = 50,
                        value = 12),
            checkboxInput("includeNumbers","Include Numbers in Generated Password", value = TRUE),
            checkboxInput("includeChars", "Include Special Characters in Generated Password", value = TRUE),
            actionButton("generate","Generate Password")
        ),
        

        # Show a plot of the generated distribution
        mainPanel(
            img(src = "padlock.png", height = 240, width = 240),
            br(),
            h3("Generated Password"),
            strong(textOutput("password"),style="color:red"),
            br(),
            em("You can copy the generated password and paste into your application."),
            br(),
            em("A history of passwords generated is kept below."),
            br(),
            br(),
            checkboxInput("clear","Clear History (will clear when you next click Generate Password)", value = FALSE),
            h4("Password History"),
            tableOutput("history")
        )
    )
))
