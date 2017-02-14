# Written by Alexandria D'Souza

# All publications that utilize this software mapDIA
# should provide acknowledgement to the Buck Institute for Research on Aging,
# the Gibson Laboratory/Chemistry Core

#!/usr/bin/env python

import re
import sys
import csv
import os
import os.path
import xml.etree.ElementTree as ET
print 'mapDIA version 1.0'



#arg 1
fn = 'C:/UrineALL/2016_0826_mapDIA.csv'

with open(fn, 'rb') as myfile:
    skylineFile = csv.reader(myfile, dialect='excel')
    data = []
    for row in skylineFile:
        data.append(row)
    myfile.close()

modSeqCol = data[0].index("Peptide Modified Sequence")
modSeqs = [row[modSeqCol] for row in data[1 :]]

pepSeqCol = data[0].index("Peptide Sequence")
pepSeqs = [row[pepSeqCol] for row in data[1 :]]

protCol = data[0].index("Protein")
proNames = [row[protCol] for row in data[1 :]]

prodMzCol = data[0].index("Product Mz")
prodMz = [row[prodMzCol] for row in data[1 :]]

begPosCol = data[0].index("Begin Pos")
begPos = [row[begPosCol] for row in data[1 :]]

endPosCol = data[0].index("End Pos")
endPos = [row[endPosCol] for row in data[1 :]]

try:
    retTimeCol = data[0].index("Average Measured Retention Time")
    retTime = [row[retTimeCol] for row in data[1 :]]
except ValueError:
    retTime = []

i=7
peakAreas=[]
while i<len(data[0]):
    peakAreaCol = i
    peakAreas2 = [row[peakAreaCol] for row in data[1:]]
    x=0
    pkAreas=[]
    pkAreas.append(data[0][i])
    while x<len(peakAreas2):
        if peakAreas2[x] == '#N/A':
            pkAreas.append(0)
    
        else:
            pkAreas.append(float(peakAreas2[x]))
        x+=1
    peakAreas.append(pkAreas)
    i+=1

j=0
accAr=[]                
while j<len(proNames):
    if all(['sp|' in proNames[j], begPos != '#N/A', endPos != '#N/A']):
        acc = proNames[j].split('|')
        acc2=acc[1]
        accAr.append(acc2)
    else:
        accAr.append(' ')
    j+=1

#arg 2
aaMass=sys.argv[2]
aaNum=[]
aaRealNum=[]
aaAr=[]
i=0
acessNums=[]    
proNums=[]
acessNums2=[]
PTM='[+'+aaMass+']'
alphaPTM=PTM.split('[')[0]
numPTM='[' + PTM.split('[')[1]
hyphenPTM = PTM.split('[')[0] + '([)' + PTM.split('[')[1].strip(']') + '(])'
while i< len(modSeqs):

    if PTM in modSeqs[i]:

        j = re.finditer(hyphenPTM, modSeqs[i])

        l = re.finditer(alphaPTM, pepSeqs[i])

        aaNum.append([x.start() for x in j])

        aaRealNum.append([y.start() for y in l])
        acessNums.append(proNames[i])
        acessNums2.append(accAr[i])
        proNums.append(pepSeqs[i])
    else:
        aaNum.append('no site')

        aaRealNum.append('no site')
        acessNums.append('no site')
        acessNums2.append('no site')
        proNums.append('no site')
        

        
    i+=1


