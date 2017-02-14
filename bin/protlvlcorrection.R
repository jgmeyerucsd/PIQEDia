

protlvlcorrection = function(sitelevels=mapDIAinput, proteinlevels="proteinlvl.txt",dir="C:/urineALL/"){
  #head(mapDIAinput)
  #### run names must be in the same order for both matricies
  setwd(dir)
  sl<-sitelevels
  sitelvl.proteins<-substr(sitelevels[,1],start=1, stop=6)
  sl<-cbind(sitelvl.proteins,sl)
  head(sl)
  #sitelvl.unique.prot<-unique(proteins)
  
  pl<-read.delim(proteinlevels,header = T,stringsAsFactors = F)
  protlvl.proteins<-substr(pl[,1],start=1, stop=6)
  
  #matches<-match(sitelvl.unique.prot,protlvl.proteins)
  #check order at some point
  #nchar(names(sl)[grep("X",names(sl))])
  names(sl)[grep("X",names(sl))] <- paste(names(sl)[grep("X",names(sl))], "site", sep=" ")
  names(pl)[grep("X",names(pl))] <- paste(names(pl)[grep("X",names(pl))], "total", sep=" ")
  names(sl)[1]<-"uniprot"
  names(pl)[1]<-"uniprot"
  merged <- merge(sl,pl,by.x=1,by.y=1)
  head(merged)
  m.mod <- as.matrix(merged[,grep(" site", names(merged))])
  m.mod <-apply(m.mod, 2, as.numeric)
  m.tot <- as.matrix(merged[,grep(" total", names(merged))])
  m.tot  <-apply(m.tot , 2, as.numeric)
  normalized <- m.mod/m.tot
  head(normalized)
  rn<-merged[,c("uniprot_site", "Peptide.Modified.Sequence", "Product.Mz")]
  normalized.final <- cbind(rn, normalized,RT=merged[,"RT"])
  head(normalized.final)
  fileout=paste(dir,"mapDIA_input.txt",sep="",col="")
  normalized.final[normalized.final=="Inf"]<-"NA"
  write.table(file=fileout,normalized.final,row.names = F,quote=F,sep="\t")
}
