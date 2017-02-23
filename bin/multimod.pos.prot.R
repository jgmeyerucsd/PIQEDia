


mod.pos.protein=function(table=skyline.raw,modmasses="K:42,K:100"){
  
  pep.start.pos<-table[,"Begin.Pos"]
  #table<-table[pep.start.pos!="#N/A",]
  #pep.start.pos<-pep.start.pos[pep.start.pos!="#N/A"]
  
  protein.names<-table[,"uniprot"]
  pep.charseq<-as.character(table[,"Peptide.Modified.Sequence"])
  num.peps<-length(pep.start.pos)
  pep.pos.list<-lapply(FUN=multi.modpos.pep, pep.charseq, modmass=modmasses)

  
  prot.pos.vec<-rep(0,times=num.peps)
  mods.vec<-unlist(strsplit(modmasses,split=","))
  for(i in 1:num.peps){
    if(length(pep.pos.list[[i]])>1){
      for(j in 1:nmods){
        if(j==1){
          prot.pos.vec[i]<-paste(as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]][[j]],names(pep.pos.list[[i]][j]),sep=".")
        }
        if(j>1){
          prot.pos.vec[i]<-paste(prot.pos.vec[i], paste(as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]][[j]],names(pep.pos.list[[i]][j]),sep="."),sep="_")
        }
      }

    }
    if(length(pep.pos.list[[i]])==1){
      prot.pos.vec[i]<-paste(as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]][[1]],names(pep.pos.list[[i]][1]),sep=".")
    }

  }
    
    tempmods<-as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]])
    if(length(tempmods)>1){
      
      prot.pos.vec[i]<-paste(tempmods,sep="_",collapse="_")
    }
    
    
    if(length(tempmods)==1){
      prot.pos.vec[i]<-tempmods
    }
    #prot.pos.vec[i]<-as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]]
  }
  #names(prot.pos.list)->loopthrou
  #for(x in loopthrou){
  #	prot.pos.list[[x]]<-unique(prot.pos.list[[x]])
  #	}
  #rawtable[1:5,1:7]
  newtable<-cbind(prot.pos.vec,table)
  #newtable[1:5,1:10]
  return(newtable)
}


