if(require(seewave) == F){
  install.packages('seewave')
  require(seewave)
}

if(require(tuneR) == F){
  install.packages('tuneR')
  require(tuneR)
}

require(ggplot2)
setwd("C:/Users/Logan/Downloads/NOISE_DATA/BCFR/TESTING FOLDER")
path <- "C:/Users/Logan/Downloads/NOISE_DATA/BCFR/TESTING FOLDER"  
files <- dir(path, recursive = TRUE)
wave=list()
envelope=list()
envelope.dB=list()

for(i in files){
  file <-  paste0(i)
  print(file)
  wave[[i]] <- readWave(filename=file, units="seconds")
  envelope[[i]] <- env(wave[[i]], plot = FALSE) #create envelope function
  envelope.dB[[i]] <- 20*log(envelope[[i]], base = 10) #convert to dB
}

path <- "C:/Users/Logan/Downloads/NOISE_DATA/BCFR/TESTING FOLDER"  
files <- dir(path, recursive = TRUE)

#Loop to calculate amplitude every 10s in files ----
out=list()
OTR=list()
for(i in files){
  file <- paste0(i)
  print(paste("Processing file",file,sep=" "))
  wave <- readWave(filename=file, units="seconds")
  envelope <- env(wave, plot = FALSE) #create envelope function
  envelope.dB <- 20*log(envelope, base = 10) #convert to dB
  marker=nrow(envelope.dB)/441000
  pos=c(0,(1:marker)*441000)
  
  outDB=data.frame(mean=NA,N=NA,med=NA)
  outTR=data.frame(M=NA,POS=NA)
  
  for(j in 1:length(pos)){
    print(paste(pos[j]+1,pos[j+1]))
    if(!is.na(pos[j+1])){clip=envelope.dB[(pos[j]+1):pos[j+1]]}
    else{clip=envelope.dB[pos[j]:length(envelope.dB)]}
    outDB[j,1]=mean(clip)
    outDB$N[j]=length(clip)
    outDB$med[j]=median(clip)
    outDB$File[j]=file
    
  }
  outTR$M=max(outDB$mean)
  outTR$POS=which(outDB==max(outDB$mean))
  
  out[[i]]=outDB
  OTR[[i]]=outTR}

for(i in files){
file <-  paste0(i) 
data <- readWave(filename = file, units = c("seconds"))
newdata <- ffilter(wave = data, f = 44100, from = 2500, to = 4500, bandpass = TRUE, output = "Wave")
newName <- paste0(path,'/',i,'_Chorus.wav') 
writeWave(newdata, filename = newName) 
message('Wrote file: ',i, ' to ',newName)
}