w=0
cysAr=[]
while w<len(modSeqs):
    if aaNum[w] != 'no site':
        modRes=re.findall('\[\+[0-9]\]|\[\+[0-9][0-9]\]|\[\+[0-9][0-9][0-9]\]|\[\-[0-9]\]|\[\-[0-9][0-9]\]|\[\-[0-9][0-9][0-9]\]', modSeqs[w])
        num=0
        while num<len(modRes):
            if modRes[num] == numPTM:
                resis=0
            else:
                
                modSeqs[w]= modSeqs[w].replace(modRes[num], '')
            num+=1
        x = modSeqs[w].split(numPTM)
        y=0
        cysIndex=[]
        while y < len(x):
            if y == 0:
                cysIndex.append(len(x[y]))
                        
                        
            else:
                z = y
                
                thisNum=0
                while z>=0:
                    thisNum +=len(x[z])
                    z-=1
                    
                if y == len(x)-1:
                    if modSeqs[w][len(modSeqs[w])-1] != alphaPTM:
                        thisisatest=0
                    
                elif x[y] == '':
                    if x[y][len(x[y])-1]==alphaPTM:
                        cysIndex.append(thisNum)
                else:
                    cysIndex.append(thisNum)
                                            
                    
            
            y+=1
        cysAr.append(cysIndex)
    else:
        cysAr.append('no site')

    w+=1




j=0
uniSite=[]
formatPeptide=[]
formatMz=[]
formatArea=[]
formatProtein=[]
formatPepSeq=[]
formatRT=[]
while j<len(accAr):
    if all(['sp|' in proNames[j], begPos != '#N/A', endPos != '#N/A', cysAr[j] != 'no site']):
        k=0
        empSt=''
        while k<len(cysAr[j]):
            site=int(begPos[j])+cysAr[j][k]
            empSt+='_'
            empSt+=str(site)
            
            k+=1
            
        formattedSite=accAr[j]+empSt
        uniSite.append(formattedSite)
        formatPeptide.append(data[j+1][0])
        formatMz.append(data[j+1][3])
        formatArea.append(data[j+1][7:])
        formatProtein.append(data[j+1][2])
        formatPepSeq.append(data[j+1][1])
        if retTime != []:
            formatRT.append(data[j+1][6])

    j+=1

#arg 4
tree = ET.parse(sys.argv[4])
root = tree.getroot()
totalMass=str(int(aaMass)+128)
hits2=[]
for Element in root.iter():
    
    if Element.tag == '{http://regis-web.systemsbiology.net/pepXML}msms_run_summary':
        for elem1 in list(Element):

            if elem1.tag == '{http://regis-web.systemsbiology.net/pepXML}spectrum_query':
                output={}
                modPep=''
                modMassAr=[]
                modPosAr=[]
                output['spectrum_query'] = elem1.attrib
                zNPM=float(output['spectrum_query']['assumed_charge'])*1.00727647
                z=float(output['spectrum_query']['assumed_charge'])
                for elem2 in elem1.iter():
                    
                    
                    if elem2.tag == '{http://regis-web.systemsbiology.net/pepXML}search_hit':
                        protAltAr=[]
                        output['search_hit'] = elem2.attrib
                        calcPepMass=float(output['search_hit']['calc_neutral_pep_mass'])
                        hitPeptide=output['search_hit']['peptide']
                        hitProtein=output['search_hit']['protein']
                        PrecMz=(calcPepMass+zNPM)/z
                        protAltAr.append(hitProtein)
                        for elem5 in elem2.iter():
                            if elem5.tag == '{http://regis-web.systemsbiology.net/pepXML}alternative_protein':
                                output['alternative_protein']=elem5.attrib
                                altProt=output['alternative_protein']['protein']
                                protAltAr.append(altProt)
                    if elem2.tag == '{http://regis-web.systemsbiology.net/pepXML}modification_info':
                        
                        output['modification_info'] = elem2.attrib
                        modPep=output['modification_info']['modified_peptide']
                        
                      
                        for elem4 in elem2.iter():
                            if elem4.tag == '{http://regis-web.systemsbiology.net/pepXML}mod_aminoacid_mass':
                                try:
                                    output['mod_aminoacid_mass'] = elem4.attrib
                                    if int(float(output['mod_aminoacid_mass']['mass'])) == int(totalMass):
                                        modPosition=output['mod_aminoacid_mass']['position']
                                        modMass=output['mod_aminoacid_mass']['mass']
                                        modMassAr.append([modPosition, modMass])
                                    else:
                                        modPosition=''
                                        modMass=''
                                        modMassAr=[]
                                except KeyError:
                                    modPosition=''
                                    modMass=''
                                    modMassAr=[]
                        
                    if elem2.tag == '{http://regis-web.systemsbiology.net/pepXML}ptmprophet_result':
                        try:
                            output['ptmprophet_result'] = elem2.attrib
                            #change to mod you would like
                            ptmPchk=output['ptmprophet_result']['ptm']
                            takeoutAlpha = re.compile(r'[^\d.]+')
                            ptmPmass=takeoutAlpha.sub('', ptmPchk)
                            #ptmPchk=output['ptmprophet_result']['ptm'][12:].strip('-').strip('+')
                            #ptmPmass=ptmPchk[1].strip('K')
                            #if all([ptmPchk[1][0] == 'K', 'PTMProphet_'+int(float(output['ptmprophet_result']['ptm'])) == "PTMProphet_K"+aaMass:
                            #if int(float(ptmPmass)) == int(aaMass):
                            if ptmPchk[0:14]=="PTMProphet_K"+aaMass:
                                modScores=output['ptmprophet_result']['prior']
                                
                                for elem3 in elem2.iter():
                                    
                                    if elem3.tag == '{http://regis-web.systemsbiology.net/pepXML}mod_aminoacid_probability':
                                        
                                        try:
                                            output['mod_aminoacid_probability'] = elem3.attrib
                                            modPos=output['mod_aminoacid_probability']['position']
                                            modProb=output['mod_aminoacid_probability']['probability']
                                            a=0
                                            while a<len(modMassAr):
                                                if modMassAr[a][0] == output['mod_aminoacid_probability']['position']:
                                                    modPos=output['mod_aminoacid_probability']['position']
                                                    modProb=output['mod_aminoacid_probability']['probability']
                                                    modPosAr.append([modPos, modProb])
                                                
                                                a+=1
                                            
                                            
                                        except KeyError:
                                            modPos=''
                                            modProb=''
                                            modPosAr=[]
                            
                        except KeyError:
                            modPosAr=[]
                try:
                    if any([hitPeptide=='', protAltAr==[], PrecMz=='', modPep=='', modScores=='', modMassAr==[], modPosAr==[]]):
                        donothing=''
                    else:
                        hits2.append([hitPeptide, protAltAr, PrecMz, modPep, modScores, modMassAr, modPosAr])
                except NameError:
                    donothing=''
