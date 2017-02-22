



library(RpepXML)
library(pepXMLTab)

?RpepXML
??pepXMLTab
pepxml <- system.file("extdata","tinySearch.pepXML",package="RpepXML")
?system.file
x <- parseMSMSpepXML(pepxml)
pepxml<-"C:/urine_test2/ptmProphet-output-file.ptm.pep.xml"
pepXML2tabpepxml <- system.file("extdata","tinySearch.pepXML",package="RpepXML")
x <- parseMSMSpepXML("C:/urineALL/ptmProphet-output-file.ptm.pep.xml")
x <- parseMSMSpepXML("C:/urineALL/ipro-output-file.pep.xml",verbose = T)
parseMSMSpepXML


x <- pepXML2tab("C:/urineALL/ptmProphet-output-file.ptm.pep.xml")
pepXML2tab
head(x)
x[,"protein_descr"]
modcolumn<-x[,"modification"]
pSTYmasses<-c("166.99","243.02","160.03")


modified.columns<-x[grep("166.99|243.0|160.03",modcolumn),]



?PSMfilter
PSMfilter(x,)
          
          
expectordered<-modified.columns[order(as.numeric(modified.columns[,"expect"])),]
h.ordered<-modified.columns[order(-as.numeric(modified.columns[,"hyperscore"])),]


head(expectordered,200)
head(h.ordered)
expectordered[,"protein_descr"]
