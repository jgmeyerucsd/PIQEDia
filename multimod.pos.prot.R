


multimod.pos.protein=function(table=skyline.raw,modmasses="K:42,K:100"){
  pep.start.pos<-table[,"Begin.Pos"]
  protein.names<-table[,"uniprot"]
  pep.charseq<-as.character(table[,"Peptide.Modified.Sequence"])
  num.peps<-length(pep.start.pos)
  pep.pos.list<-lapply(FUN=multi.modpos.pep, pep.charseq, modmass=modmasses)
  prot.pos.vec<-rep(0,times=num.peps)
  modmasses<-gsub(":",modmasses,replace="+")
  mods.vec<-unlist(strsplit(modmasses,split=","))
  for(i in 1:num.peps){
    if(length(pep.pos.list[[i]])>1){
      for(j in 1:nmods){
        if(j==1){
          prot.pos.vec[i]<-paste(as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]][[j]],names(pep.pos.list[[i]][j]),sep="")
        }
        if(j>1){
          prot.pos.vec[i]<-paste(prot.pos.vec[i], paste(as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]][[j]],names(pep.pos.list[[i]][j]),sep=""),sep="_")
        }
      }
    }
    if(length(pep.pos.list[[i]])==1){
      prot.pos.vec[i]<-paste(as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]][[1]],names(pep.pos.list[[i]][1]),sep=".")
    }
  }
  uniprot_modpos<-c(rep(0,times=length(prot.pos.vec)))
  if(length(prot.pos.vec)>1){
      for(i in 1:length(prot.pos.vec)){
        uniprot_modpos[i]<-paste(table[i,"uniprot"],prot.pos.vec[i],sep="_",collapse="_")
      }
    }
  newtable<-cbind(uniprot_modpos,table)
  return(newtable)
}


