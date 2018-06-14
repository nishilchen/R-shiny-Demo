library(shiny)
library(tidyverse)
library(maps)
library(ggmap)
library(mapproj)
library(ggplot2)
library(scales)
library(MASS)
library(FactoMineR)
library(dr)
kchouse <- kchouse %>% filter(bedrooms!=33)
attach(kchouse)
#=======================================================================================================
#Remove id, data, lat, long, yr_build, yr_renovated, and add age. as.factor(zipcode)
#=======================================================================================================

kchouse_1 <- kchouse[,-c(1,2,18,19)]
kchouse_1$zipcode <- as.factor(kchouse$zipcode)
kchouse_1$yr_built[which(yr_renovated!=0)] <- kchouse_1$yr_renovated[which(yr_renovated!=0)]
age <- 2015-kchouse_1$yr_built
kchouse_1$age <- age
kchouse_1 <- kchouse_1[,-c(13,14)]




#=======================================================================================
#server
#=======================================================================================
server <- function(input,output){
  
  
  #=====================================================================================
  #L1
  #=====================================================================================
  output$table <- renderDataTable(
    kchouse, options = list(pageLength = 5)
  )
  
  
  #=====================================================================================
  #L2
  #=====================================================================================
  datachosed <- reactive({
    kchouse %>% filter(price > input$range[1], price < input$range[2])
  })
  
  output$table2 <- renderTable({
    num_chosed <- kchouse %>% filter(price >= input$range[1], price <= input$range[2]) %>% nrow()
    perc_chosed <- percent(num_chosed/21612)
    matrix(c(input$range[1],input$range[2],num_chosed,perc_chosed),1,4,dimnames = list("",c("min","max","Number of houses chosed","Percentage of houses chosed")))
  })
  
  
  map <- get_map(location = c(-122.2,47.57), zoom = 9, maptype = "roadmap")
  ggmap(get_map(location = c(-122.15,47.5), zoom = 10, maptype = "terrain"))
  output$map <- renderPlot({
    qmplot(x = long,y = lat, data = datachosed(),
           mapcolor = "color", col=2, zoom = 10)
  })
  
  #output$text2 <- paste("Total number of points: ",nrow(totalnumber))
  
  #=====================================================================================
  #L3
  #=====================================================================================
  output$scatter <- renderPlot({
    kchouse %>% 
      ggplot(aes(x = eval(parse(text = input$xvar)),y = eval(parse(text = "price"))))+
      geom_point(size = 5)+labs(title = "Scatter Plot\n", x = input$xvar, y = "price")+
      theme_bw(base_size = 12) +
      theme(plot.title=element_text(size=20, face="bold", color="darkgreen"))
  })
  
  #=====================================================================================
  #L4 Boxplot
  #=====================================================================================
  
  output$boxplot <- renderPlot({
    kchouse %>% 
      ggplot(aes(x = as.factor(eval(parse(text = input$xvar2))),y = price))+
      geom_boxplot()+labs(title = "Box Plot\n", x = input$xvar, y = "price")+
      theme_bw(base_size = 12) +
      theme(plot.title=element_text(size=20, face="bold", color="darkgreen"))
  })
  
  output$table3 <- renderTable({
    t3 <- kchouse %>% group_by(eval(parse(text = input$xvar2))) %>% summarise(mean = mean(price), sd = sd(price),n = n())
    names(t3)[1] <- input$xvar2
    t3
  })
  
  #=====================================================================================
  #L5 PCA
  #=====================================================================================
  kc_pca <- PCA(kchouse_1[,-c(1,13)],ncp = 6,graph = FALSE,scale.unit = TRUE)
  output$PCA_var <- renderPlot({
    plot(kc_pca,choix = "var",cex=1.5)
  })
  #plot(kc_pca$ind$dist)
  #library(factoextra)
  #fviz_contrib(kc_pca, choice = "var", axes = 1)
  #fviz_contrib(kc_pca, choice = "var", axes = 2)
  
  pricelevel <- 1*(kchouse$price>quantile(kchouse$price,0.75))+
    1*(kchouse$price>quantile(kchouse$price,0.5))+
    1*(kchouse$price>quantile(kchouse$price,0.25))+
    1*(kchouse$price>=quantile(kchouse$price,0))
  
  output$PCA_ind <- renderPlot({
    
    plot(kc_pca,axes = c(1,2),habillage = "ind",col.hab = pricelevel,label = "none")
    legend(20,16,c("1","2","3","4"),col = c(1,2,3,4),pch = 1,pt.lwd = 4,title = "Price Level")
    
  })
}