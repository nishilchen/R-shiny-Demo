library(quantmod)
library(TTR)
all_symbols <- stockSymbols()
getSymbols("TSLA")
head(TSLA)
plot(TSLA[,c(4,2,3)],legend.loc = "topleft")

stock_sd_30 <- rollapplyr(TSLA$TSLA.Close,width = 30,FUN = sd)
na.omit(stock_sd_30)
stock_mean_30 <- rollapplyr(TSLA$TSLA.Close,width = 30,FUN = mean)
plot(stock_mean_30)
plot(stock_sd_30)

TSLA+na.omit(stock_sd_30)

index <- c("^NDX","^GSPC")
dataindex <- list()
for(i in 1:2){
  dataindex[[i]] <- as.xts(get(getSymbols(index[i], src="yahoo")))[,4]
  names(dataindex)[i] <- index[i]
}

daat <- get(getSymbols("TSLA", src="yahoo"))[,4]
for(i in 1:2){
  daat <- cbind(daat,dataindex[[i]])
}
plot(daat,legend.loc = "topleft")
