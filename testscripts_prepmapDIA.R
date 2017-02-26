
setwd("~/BAT/")

skyline.raw<-read.csv("testset.csv",stringsAsFactors = F,header = T)
proteins<-substr(start=4,stop=9,x=skyline.raw[,"Protein"])
skyline.raw<-cbind(uniprot=proteins,skyline.raw)


skyline.raw<-skyline.raw[grep("42|100",skyline.raw[,2]),]

head(skyline.raw)



