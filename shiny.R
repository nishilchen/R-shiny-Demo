library(shiny)
library(tidyverse)
library(maps)
library(ggmap)
library(mapproj)
kchouse <- read_csv(file = "C:\\Users\\nishi\\OneDrive\\shiny\\kc_house_data.csv",
                    col_names = TRUE)
kchouse <- kchouse %>% filter(bedrooms!=33)
#=============================================================================
ui <- fluidPage(
  headerPanel("R Shiny Demo with King County House Price Data"),
  
  #=======================================================================
  #Normal Number Generater
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      
      sliderInput(inputId = "num", 
                  label = "Choose a number", 
                  value = 500, min = 100, max = 10000,step = 100,
                  animate = TRUE),
      sliderInput(inputId = "bin_size",
                  label = "Bin Size",
                  value = 10, min = 10,max = 100)
    ),
    mainPanel = mainPanel(plotOutput("hist"))
    
  ),
  
  #=======================================================================
  #Text
  tags$h3("Can I add text here?"),
  
  #=======================================================================
  #Kc house
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      selectInput(inputId = "xcol", label = "Choose X variable",
                  choices = names(kchouse)[c(-1,-2,-17,-18)]
      ),
      selectInput(inputId = "ycol", label = "Choose Y variable",
                  choices = names(kchouse)[c(-1,-2,-17,-18)]
      )
    ),
    
    mainPanel = mainPanel(plotOutput("scatter"))
  ),
  
  tags$hr(),
  
  #=======================================================================
  #KC house map
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      selectInput(inputId = "var1",label = "Choose a variable",
                  choices = list("bedrooms","bathrooms","view","waterfront","condition","grade")),
      
      sliderInput(inputId = "range",label = "Constrain",min=1,max=10,value=1)
    ),
    
    
    mainPanel = mainPanel(plotOutput("map"))
  )
  
  
  
)




#=============================================================================
server <- function(input,output,session){
  
  #=======================================================================
  #output histogram
  output$hist <- renderPlot({
    title <- paste("Generate ", input$num, " data with bin size = ", input$bin_size)
    hist(rnorm(input$num),breaks = input$bin_size, main = title)
  })
  
  #=======================================================================
  #output scatter plot
  output$scatter <- renderPlot({
    kchouse %>% 
      ggplot(aes(x = eval(parse(text = input$xcol)),y = eval(parse(text = input$ycol))))+
      geom_point()+labs(title = "Scatter Plot\n", x = input$xcol, y = input$ycol)+
      theme_bw(base_size = 12) +
      theme(plot.title=element_text(size=20, face="bold", color="darkgreen"))
  })
  
  
  #=======================================================================
  #create interactive inputs
  observe({
    min <- as.numeric(min(kchouse %>% select(input$var1)))
    max <- as.numeric(max(kchouse %>% select(input$var1)))
    updateSliderInput(session,inputId = "range",min = min,max = max)
    
  })
  
  #output map
  map <- get_map(location = c(-122.2,47.57), zoom = 9, maptype = "roadmap")
  ggmap(get_map(location = c(-122.15,47.5), zoom = 10, maptype = "terrain"))
  output$map <- renderPlot({
    qmplot(x = long,y = lat, data = kchouse,
           mapcolor = "color", col=kchouse %>% select(input$var1))
  })
  
  
  
  
  
  
  
  
}





shinyApp(ui = ui, server = server)