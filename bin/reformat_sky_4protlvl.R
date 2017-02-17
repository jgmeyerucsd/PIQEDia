
getwd()

skyline.raw<-read.csv(file="C:/urineALL/2016_0826_mapDIA.csv",stringsAsFactors = F,header = T)

head(skyline.raw)
skyline.raw[,1]
skyline.raw[,2]
?readLines




get.labels=function(con="C:/urineALL/mapDIA.parameters"){
  lines<-readLines(con)
  label.line<-grep("LABELS=",lines)
  label.vec<-unlist(strsplit(lines[label.line],split=" "))
  label.vec<-label.vec[2:length(label.vec)]
  return(mapping.table)
}

groups<-get.labels()
#C:\urineALL\2016_0826_mapDIA.csv
#C:\urineALL\ptmProphet-output-file.ptm.pep.xml

all.peps<-skyline.raw[,1]
unique.peps<-unique(all.peps)
mod.peps.full<-unique.peps[grepl(unique.peps,pattern=modmass4sky)]
unmod.peps<-gsub("\\[[+]57\\]","",all.peps)
unmod.skyline<-skyline.raw[which(skyline.raw[,2]==unmod.peps),]
nrow(unmod.skyline)
nrow(skyline.raw)
head(unmod.skyline)
uniprot<-substr(unmod.skyline[,3],start=4,stop=9)
peptide<-unmod.skyline[,2]
fragmz<-unmod.skyline[,4]
rt<-unmod.skyline[,7]
pl<-cbind(uniprot,peptide,fragmz,unmod.skyline[,grep("Area",names(unmod.skyline))],rt)
pl<-cbind(uniprot,peptide,fragmz)

for(i in 1:length(groups)){
  print(i)
  #group.columns[[i]]<-grep(groups[i],names(pl))
  pl<-cbind(pl,unmod.skyline[,grep(groups[i],names(unmod.skyline))])
}
pl<-cbind(pl,rt)

pl[pl=="#N/A"]<-"NA"
names(pl)[1:3]<-c("ProteinName","PeptideSequence","FragmentIon")

#write.table(file="urineALL_4protlvl.txt",unmod.skyline,sep="\t",row.names = F)
write.table(file="protlvl4mapDIA.txt",pl,sep="\t",row.names = F)


