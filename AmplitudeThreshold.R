if(require(seewave) == F){
  install.packages('seewave')
  require(seewave)
}

if(require(tuneR) == F){
  install.packages('tuneR')
  require(tuneR)
}

require(ggplot2)

file <- "AM-424-NW_20140524_220000_430.wav"
wave <- readWave(file)

#wave <- readWave(file,from = 1,to = min(length(wave@left),120*wave@samp.rate))

envelope <- env(wave, plot = TRUE)
envelope.dB <- 20*log(envelope, base = 10)
remove(envelope)
remove(envelope.dB2)

plotSize <- 5000
plot <- envelope.dB[seq(from =1, by = length(envelope.dB)/plotSize, to = length(envelope.dB))]
plotTime <- seq(from =1, to = length(envelope.dB))/wave@samp.rate
plotTime <- plotTime[seq(from = 1, by = length(envelope.dB)/plotSize, to= length(envelope.dB))]

ggplot() + geom_line(aes(y = plot, x = plotTime)) + theme_bw() + xlab('sample') + ylab('Envelope.dB')


file2 <- "AM-424-NW_20140524_220000_430_1.wav"
wave2 <- readWave(file2)

#wave <- readWave(file,from = 1,to = min(length(wave@left),120*wave@samp.rate))

envelope2 <- env(wave2, plot = TRUE)
envelope.dB2 <- 20*log(envelope2, base = 10)
remove(envelope2)

plotSize <- 5000
plot2 <- envelope.dB2[seq(from =1, by = length(envelope.dB2)/plotSize, to = length(envelope.dB2))]
plotTime2 <- seq(from =1, to = length(envelope.dB2))/wave2@samp.rate
plotTime2 <- plotTime2[seq(from = 1, by = length(envelope.dB2)/plotSize, to= length(envelope.dB2))]

ggplot() + geom_line(aes(y = plot2, x = plotTime2)) + theme_bw() + xlab('sample') + ylab('Envelope.dB')