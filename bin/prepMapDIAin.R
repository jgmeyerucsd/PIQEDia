#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = T)
#a2<-parse(text=paste(commandArgs(trailingOnly = TRUE), collapse=";"))
#?parse

args<-gsub("\\\\","/",args)
print("input arguments")
print("______________________")
print(args)
#args<-c("C:\\test_this","C:\\two\\examples.csv")


##################################################################################################################
############### helper function #1
#############################################
####################################################################################


multimod.pos.protein=function(table=skyline.raw,modmasses="K:42,K:100"){
  pep.start.pos<-table[,"Begin.Pos"]
  protein.names<-table[,"uniprot"]
  pep.charseq<-as.character(table[,"Peptide.Modified.Sequence"])
  num.peps<-length(pep.start.pos)
  
  
  pep.pos.list<-lapply(FUN=multi.modpos.pep, pep.charseq, modmass=modmasses)
  
  #### need to fix this to work with various numbers of residues
  prot.pos.vec<-rep(0,times=num.peps)
  
  #modresidues<-gsub("([0-9])",modmasses,"")
  modmasses<-gsub(":",modmasses,replace="+")
  
  mods.vec<-unlist(strsplit(modmasses,split=","))
  
  prot.pos.list<- vector("list",num.peps)
  modmasses<-gsub(":",modmasses,replace="+")
  mods.vec<-unlist(strsplit(modmasses,split=","))
  nmods<-length(mods.vec)
  print("assigning protein positions")
  
  for(i in 1:num.peps){
    if(length(pep.pos.list[[i]])>1){
      for(j in 1:nmods){
        if(j==1){
          prot.pos.list[[i]]<-paste(as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]][[j]],names(pep.pos.list[[i]][j]),sep="")
        }
        if(j>1){
          prot.pos.list[[i]]<-paste(prot.pos.vec[i], paste(as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]][[j]],names(pep.pos.list[[i]][j]),sep=""),sep="_")
        }
      }
    }
    if(length(pep.pos.list[[i]])==1){
      prot.pos.list[[i]]<-paste(as.numeric(as.character(pep.start.pos[i]))+pep.pos.list[[i]][[1]],names(pep.pos.list[[i]][1]),sep=".")
    }
  }
  uniprot_modpos<-c(rep(0,times=length(prot.pos.vec)))
  
  print("finishing protein_mods column")
  if(length(prot.pos.vec)>1){
    for(i in 1:length(prot.pos.vec)){
      #print(i)
      uniprot_modpos[i]<-paste(table[i,"uniprot"],prot.pos.list[[i]],sep="_",collapse="_")
    }
  }
  newtable<-cbind(uniprot_modpos,table)
  return(newtable)
}


##################################################################################################################
############### helper function #2
#############################################
####################################################################################



multi.modpos.pep=function(charseq="GK[+80]GK[+42]GQK[+42]R",modmasses="K:42,K:100,STY:79.966"){
  
  
  mods.vec<-unlist(strsplit(modmasses,split=","))
  mods.vec<-gsub(":",mods.vec,replacement = "+")
  
  #mods.mass.vec<-gsub("[A-Z]",mods.vec,replacement = "")
  
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
    massnum<-as.character(round(as.numeric(gsub(x=x,"[A-Z]*[+]","")),digits=0))
    mod.list[[x]]<-unlist(mod.pos.pep[grep(pep.modmasses,pattern=massnum)])
  }
  return(mod.list)	
  #pep<-gsub("([)([0-9]+)(.)([0-9]+)(])", replacement="", charseq) 
}


##################################################################################################################
############### helper function #3
#############################################
####################################################################################
#### works even if sitelevel has a column not found in proteinlevels.txt and removes it

