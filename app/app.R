library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
ui = fluidPage(
    theme = shinytheme("readable"),

    # Application title
    titlePanel(h1(align = "center", "Data Normality Check"),
               windowTitle = "Data Normality Check"),
    
    br(),
    br(),

    fluidRow(
        column(6, align = "center", fileInput("fileInputID", "Choose a file having the data to test:",
                                              accept = c("text/csv", "text/comma-separated-values", "text/plain", ".csv")),
               helpText("Only the first column of the selected file will be evaluated."),
               actionButton("checkButtonID", "Check!")),
        column(6, align = "center", textInput("significanceInputID", "Desired significance level for the data normality test
                                              (default is 0.05):", value = 0.05),
               h2(verbatimTextOutput("pvalueTextID")))
    ),
    fluidRow(
        column(6, plotOutput("histogramID")),
        column(6, plotOutput("qqplotID"))
    )
)

# Define server logic
server = function(input, output) {

    observeEvent(input$checkButtonID, {
        validate(need(input$fileInputID, "A file must be selected."))
        
        data = read.csv(input$fileInputID$datapath, header = T)[, 1]
        
        pvalue = as.numeric(shapiro.test(data)[2])
        alpha = input$significanceInputID
        
        # rounded value is used to avoid floating point issues
        pvalueRounded = round(pvalue, 10)
        if (pvalueRounded < alpha) {
            pvalueResult = paste("Shapiro-Wilk test's p-value:", pvalue, "\nData distribution is not normal as p-value <", alpha)
        } else {
            pvalueResult = paste("Shapiro-Wilk test's p-value:", pvalue, "\nData distribution is normal as p-value >=", alpha)
        }
        output$pvalueTextID = renderText({pvalueResult})
        
        output$histogramID = renderPlot({hist(data, main = "Data Histogram")})
        output$qqplotID = renderPlot({
            qqnorm(data)
            qqline(data)
        })
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
