#=======================================================================================
#server
#=======================================================================================
server <- function(input,output){
  all_symbols <- stockSymbols()
  dat <- reactive({
    as.xts(get(getSymbols(input$stockname, src="yahoo")))
    })
  dat_chosen <- reactive({
    dat()[paste(input$daterange[1],"/",input$daterange[2],sep = "")]
  })
  
  # indexdat <- reactive({
  #   dataindex <- list()
  #   for(i in 1:length(input$index)){
  #     temp <- as.xts(get(getSymbols(input$index[i], src="yahoo")))
  #     dataindex[[i]] <- temp[paste(input$daterange[1],"/",input$daterange[2],sep = "")]
  #     names(dataindex)[i] <- input$index[i]
  #   }
  #   dataindex
  # })
  
  output$price <- renderPlot({
    data_plot <- dat_chosen()[,c(4,3,2)]
    #stock_sd_30 <- rollapplyr(data_plot[,1],width = 30,FUN = sd)
    #data_plot <- cbind(data_plot,data_plot+2*stock_sd_30,data_plot-2*stock_sd_30)
    plot(data_plot,
         main = all_symbols[which(all_symbols$Symbol == input$stockname),2],
         legend.loc = "topleft")
    })
  output$volumn <- renderPlot({
    data_volumn <- dat_chosen()[,5]
    ggplot(data = data_volumn,
           mapping = aes(x = time(data_volumn),y = data_volumn))+
      geom_bar(stat = "identity")+
      labs(title = "Volumns",x = "Time", y = "volumn")
  })
  
  output$Dev30 <- renderPlot({
    stock_sd_30 <- rollapplyr(dat_chosen()[,4],width = 30,FUN = sd)
    #plot(stock_sd_30,main = "30 Days Standard Deviation")
    ggplot(data = stock_sd_30,
           mapping = aes(x = time(stock_sd_30),y = stock_sd_30))+
      geom_line()+
      labs(title = "30 Days Standard Deviation",x = "Time", y = "Deviation")
  })
  
  # output$plotwithindex <- renderPlot({
  #   temp_all <- dat_chosen
  #   for(i in 1:length(input$index)){
  #     temp_all <- cbind(temp_all,indexdat()[[i]])
  #   }
  #   plot(temp_all,legend.loc = "topleft")
  # })
}