protlvlcorrection = function(sitelevels=mapDIAinput, proteinlevels="proteinlevels.txt",params="C:/urineALL/mapDIA.params",dir="C:/urineALL/"){
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
  
  #### match the site level columns to the correct protein level columns
  pl.colnames<-names(pl)
  sl.colnames<-names(sl)
  sl.areacols<-grep("Area",sl.colnames)
  ### if protein level column names are missing "Area" append this
  if(length(grep(pl.colnames,pattern="Area"))==0){
    names(pl)[2:ncol(pl)]<-paste(names(pl)[2:ncol(pl)],"Area",sep=".")
    pl.colnames<-names(pl)
  }
  pos.in.pl<-match(sl.colnames[sl.areacols],pl.colnames)
  ### setup something to warn about missing protein values eventually
  if(length(na.omit(pos.in.pl))==0){
   stop("replicate names btw protein and sites don't match :(")
  }
  
  ### check if a column is missing in protlevel and omit
  if(length(sl.areacols)!=length(pos.in.pl)){
    sl<-subset(sl,select=-sl.areacols[is.na(pos.in.pl)==TRUE])
  }
  pl<-pl[,c(1,na.omit(pos.in.pl))]
  ### add 1 to each value to ensure no /0
  pl[,2:ncol(pl)]<-pl[,2:ncol(pl)]+1
  
  #matches<-match(sitelvl.unique.prot,protlvl.proteins)
  #check order at some point
  #nchar(names(sl)[grep("X",names(sl))])
  names(sl)[grep("Area",names(sl))] <- paste(names(sl)[grep("Area",names(sl))], "site", sep=" ")
  names(pl)[grep("Area",names(pl))] <- paste(names(pl)[grep("Area",names(pl))], "total", sep=" ")
  names(sl)[1]<-"uniprot"
  names(pl)[1]<-"uniprot"
  merged <- merge(sl,pl,by.x=1,by.y=1)
  head(merged)
  m.mod <- as.matrix(merged[,grep(" site", names(merged))])
  m.mod <-apply(m.mod, 2, as.numeric)
  m.tot <- as.matrix(merged[,grep(" total", names(merged))])
  m.tot  <-apply(m.tot , 2, as.numeric)
  normalized <- m.mod/m.tot
  #head(normalized)
  rn<-merged[,c("uniprot_site", "Peptide.Modified.Sequence", "Product.Mz")]
  normalized.final <- cbind(rn, normalized,RT=merged[,"RT"])
  head(normalized.final)
  #fileout=paste(dir,"mapDIA_input.txt",sep="",col="")
  normalized.final[normalized.final=="Inf"]<-"NA"
  #write.table(file=fileout,normalized.final,row.names = F,quote=F,sep="\t")
  normalized.final
}


################## little helper function

get.labels=function(con="C:/urineALL/mapDIA.parameters"){
  lines<-readLines(con)
  label.line<-grep("LABELS=",lines)
  label.vec<-unlist(strsplit(lines[label.line],split=" "))
  label.vec<-label.vec[2:length(label.vec)]
  return(label.vec)
}




##################################################################################################################
############### main function 
#############################################
####################################################################################

