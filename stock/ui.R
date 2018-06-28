library(shiny)
library(ggplot2)
library(quantmod)
library(TTR)
#=======================================================================================
#ui
#=======================================================================================
ui <- fluidPage(
  titlePanel(h1("Stock Price",align = "center")),
  
  tags$hr(),
  
  fluidRow(
    column(6,textInput(inputId = "stockname",label = "Choose Stock",value = "TSLA",width = "150px"),
           align = "center"),
    column(6,dateRangeInput(inputId = "daterange",label = "Date Range",
                            start = "2017-01-01",format = "yyyy-mm"),
           align = "center")
  ),

  tags$strong(
  p("Note: You can find symbol of stocks ", 
    a(target="_blank", href = "https://www.marketwatch.com/tools/quotes/lookup.asp?siteID=mktw&Lookup=facebook&Country=us&Type=All","here"))
  ),
  wellPanel(plotOutput(outputId = "price")),
  wellPanel(plotOutput(outputId = "Dev30")),
  wellPanel(plotOutput(outputId = "volumn"))
  # fluidRow(
  #   column(3,checkboxGroupInput(inputId = "index", label = "Choose index included",
  #                               choices = c("Dow Jones" = "^DJI",
  #                                           "NASDAQ" = "^NDX",
  #                                           "S&P 500" = "^GSPC"))),
  #   column(9,plotOutput(outputId = "plotwithindex"))
  # )
)
