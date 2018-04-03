import glob
import re
import os
import sys


#User types what set of samples are needed for this run (ex. 01A or 10A or 11A)
id_files = sys.argv[1]
os.chdir("/nobackup/shilab/Data/TCGA/LUAD/analysis/tcga-luad-profiles/data/SNP")


name_files = 'TCGA-[A-Z0-9][A-Z0-9]-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]-'+ id_files +'*'
allFiles = glob.glob(name_files)


#Testing smaller sample size
#allFiles = ["TCGA-44-2655-01A-01D-1549-01.birdseed.data.txt","TCGA-44-2655-01A-01D-0944-01.birdseed.data.txt","TCGA-99-AA5R-01A-11D-A396-01.birdseed.data.txt","TCGA-44-2662-01A-01D-1549-01.birdseed.data.txt","TCGA-44-2662-01A-01D-A273-01.birdseed.data.txt","TCGA-44-2662-01A-01D-0944-01.birdseed.data.txt"]

#Capture sample ID
def captureName(x):
        search_String = "TCGA-[A-Z0-9][A-Z0-9]-([A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9])-" + id_files
	nameSearch = re.search(search_String,x)
        nameCapture = nameSearch.group(1)
        return nameCapture

#Dictionary for sorting between plates of similar samples
plate_dict={}

#Need to ensure that if any duplicates exist, the correct file needs to be chosen.
for x in allFiles:
	sampleName = captureName(x)
	if sampleName not in plate_dict:
		plate_dict[sampleName] = x
	else:
		currentFile = plate_dict[sampleName]
		#Compare the current plate to the new plate and replace if necessary
		comparison_array = [x,currentFile]
		comparison_array.sort()
		newFile = comparison_array[1]
		plate_dict[sampleName] = newFile



#Update the files for analysis, only include those with highest plate number from the repeats
new_allFiles = plate_dict.values()


#Create and populate probe dictionary for extracting genotype information for each sample specific to each probe
probeDict = {}

for fileName in new_allFiles:
	openFile = open(fileName,'r')
	for line in openFile:
		if not line.startswith("Hybridization")| line.startswith("Composite"):
			addName = fileName.strip(".birsdeed.data.txt")	
			probe = line.split()[0]
			confidence = line.split()[2]
			confidence = float(confidence)
			if (confidence >= 0.1):
				genotype = "NA"
			else:
				genotype = line.split()[1]
			if probe not in probeDict:
				probeDict[probe] = genotype
			else:
				current = probeDict[probe]
				update = current+"\t"+genotype
				probeDict[probe] = update

	openFile.close()


final_Filename = "zaza_testing."+ id_files + ".txt"
matrixFile = open(final_Filename,'w')

#First write IDs to first line of file, in order from the allFiles array, this is the order in which they populated the dictionary 
firstLine="Probe_ID\t"

for x in new_allFiles:
	trimName = captureName(x)
	firstLine = firstLine + trimName + "\t"

#Remove the last tab from header before adding newline
firstLine = firstLine.rstrip("\t")
firstLine += "\n"
matrixFile.write(firstLine)


for key in probeDict:
	val = probeDict[key]
	finalLine = key + "\t" + val + "\n"
	matrixFile.write(finalLine)

matrixFile.close()




