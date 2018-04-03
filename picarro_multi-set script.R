


setwd("C:/Users/Derek Pierson/Google Drive/OSU - PhD/Projects/DIRT/Soil C incubations - July 2017/Picarro data/Picarro_073117")


#Begin data compilation
###################################

files <- list.files()
files <- files[grepl("\\.dat", files)]

data <- NULL

for(i in 1:length(files)) {
  df <- read.delim(files[i], header = TRUE, sep="", skip=0, as.is=TRUE)
  df$DATETIME <- as.POSIXct(as.character(paste0(df$DATE," ",df$TIME)))


  #Trim off rows before valve 1 data (leave rows if valve 1 data not present in first 50 rows)
  row.strt <- which.max(df$MPVPosition==1)
  if(row.strt < 50){
    df <- df[row.strt:nrow(df),]
  }
  
  
  #Compile data files into one
  data <- rbind(data,df)
}
write.csv(data,"Compiled_Data.csv")


  
#Begin data analysis
###################################    

df <- data
CO2 <- NULL
n = 0

for(h in 1:1000){
  if(nrow(df)<1){break}
  if(nrow(df)<2){next}
  
  count <- NULL
  
  for(g in 1:nrow(df)){
    if(df$MPVPosition[g] == df$MPVPosition[1]){
      next()
    }
    else{
      count <- g
      break
    }
  }
  
  
  sample.data <- df[1:(count-1),]
  df <- df[(count):nrow(df),]
  
  if(nrow(sample.data)<31){next}
  
  df2 <- NULL
  df2 <- as.data.frame(sample.data$MPVPosition[1])
  colnames(df2) <- "VALVE"
  df2$STRT <- sample.data$DATETIME[1]
  df2$STOP <- sample.data$DATETIME[nrow(sample.data)]
  df2$X12C_AVG <- mean(sample.data$X12CO2_dry[(nrow(sample.data)-30):nrow(sample.data)]) 
  df2$X13C_AVG <- mean(sample.data$X13CO2_dry[(nrow(sample.data)-30):nrow(sample.data)]) 
  
  n <- n + 1
  df2$n <- n
  
  df2$ndata <- nrow(sample.data)
  
  
  CO2 <- rbind(CO2,df2)

}

write.csv(CO2,"CO2_data.csv")









  