
import os, sys, re, string
import datetime, subprocess

sample1unique= sys.argv [ 1 ]
sample2unique= sys.argv [ 2 ]
sample1and2common= sys.argv [ 3 ]

denom=(float(sample1unique) + float(sample2unique) + float(sample1and2common))
#print ("denom: ",denom)

fraction = float(sample1and2common)/denom
#print ("fraction: ",fraction)

percent=fraction*100
#print ("percent: ",percent)

print round(percent,2)

