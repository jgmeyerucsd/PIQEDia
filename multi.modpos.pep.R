

multi.modpos.pep=function(charseq="GK[+100]GK[+42]GQK[+42]R",modmasses="K:42,K:100"){
  mods.vec<-unlist(strsplit(modmasses,split=","))
  mods.vec<-gsub(":",mods.vec,replacement = "+")
  modopenbracket<-gregexpr(charseq,pattern="(\\[)")[[1]]
  num.mods<-length(modopenbracket)
  modclosebracket<-gregexpr(charseq,pattern="(\\])")[[1]]
  mod.string.len<-modclosebracket-modopenbracket+1
  mod.pos.string<-modopenbracket
  mod.pos.pep<-list()
  mod.pos.pep[[1]]<-modopenbracket[1]-1
  if(num.mods>=2){
    for(i in 2:num.mods){
      mod.pos.pep[[i]]<-mod.pos.string[[i]]-mod.string.len[[i-1]]*(i-1)-1
    }
  }
  pep.modmasses<-list()
  for(i in 1:num.mods){
    pep.modmasses[[i]]<-substr(charseq,start=modopenbracket[i],stop=modclosebracket[i])
  }
  mod.list<-list()
  for( x in mods.vec){
    massnum<-gsub(x=x,"[A-Z][+]","")
    mod.list[[x]]<-unlist(mod.pos.pep[grep(pep.modmasses,pattern=massnum)])
  }
  return(mod.list)	
  #pep<-gsub("([)([0-9]+)(.)([0-9]+)(])", replacement="", charseq) 
}


