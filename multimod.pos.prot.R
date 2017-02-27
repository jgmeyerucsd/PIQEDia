
#table<-s

multimod.pos.protein=function(table=skyline.raw,modmasses="K42,K100"){
  pep.start.pos<-table[,"Begin.Pos"]
  protein.names<-table[,"uniprot"]
  pep.charseq<-as.character(table[,"Peptide.Modified.Sequence"])
  num.peps<-length(pep.start.pos)
  print("finding mod positions in peptides")
  pep.pos.list<-lapply(FUN=multi.modpos.pep, pep.charseq, modmass=modmasses)
  prot.pos.vec<-rep(0,times=num.peps)
  #prot.pos.list<-list()
  
  prot.pos.list<- vector("list",num.peps)
  modmasses<-gsub(":",modmasses,replace="+")
  mods.vec<-unlist(strsplit(modmasses,split=","))
  nmods<-length(mods.vec)
  print("assigning protein positions")
  for(i in 1:num.peps){
    #
    #print(i/num.peps)
    if(length(pep.pos.list[[i]])>1){
      for(j in 1:nmods){
        if(j==1){
          prot.pos.list[[i]]<-paste(as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]][[j]],names(pep.pos.list[[i]][j]),sep="")
        }
        if(j>1 && pep.pos.list[[i]][[j]]>0){
          prot.pos.list[[i]]<-paste(prot.pos.list[[i]], paste(as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]][[j]],names(pep.pos.list[[i]][j]),sep=""),sep="_")
        }
      }
    }
    if(length(pep.pos.list[[i]])==1){
      prot.pos.list[[i]]<-paste(as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]][[1]],names(pep.pos.list[[i]][1]),sep="")
    }
  }
  uniprot_modpos<-c(rep(0,times=length(prot.pos.vec)))
  #prot.pos.list[[7623]]
  #uniprot_modpos<-lapply(as.character(table[,"uniprot"]),FUN=paste,prot.pos.list,sep="_")
  print("finishing protein_mods column")
  if(length(prot.pos.vec)>1){
      for(i in 1:length(prot.pos.vec)){
        print(i)
        uniprot_modpos[i]<-paste(table[i,"uniprot"],prot.pos.list[[i]],sep="_",collapse="_")
      }
  }
  
  newtable<-cbind(uniprot_modpos,table)
  return(newtable)
}

#write.table(newtable, file="testmultimod.txt",sep="\t")
