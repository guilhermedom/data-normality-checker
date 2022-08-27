library(shiny)
library(shinythemes)

# Define UI for application.
ui = fluidPage(
    # Set theme for UI.
    theme = shinytheme("readable"),

    # Application title.
    titlePanel(h1(align = "center", "Data Normality Check"),
               windowTitle = "Data Normality Check"),
    
    br(),
    br(),

    fluidRow(
        column(6, align = "center",
               # File input browsing.
               fileInput("fileInputID", "Choose a file having the data to test:",
                         accept = c("text/csv",
                                    "text/comma-separated-values",
                                    "text/plain",
                                    ".csv")),
               helpText("Only the first column of the selected file will be
                        evaluated."),
               actionButton("checkButtonID", "Check!")),
        column(6, align = "center",
               # Default significance level is 0.05 as it is the most commonly
               # used value for hypothesis testing.
               textInput("significanceInputID", 
                         "Desired significance level for the data normality test
                         (default is 0.05):",
                         value = 0.05),
               h2(verbatimTextOutput("pvalueTextID")))
    ),
    
    # Plot graphs side by side after textual information.
    fluidRow(
        column(6, plotOutput("histogramID")),
        column(6, plotOutput("qqplotID"))
    )
)

# Define server logic.
server = function(input, output) {
    # All server logic runs once the "Check!" button is clicked.
    observeEvent(input$checkButtonID, {
        # Validate to avoid app crashes when no input file is given.
        validate(
            need(input$fileInputID, "A file must be selected.")
        )
        
        # Get only first column from file, ignoring remaining columns of files
        # that violate the recommendation provided in the UI.
        data = read.csv(input$fileInputID$datapath, header = T)[, 1]
        
        # Shapiro-Wilk normality test. Get the second returned value because it
        # is the p-value. First value is the test statistic.
        pvalue = as.numeric(shapiro.test(data)[2])
        
        alpha = input$significanceInputID
        
        # Rounded value is used to avoid floating point issues.
        pvalueRounded = round(pvalue, 10)
        if (pvalueRounded < alpha) {
            pvalueResult = paste("Shapiro-Wilk test's p-value:",
                                 pvalue,
                                 "\nData distribution is not normal as p-value <",
                                 alpha)
        } else {
            pvalueResult = paste("Shapiro-Wilk test's p-value:",
                                 pvalue,
                                 "\nData distribution is normal as p-value >=",
                                 alpha)
        }
        output$pvalueTextID = renderText({
            pvalueResult
        })
        
        output$histogramID = renderPlot({
            hist(data, main = "Data Histogram")
        })
        output$qqplotID = renderPlot({
            qqnorm(data)
            qqline(data)
        })
    })
}

# Run the application.
shinyApp(ui = ui, server = server)
