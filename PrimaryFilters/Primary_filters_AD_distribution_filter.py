import os, sys, re, string
import datetime, subprocess

## This file will parse the GT and AD field of each variant of the VCF file and if it's HET or HomALt will write
##	the "HomAltRatio" to the output files, which will in turn be used as input to the R script to plot the 
##	histograms

inputFile = sys.argv [ 1 ]

#####TODO: ACTION 1/1: Set these values #######################################
AltRatioThresh="0.20"
##############################################################################

outputFile = open(inputFile.replace("_filt_","_ADfilt_"),"w")
outputFileReject = open(inputFile.replace("_filt_","_EXCLUDED_"),"w")


myInput = open(inputFile,'r')

myList = myInput.readlines()

for myLine in myList:
	if '#' in myLine:
		#continue
		outputFile.write(myLine)
	else:
		spline=myLine.split()
		INFOfield=spline[7].split(";")
				
		## Obtaining the HetAltRatio field
		ADfield=spline[9].split(":")[1]
		RefNum=ADfield.split(",")[0]
		AltNum=ADfield.split(",")[1]

		## Make note of the cases where both Ref and Alt num are 0, which can cause arithmetic issues
		if (AltNum == "0" and RefNum == "0"):
			print (ADfield)
			continue

		AltRatio=float((float(AltNum))/(float(AltNum)+float(RefNum)))
		roundAltRatio=round(AltRatio,2)
	
		GTfield=spline[9].split(":")[0]

		## For Het (0/1) variants, check HetAltRatio
		if GTfield == "0/1": 
			#HetOutput.write(str(roundAltRatio)+"\n")
			if (AltRatio >= float(AltRatioThresh)):
				outputFile.write(myLine)
			else:
				outputFileReject.write(myLine)
				outputFileReject.write("AltRatio: "+str(AltRatio)+"\n\n")

		#elif GTfield == "1/1" or ./1, etc.:
		else:
			outputFile.write(myLine)


myInput.close()
outputFile.close()
outputFileReject.close()

		## For Hom (1/1) and unresolved genotypes (e.g. 0|1, .|1, etc), only check FS value

