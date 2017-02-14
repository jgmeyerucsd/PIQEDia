# Written by Alexandria D'Souza
#!/usr/bin/env python
from collections import deque
import re
import sys
import csv
import os
import os.path
import gc
import xml.etree.ElementTree as ET
import pickle

#arg 4
def parseXMLfile(xmlFile, inputMass, resultArray):
    tree = ET.parse(xmlFile)
    root = tree.getroot()
    totalMass=str(int(inputMass)+128)
    x=0
    for Element in root.iter():
        for elem1 in Element:                               
            if elem1.tag == '{http://regis-web.systemsbiology.net/pepXML}spectrum_query':
                output={}
                modPep=''
                modMassAr=[]
                modPosAr=[]
                modScore=''
                output['spectrum_query'] = elem1.attrib
                for elem2 in elem1.iter():                               
                    if elem2.tag == '{http://regis-web.systemsbiology.net/pepXML}search_hit':
                        protAltAr=[]
                        output['search_hit'] = elem2.attrib
                        hitProtein=output['search_hit']['protein']
                        protAltAr.append(hitProtein)
                        for elem5 in elem2.iter():
                            if elem5.tag == '{http://regis-web.systemsbiology.net/pepXML}alternative_protein':
                                output['alternative_protein']=elem5.attrib
                                altProt=output['alternative_protein']['protein']
                                protAltAr.append(altProt)
                                elem5.clear() 
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
                                        elem4.clear()
                                    else:
                                        modPosition=''
                                        modMass=''
                                        modMassAr=[]
                                        elem4.clear()
                                except KeyError:
                                    modPosition=''
                                    modMass=''
                                    modMassAr=[]
                                    elem4.clear()
                    if elem2.tag == '{http://regis-web.systemsbiology.net/pepXML}ptmprophet_result':
                        try:
                            output['ptmprophet_result'] = elem2.attrib
                            #change to mod you would like
                            ptmPchk=output['ptmprophet_result']['ptm']
                            if ptmPchk[0:14]=="PTMProphet_K"+inputMass:
                                for elem3 in elem2.iter():
                                    if elem3.tag == '{http://regis-web.systemsbiology.net/pepXML}mod_aminoacid_probability':
                                        try:
                                            output['mod_aminoacid_probability'] = elem3.attrib
                                            modPos=output['mod_aminoacid_probability']['position']
                                            a=0
                                            tempScore=[]
                                            while a<len(modMassAr):
                                                if modMassAr[a][0] == output['mod_aminoacid_probability']['position']:
                                                    modProb=output['mod_aminoacid_probability']['probability']
                                                    tempScore.append(float(modProb))
                                                a+=1
                                            if tempScore!=[]:
                                                modScore=max(tempScore)
                                                elem3.clear()
                                        except KeyError:
                                            modPos=''
                                            modScore=''
                                            elem3.clear()
                        except KeyError:
                            modScore=''        
                try:
                    if any([protAltAr==[], modPep=='', modScore=='']):
                        donothing=''
                        elem2.clear()
                    else:
                        resultArray[x]=[protAltAr, modPep, modScore]
                        x+=1
                        elem2.clear()
                except NameError:
                    donothing=''                              
                elem1.clear()

    return
