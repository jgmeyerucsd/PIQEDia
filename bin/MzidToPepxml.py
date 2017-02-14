#       Written by Sushanth Mukkamalla, Intern @ the Buck Institute
#       June. 2016 


#!/usr/bin/python

import sys
import os
import subprocess
import glob
import datetime
import smtplib
import argparse
import shutil
from email.mime.text import MIMEText


###############################################################################
#
# Global vars
#
##############################################################################

output_directory=sys.argv[1]
error_list = []



################################################################################
#
# functions, etc
#
################################################################################

def ensure_dir(directory):
	try:
		if not os.path.exists(directory):
			os.makedirs(directory)
	except Exception, e:
		print "Directory '" + directory +"' does not exist, and could not be created."


def mzid_to_pepxml(input_file,debug=False):
	if debug:
                command = ["cp", input_file, stripped(input_file)+".mzid"]
	else:
		command = ["idconvert.exe", input_file, "--pepXML", "--ext", "_MSGF.pep.xml"]	
	run_subprocess(command)

	
#run subprocess
def run_subprocess(command):
	# subprocess commands are expected as a list
	# output needs to be shunted to pipes, otherwise try-except errors will fail 
	# into the catch clause, instead of reporting the actual error output of the 
	# command itself, just the error return code. Annoying.
	p = subprocess.Popen(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
	stdout,stderr = p.communicate()
	if stderr != "":
		#log_cmd_err(command,stderr.replace("\n", ";"))
		print 'error occurred'
		return 1
	else:
		return 0


def main():    
	ensure_dir(output_directory)

	os.chdir(output_directory)
	
	numOfFiles = 0;
	for files in glob.glob('*MSGF.mzid'):
		numOfFiles = numOfFiles+1

	if numOfFiles == 0:
		print 'No mzid files found, exiting'
		exit(1)
	
	
	print 'Converting .mzid to .pep.xml...\n'
	for input_file in glob.glob('*.mzid'):
		mzid_to_pepxml(input_file)
		#mzid_to_pepxml(input_file,args.debug)
	
	
	print '.mzid to .pep.xml process completed'

if __name__ == "__main__":
	sys.exit(main())
