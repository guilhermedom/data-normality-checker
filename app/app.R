library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
ui = fluidPage(
    theme = shinytheme("readable"),

    # Application title
    titlePanel(h1(align = "center", "Data Normality Check")),
    
    br(),
    br(),

    fluidRow(
        column(6, align = "center", fileInput("fileInputID", "Choose a file having the data to test:",
                            accept = c("text/csv", "text/comma-separated-values", "text/plain", ".csv")),
               helpText("Only the first column of the selected file will be evaluated."),
               actionButton("checkButtonID", "Check!")),
        column(6, align = "center", h2(verbatimTextOutput("pvalueTextID")))
    ),
    fluidRow(
        column(6, plotOutput("histogramID")),
        column(6, plotOutput("qqplotID"))
    )
)

# Define server logic required to draw a histogram
server = function(input, output) {

    observeEvent(input$checkButtonID, {
        validate(need(input$fileInputID, "A file must be selected."))
        
        data = read.csv(input$fileInputID$datapath, header = T)[, 1]
        
        pvalue = shapiro.test(data)[2]
        pvalue = paste("Shapiro-Wilk test's p-value:", pvalue, "\nDistribution is not normal if p-value <= 0.05.")
        output$pvalueTextID = renderText({pvalue})
        
        output$histogramID = renderPlot({hist(data, main = "Data Histogram")})
        output$qqplotID = renderPlot({
            qqnorm(data)
            qqline(data)
        })
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
