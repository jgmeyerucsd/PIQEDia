
getwd()

skyline.raw<-read.csv(skyline.output,stringsAsFactors = F,header = T)

head(skyline.raw)
skyline.raw[,1]
skyline.raw[,2]

all.peps<-skyline.raw[,1]
mod.peps.full<-unique.peps[grepl(unique.peps,pattern=modmass4sky)]
mod.peps.full
unmod.peps<-gsub("\\[[+]57\\]","",all.peps)
length(uni)
unmod.skyline<-skyline.raw[which(skyline.raw[,2]==unmod.peps),]
nrow(unmod.skyline)
nrow(skyline.raw)
head(unmod.skyline)
uniprot<-substr(unmod.skyline[,3],start=4,stop=9)
peptide<-unmod.skyline[,2]
fragmz<-unmod.skyline[,4]
rt<-unmod.skyline[,7]
pl<-cbind(uniprot,peptide,fragmz,unmod.skyline[,grep("Area",names(unmod.skyline))],rt)
pl[pl=="#N/A"]<-"NA"
write.table(file="testunmod.txt",unmod.skyline,sep="\t",row.names = F)
write.table(file="protlvl4mapDIA.txt",pl,sep="\t",row.names = F)
