import re
import sys

#User enters the samples that want to be used (ex. 01A or 10A or 11A)
file_ids = sys.argv[1]


snpID_file = "/nobackup/shilab/Data/TCGA/LUAD/analysis/tcga-luad-profiles/data/SNP_positions"

#dictionary for storing the probe IDs and the corresponding SNP IDs
dict_id={}

openFile = open(snpID_file,'r')

for line in openFile:
	if not line.startswith("Probe"):
		probe = line.split()[0]
		id = line.split()[1]
		chr = line.split()[2]
		pos = line.split()[3]
		if chr == "---":
			continue;
		elif id == "---":
			id=chr+":"+pos
			dict_id[probe]=id
		else:
			dict_id[probe]=id


openFile.close()


#This path should point to the file that needs to be altered
file_to_edit = "/nobackup/shilab/Data/TCGA/LUAD/analysis/tcga-luad-profiles/data/SNP/zaza_SNPmatrix." + file_ids + ".txt"


oldFile = open(file_to_edit,'r')
finalFile_name = "rs_id_" + file_ids + ".txt"
newFile = open(finalFile_name,'w')


for line in oldFile:
	if line.startswith("Probe"):
		newFile.write(line)
	if not line.startswith("Probe"):
		oldID = line.split()[0]
		try:
			newID = dict_id[oldID]
		except:
			if oldID not in dict_id.keys():
				continue;
		newLine = line.lstrip(oldID)	
		newLine = newID+newLine
		newFile.write(newLine)


oldFile.close()
newFile.close()
			
		



