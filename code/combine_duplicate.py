import sys

#User enters the samples that it wants to use (Ex. 01A, 10A, 11A)
file_ids = sys.argv[1]


#Path to file which has repeating rsIDs that need to be combined
file_path = "/nobackup/shilab/Data/TCGA/LUAD/analysis/tcga-luad-profiles/code/rs_id_" + file_ids + ".txt"


oldFile = open(file_path,'r')

#Store all of the rsIDs with corresponding line of SNP calls in order to compare when rsIDs match
data_dict={}


id_array=[]
duplicate = []

for line in oldFile:
        if line.startswith("Probe"):
        	firstLine = line
	if not line.startswith("Probe"):
                rsID = line.split()[0]
                if rsID not in id_array:
			id_array.append(rsID)		
		else:
			duplicate.append(rsID)
			
          
oldFile.close()


final_fileName = "final_Matrix." + file_ids + ".txt"
newFile = open(final_fileName,'w')
newFile.write(firstLine)


openAgain = open(file_path,'r')
for lin in openAgain:
	if not lin.startswith("Probe"):
		getID = lin.split()[0]
		snpCalls = lin.lstrip(getID)
		snpCalls = snpCalls.rstrip("\n")
		if getID in duplicate:
			if getID not in data_dict.keys():
				data_dict[getID] = snpCalls
			else:
				getCurrent = data_dict[getID]
				updateSnp = ""
				callArray = snpCalls.split("\t")
				currentArray = getCurrent.split("\t")
				length = len(currentArray)
				for i in range(1,length):
					if currentArray[i] == callArray[i]:
						updateSnp = updateSnp + "\t"+ currentArray[i]
					else:
						updateSnp = updateSnp + "\tNA"
				data_dict[getID] = updateSnp
				newLine = getID + updateSnp + "\n"
				newFile.write(newLine)
		else:
			newLine = getID+snpCalls+"\n"
			newFile.write(newLine)					

	

newFile.close()
openAgain.close()