#ptmProphName ="C:/urineALL/ptmProphet-output-file.ptm.pep.xml"
prepMapDIAin=function(ptmProphName = "", 
                      skyline.output= "2016_0826_mapDIA.csv", 
                      ptm.score=0.99,
                      modstring= "K:42.011",
                      wd=getwd(),
                      namemapping=TRUE,
                      protlvl.correction=TRUE)
{
  setwd(wd)
  
  #### read in skyline file, reformat, check which lines are significant in the ptmprophet
  #### alternately, this could be done as a connection instead of into memory
  print("reading skyline report")
  skyline.raw<-read.csv(skyline.output,stringsAsFactors = F,header = T)
  mods.split<-unlist(strsplit(modstring,split=","))
  
  modmasses<-gsub(":", mods.split,replacement = "")
  modmasses<-as.numeric(gsub("[A-Z]", modmasses, replacement=""))
  modmass4sky<-paste("+",round(modmasses),collapse = "",sep="")
  modmass4reformat<-paste("[","+",round(modmasses),"]",collapse = "",sep="")
  unique.peps<-unique(skyline.raw[,1])
  mod.peps.full<-unique.peps[grepl(unique.peps,pattern=modmass4sky)]
  mod.peps.cleaned<-gsub("(\\[)[-+][0-9]+(\\])","",mod.peps.full)
  nmods<-sapply(regmatches(mod.peps.full, gregexpr(modmass4sky, mod.peps.full)), length)
  skyline.mod.results.summary<-data.frame(mod.peps.full,mod.peps.cleaned,nmods)
  
  
  
  if(nchar(ptmProphName)>7){    #### check if there was a real pep.xml file input
    ### check for xml package otherwise install
    if(library(XML,logical.return=T)==FALSE) install.packages("XML",repos="https://cran.cnr.berkeley.edu")
    if(library(XML, logical.return = T)==TRUE) require(XML)
    print("using PTMprophet localization filter")
    ptm.score<-as.numeric(ptm.score)

    #### OLD way to read in ptm.pep.xml, EXTREMELY memory intense but fast
    #doc<-xmlParse(ptmProphName)
    #namespaces<-c(ns="http://regis-web.systemsbiology.net/pepXML")
    #nt<-getNodeSet(doc,xmlmodstring)
    #xmlmodstring<-paste("//ns:ptmprophet_result[@ptm='PTMProphet_",gsub(modstring,pattern=":",replacement = ""),"\']",sep="")
    #tides = unlist(xpathApply(doc, xmlmodstring, xmlGetAttr, "ptm_peptide", namespaces = namespaces ))
    
    #######  NEW way to find modscores from xml, slower than above
    xmlmodstr<-paste("PTMProphet_",gsub(modstring,pattern=":",replacement = ""),sep="")
    con <- file(ptmProphName, "r")
    doc.lines<-readLines(con)
    close(con)
    lines1<-doc.lines[grepl(xmlmodstr,doc.lines)]
    lines2<-sub("^.*[peptide=\\]",x=lines1,"")
    tides<-substr(lines2,start=2,stop=nchar(lines2)-2)

    
    #######  another way to find modscores from xml, slowest
    #lines <- c(rep(0, times=length()))
    #while(TRUE) {
    #  line = readLines(con, 1)
    #  if(length(line) == 0) break
    #  else if(grepl("ptmprophet_result prior", line, fixed = TRUE)) lines <- c(lines, line)
    #}
    #t2<-Sys.time()
    #t2-t1


    if(is.null(tides)){
      stop(paste("no modified peptides with", modstring))
    }
    cleaned<-sapply(FUN=gsub,"([(])([0-9])(.)([0-9]+)())",x=tides,replacement="")
    probstrings<-gsub("[A-Z]+", "", tides)
    probstr.a<-strsplit(probstrings,split="[\\)\\(]")
    for(i in 1:length(probstr.a)){
      probstr.a[[i]]<-probstr.a[[i]][nchar(probstr.a[[i]])>0]
    }
    
    probstr<-lapply(FUN=as.numeric,probstr.a)
    probsumlist<-lapply(FUN=sum,probstr)
    ptms.localized<-rep(0,times=length(probstr))
    for(i in 1:length(probstr)){
      ptms.localized[i]<-length(which(probstr[[i]]>ptm.score))==round(probsumlist[[i]],digits=0)
      #probsumlist[[i]]
    }
    ptm.localized.summary<-data.frame(peptide.full=tides,pep.cleaned=cleaned,is.localized=ptms.localized)
    ptm.localized.true<-ptm.localized.summary[ptm.localized.summary[,3]==1,]
    #nrow(ptm.localized.true)
    #head(ptm.localized.true)
    #ptm.localized.true[is.na(match(ptm.localized.true[,2],skyline.mod.results.summary[,2])),]
    skyline.localized<-skyline.mod.results.summary[is.na(match(skyline.mod.results.summary[,2],ptm.localized.true[,2]))==FALSE,]
    keep<-as.character(skyline.localized[,1])
    skyline.filtered<-skyline.raw[is.na(match(skyline.raw[,1],keep))==FALSE,]
  }
  
  if(nchar(ptmProphName)<7){      ### if the PTMprophet file not given, just rename skyline data.frame
    skyline.filtered<-skyline.raw[is.na(match(skyline.raw[,1],mod.peps.full))==FALSE,]
  }
  
  ### reformat filtered report
  proteins<-substr(start=4,stop=9,x=skyline.filtered[,"Protein"])
  s<-cbind(uniprot=proteins,skyline.filtered)
  
  
  #modstring<-"STY:80"
  head(s)
  #### check that modstring is appropriate
  ################
  
  if(unlist(gregexpr(modstring,pattern=":"))<1){
  }
  
  
  s.pos<-multimod.pos.protein(table=s,modmasses=modstring)
  #names(s.pos)[1] <- "site"
  #s.unisite <- paste(s.pos[,"uniprot"], s.pos[,"site"], sep="_")  
  #s.uni<-cbind(s.unisite,s.pos)
  names(s.pos)[1] <- "uniprot_site"
  area.columns<-grep("Area",names(s.pos))
  RTcol<-grep("Average.Measured.Retention.Time",names(s.pos))
  m.temp1<-s.pos[,c("uniprot_site","Peptide.Modified.Sequence","Product.Mz")]
  tmp<-cbind(m.temp1,s.pos[,area.columns])
  #m.temp2<-s.uni[,c(area.columns,RTcol)]
  mapDIAinput<-cbind(tmp,s.pos[,RTcol])
  names(mapDIAinput)[length(names(mapDIAinput))]<-"RT"
  
  mapDIAinput[mapDIAinput=="#N/A"]<-"NA"
  head(mapDIAinput)
  
  #### with protein level correction
  if(protlvl.correction==TRUE){
    print("correcting protein levels")
    mapDIAinput<-protlvlcorrection(sitelevels=mapDIAinput, proteinlevels="proteinlevels.txt",dir=wd)
  }
  if(protlvl.correction==FALSE){
    print("no protein level correction or proteinlevels.txt missing")
  }
  
  ##### finally, assign name mapping table if provided
  ################################################################################
  ### reorder area columns by group
  
  
  ### if namemapping file exists, replace columns with group headers
  ### make it also count the number of columns per group for updating the mapdia.params
  if(namemapping==TRUE){
    namemap<-read.delim("name_mapping.txt",header = T,stringsAsFactors = F,colClasses = "character")
    n.groups<-ncol(namemap)
    groups<-colnames(namemap)
    group.n<-c()
    groupcol.index<-c()
    for(x in groups){
      print(x)
      tmp.grp.nm<-namemap[,x][nchar(namemap[,x])>1]
      grp.cols<-grep(paste(tmp.grp.nm,sep="|",collapse = "|"), colnames(mapDIAinput))
      i=1
      groupcol.index<-c( groupcol.index,grp.cols)
      for(y in grp.cols){

        colnames(mapDIAinput)[y]<-paste(x,i,sep = ".")
        i=i+1
      }
      
      group.n<-c(group.n,i-1)
    }
    
    finalout<-mapDIAinput
    ### reorder to appropriate order
    finalout<-finalout[,c(1:3,groupcol.index)]
    finalout<-cbind(finalout,RT=mapDIAinput[grep("RT",colnames(mapDIAinput))])
  }
  #colnames(finalout)
  #head(finalout)

  print(paste(wd,"mapDIA.parameters",collapse="",sep=""))
  
  if(substr(wd,start=nchar(wd),stop=nchar(wd))!="/"){
    print("directory needs to end in /, attempting to fix")
    wd<-paste(wd,"/",sep="",collapse="")
    
  }
  
  #### NEED FIX: this part requires that mapDIA.parameters is present in the directory
  if(namemapping==FALSE){
    groups<-get.labels(con=paste(wd,"mapDIA.parameters",collapse="",sep=""))
    tmp<-mapDIAinput[,1:3]
    group.n<-list()
    tmp.area.cols<-grep("Area",names(mapDIAinput))
    for(i in 1:length(groups)){
     print(i)
     groupcol<-grep(groups[i],names(mapDIAinput)[tmp.area.cols],fixed=F,value=F)
     tmp<-cbind(tmp,mapDIAinput[,tmp.area.cols[groupcol]])
    
     group.n[[paste(groups[i])]]<-length(groupcol)
   }
  
    tmp<-cbind(tmp,"RT"=mapDIAinput[,"RT"])
    finalout<-tmp
  }
  
  ### TODO: if mapDIA.parameters is missing, make one
  #if(length(list.files(pattern="mapDIA.parameters2")==0)){}
  
  #### update the (1) condition numbering and the (2) min observed len in mapDIA.parameters
  mp.lines<-readLines(paste(wd,"mapDIA.parameters",collapse="",sep=""))
  mp.lines[grep("SIZE=",mp.lines)]<-paste(c("SIZE=",unlist(group.n)),sep=" ",collapse=" ")
  mp.lines[grep("MIN_OBS=", mp.lines)]<-paste(c("MIN_OBS=",  rep(2,length(groups))),sep= " ",collapse=" ")
  writeLines(mp.lines, con="mapDIA.parameters")
  

  #### without protein level correction
  head(finalout)
  print("writing mapDIA input file")
  fileout<-paste(wd,"mapDIA_Input.txt",sep="",collapse = "")
  write.table(file=fileout, finalout,row.names = F,quote=F,sep="\t")
  #return(mapDIAinput)
}

#prepMapDIAin()


############################################################################
##### actually do stuff here
#############################################################################################
setwd(args[5])
#setwd("~/R24/piqed_sitelvl/")
#args<-c("ptmProphet-output-file.ptm.pep.xml","PIQED_mapDIA.csv","0.99","K42.011","C:/halfFull")

#setwd("~/R24/piqed_sitelvl/")
#getwd()
#### check for name mapping file exist, if so, fix column names to name map
nameMapFile<-list.files(pattern="name_mapping.txt")
nm=FALSE
if(length(nameMapFile)==1){
  print("condition name mapping file available")
  nm=TRUE
}


#### check if protein level quantification file exists, and if so, correct files to protein level
protlvlfile<-list.files(pattern="proteinlevels.txt")
correct=FALSE
if(length(protlvlfile)==1){
  print("protein levels available")
  correct=TRUE
}


if(length(args)<5) print("missing arguments to command line")
if(length(args)==5){
  print("starting R...")
  prepMapDIAin(ptmProphName=args[1],skyline.output=args[2],ptm.score = args[3],modstring= args[4], wd=args[5],namemapping = nm, protlvl.correction = correct)
}
