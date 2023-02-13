import os, sys, re, string
import datetime, subprocess

#-----------------------------------------------------------------------------------------------------------------------------------------------
## By: Sam Khalouei
## Date: Jan 9th, 2020
## Purpose: To convert the casoffinder output text files in /hpf/largeprojects/lauryl/results/casoffinder to BED files as the previous Perl script seems to have a bug
## How to run: This python script is run through the corresponding bash script --> don't run this file directly
#-----------------------------------------------------------------------------------------------------------------------------------------------

inputFile = sys.argv [ 1 ]
mybasename = os.path.basename(inputFile)

myInput = open(inputFile,'r')
myList = myInput.readlines()


myOutput=open("padded_bed_files/"+mybasename.replace("txt","bed"),'w')

for line in myList:
	spline=line.split("\t")

	strand = spline[4]
	chrom = spline[1].split(" ")[0]

	'''
	if strand == "+": print ("we're on positive strand")
	elif strand == "-": print ("we're on negative strand")
	else: print ("strand ambigious")
	'''


	#print (intspline[2] + 23))
	myOutput.write(chrom + "\t" + str(int(spline[2])-1) + "\t" + str(int(spline[2]) + 24) + "\t" + strand + "\t" + str(spline[5].strip()) + "\t" + spline[0] + "\t" + spline[3] + "\n")

	#myOutput.write("chr" + chrom + "\t" + str(spline[2]) + "\t" + str(int(spline[2]) + 23) + "\t" + strand + "\t" + str(spline[5].strip()) + "\t" + spline[0] + "\t" + spline[3] + "\n")
myInput.close()
myOutput.close()
