

function (pepxml, ...) 
{
  options(stringsAsFactors = FALSE)
  doc <- xmlRoot(xmlTreeParse(pepxml))
  msms_run_summary <- doc[["msms_run_summary"]]
  sampleEnzyme <- xmlGetAttr(msms_run_summary[["sample_enzyme"]], 
                             "name")
  searchEngine <- xmlGetAttr(msms_run_summary[["search_summary"]], 
                             "search_engine")
  searchDB <- msms_run_summary[["search_summary"]][["search_database"]]
  n <- which(names(msms_run_summary) == "spectrum_query")
  spqrieslist <- msms_run_summary[n]
  spectrumQueries <- lapply(spqrieslist, function(spqu) {
    attrs <- xmlAttrs(spqu)
    if (xmlSize(spqu) > 0) {
      hit <- xmlApply(spqu[[1]], xmlAttrs)
      hitTab <- do.call(rbind, hit)
      tmp <- xmlApply(spqu[[1]], function(x) {
        scores <- xmlSApply(x[[1]], xmlGetAttr, "value")
        scorenames <- xmlSApply(x, xmlGetAttr, "name")
        
        print(names(scores))
        print(x)
        idx <- which(names(scores) == "search_score")
        scoreslist <- unlist(scores[idx])
        names(scoreslist) <- unlist(scorenames[idx])
        idxx <- which(names(scores) == "modification_info")
        if (length(idxx) > 0) {
          modification <- as.data.frame(xmlSApply(x[["modification_info"]], 
                                                  xmlAttrs))
        }
        else {
          modification <- NA
        }
        res <- c(scoreslist, modification = paste(unlist(modification), 
                                                  collapse = ";"))
        res
      })
      PSM <- cbind(hitTab, do.call(rbind, tmp))
      if (!is.null(PSM)) {
        PSM <- t(apply(PSM, 1, function(x) c(attrs, x)))
      }
    }
  })
  PSMtab <- do.call(rbind.data.frame, spectrumQueries)
  rownames(PSMtab) <- NULL
  PSMtab
}


lapfun=function(spqu) {
  attrs <- xmlAttrs(spqu)
  if (xmlSize(spqu) > 0) {
    hit <- xmlApply(spqu[[1]], xmlAttrs)
    hitTab <- do.call(rbind, hit)
    tmp <- xmlApply(spqu[[1]], function(x) {
      scores <- xmlSApply(x, xmlGetAttr, "value")
      scorenames <- xmlSApply(x, xmlGetAttr, "name")
      idx <- which(names(scores) == "search_score")
      scoreslist <- unlist(scores[idx])
      names(scoreslist) <- unlist(scorenames[idx])
      idxx <- which(names(scores) == "modification_info")
      if (length(idxx) > 0) {
        modification <- as.data.frame(xmlSApply(x[["modification_info"]], 
                                                xmlAttrs))
      }
      else {
        modification <- NA
      }
      idxxx <- which(names(scores) == "interprophet_result")
      
      res <- c(scoreslist, modification = paste(unlist(modification), 
                                                collapse = ";"))
      res
    })
    PSM <- cbind(hitTab, do.call(rbind, tmp))
    if (!is.null(PSM)) {
      PSM <- t(apply(PSM, 1, function(x) c(attrs, x)))
    }
  }
  return(scorenames)
}


### breakout just part checking iproph
attrs <- xmlAttrs(spqu[[1]])
hit <- xmlApply(spqu, xmlAttrs)
xmlApply(spqu[[1]], function(x) {
  scores <- xmlSApply(x, xmlGetAttr, "value")
  scorenames <- xmlSApply(x, xmlGetAttr, "name")
  scores
  scorenames
})
  
q1<-lapfun(spqu=spqrieslist)
q1


mod.tides = unlist(xpathApply(doc, "//ns:ptmprophet_result[@ptm='PTMProphet_STY79.966']", xmlGetAttr, "ptm_peptide", namespaces = namespaces ))
  xpathApply(doc, "//ns:ptmprophet_result[@ptm='PTMProphet_STY79.966']", xmlChildren, namespaces = namespaces )
  ??sibling
  xpathApply(doc, "//ns:ptmprophet_result[@ptm='PTMProphet_STY79.966']/parent::*/following-sibling::analysis_result", getSibling, namespaces = namespaces )
  ptmp.parents<-xpathApply(doc, "//ns:ptmprophet_result[@ptm='PTMProphet_STY79.966']/parent::*", xmlParent, namespaces = namespaces )
  ptmp.nodes<-xpathApply(doc, "//ns:ptmprophet_result[@ptm='PTMProphet_STY79.966']", getNodeSet, namespaces = namespaces )
  getNodeSet(doc, "//ns:ptmprophet_result[@ptm='PTMProphet_STY79.966']/parent::analysis_result", namespaces = namespaces )
  ns="http://regis-web.systemsbiology.net/pepXML"
  getNodeSet(doc, "//ns:ptmprophet_result[contains(@ptm,'PTMProphet_STY79.966')]/parent::*/following-sibling::analysis_result[@analysis='interprophet']", namespaces = namespaces )
  ns
  xmlName(doc, "//ns:ptmprophet_result[@ptm='PTMProphet_STY79.966']/parent::*")
  library(xml2)
  
  
  
  ?elementName
  class(ptmp.parents)
  ?xmlAncestors
  
  ?xmlChildren
  
  
all.tides = unlist(xpathApply(doc, "//ns:modification_info", xmlGetAttr, "modified_peptide", namespaces = namespaces ))
iprobs<-as.numeric(unlist(xpathApply(doc, "//ns:interprophet_result", xmlGetAttr, "probability", namespaces = namespaces )))
length(all.tides)
length(iprobs)


modification_info
doc[[1]]