#arg 3
from collections import deque
ptmProphetScore= sys.argv[3]
i=0
mnsAr=deque()                       
while i<len(formatProtein):
    j=0
    thisAr2=[]
    while j<len(hits2):
        m=0
        thisAr1=[]
        while m<len(hits2[j][6]):
            if all([formatProtein[i] in hits2[j][1],  float(hits2[j][2])-0.00001 <= float(formatMz[i]) <= float(hits2[j][2])+0.00001, formatPepSeq[i] == hits2[j][0], ptmProphetScore<=float(hits2[j][6][m][1])]):
                
                thisAr1.append(uniSite[i])
                thisAr1.append(formatPeptide[i])
                thisAr1.append(formatMz[i])
                if retTime != []:
                    thisAr1.append(formatRT[i])
                k=0
                while k < len(formatArea[i]):
                    thisAr1.append(formatArea[i][k])  
                    k+=1
                    
                thisAr1.append('')
                
                break
           
            m+=1
        if thisAr1!=[]:
            thisAr2.append(thisAr1)
            break

        
        j+=1
    if thisAr2!= []:
        mnsAr.append(thisAr2)
        
    i+=1
 
labelAr=[]
labelAr.append('unisite')     
labelAr.append('peptide')
labelAr.append('Product.Mz')
if retTime != []:
    labelAr.append('Retention Time')
u=7
while u<len(data[0]):
    labelAr.append(data[0][u])
    u+=1

fnThree = fn.strip('.csv') + '_mapDIApeakareas.csv'
with open(fnThree, 'wb') as myfile:
    outputFile = csv.writer(myfile)
    i=0
    outputFile.writerow(labelAr)
    while i<len(mnsAr):
        outputFile.writerows([mnsAr[i][0]])
            
        i+=1
    myfile.close()
