library(ggplot2)
library(shiny)
library(tidyverse)
library(maps)
library(ggmap)
library(mapproj)
library(scales)
library(MASS)
library(FactoMineR)
library(dr)
#=======================================================================================
#ui
#=======================================================================================
ui <- fluidPage(
  #theme = "boot.css",
  titlePanel(h1("King County House Price",align = "center"),windowTitle = "KC House Price App"),
  h2("1. Introduction"),
  p("How much is the cost of your ideal house? People have different preference of features of house, such
as size of yard or view of house. Knowing expected price of house given features will be helpful when
    looking for ideal house. The purpose of this project is to study how house features of house will affect
    the price. According to an article written by Susan Johnston Taylor [1], there are 5 factors that affect the
    price of house: location, size and layout, age and condition, upgrades, and negative events. Location is
    a factor that has been studied for many years. Unlike location which is external factor, the other four
    factors are internal factors. This project will focus on all factors except negative events since this factor
    is not easy to be quantified."),
  
  tags$hr(),
  #=====================================================================================
  #L1 Interactive Data Output
  #=====================================================================================
  h2("2. Data"),
  p("Data used in this project is obtained from Kaggle.com. It contains 21 columns and 21,613 houses
sold in King County between May 2014 and May 2015. Data is shown as follow:"),
  
  fluidRow(
    column(12,dataTableOutput("table"))
  ),
  
  tags$hr(),
  
  #=====================================================================================
  #L2 Map
  #=====================================================================================
  h2("3. Exploratory Data Analysis"),
  h3("3.1. Map"),
  p("This section shows the distribution of houses with price between min and max specified in Range. 
     There are 93.2% of houses with price lower than 1,000,000, 
    meaning that only 6.8% of house prices lie in 1 million to 7.7 million."),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      
      sliderInput(inputId = "range",label = "Range",
                                      min=75000,max=7700000,step = 1000, 
                                      value= c(75000,7700000),dragRange = TRUE),
      
      tableOutput(outputId = "table2"),width = 5
    ),
    
    
    mainPanel = mainPanel(plotOutput(outputId = "map"),width = 7)
  ),
  
  tags$hr(),
  
  #=====================================================================================
  #L3 Scatter Plot
  #=====================================================================================
  h3("3.2. Scattor Plot"),
  p("Scattor Plots in this section show the relation between house features and house price. 
    Some findings are as followed:"),
  tags$ol(
    tags$li("There is clear linear relationship between house price and square footage of living space."),
    tags$li("Inverse relationship between house price and square footage of land space.")
    
  ),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      selectInput(inputId = "xvar", label = "Choose X variable",
                  choices = names(kchouse)[c(-1,-2,-3,-17,-18,-19)]
      )
    ),
    
    mainPanel = mainPanel(plotOutput("scatter"))
  ),
  
  tags$hr(),
  
  #=====================================================================================
  #L4 Boxplot
  #=====================================================================================
  h3("3.3. Boxplot"),
  
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      selectInput(inputId = "xvar2", label = "Choose X variable",
                  choices = names(kchouse)[c(4,5,8,9,10,11,12)]
      ),
      tableOutput("table3"),width = 5
    ),
    
    mainPanel = mainPanel(plotOutput("boxplot"),width = 7)
  ),
  
  tags$hr(),
  
  #=====================================================================================
  #L5 PCA
  #=====================================================================================
  h3("3.3. Principal Component Analysis"),
  p("In principal component analysis, first component can be seen as combination of variables", 
    tags$span(style="color:blue", "bedrooms"),",",
    tags$span(style="color:blue", "bathrooms"), ",",
    tags$span(style="color:blue", "square footage of living"),",",
    tags$span(style="color:blue", "grade"), ",",
    tags$span(style="color:blue", "square footage above"),"and",
    tags$span(style="color:blue", "square footage of interior housing living space for the nearest 15 neighbors"),".",
    "Second component can be seen as combination of variables",
    tags$span(style="color:blue", "floors"),",",
    tags$span(style="color:blue", "view"),",",
    tags$span(style="color:blue", "condition"),",",
    tags$span(style="color:blue", "square footage of basement"),"and",
    tags$span(style="color:blue", "age"),".",
    "Hence, we will view first component as the space of the house, and the second as the quality of the house."
  ),
  
  fluidRow(
    column(5,plotOutput("PCA_var"),offset = 1),
    column(5,plotOutput("PCA_ind"))
  )
  
)
