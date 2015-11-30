all: Data setup

setup: 
	mkdir -p data
	mkdir -p results

Data: data/RNASeq data/sample_subtype

data/RNASeq: 
	mkdir -p data/RNASeq
	wget -P ./data https://tcga-data.nci.nih.gov/tcgafiles/ftp_auth/distro_ftpusers/anonymous/tumor/luad/cgcc/unc.edu/illuminahiseq_rnaseqv2/rnaseqv2/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0.tar.gz
	tar -xzvf data/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0.tar.gz -C data/RNASeq
	mv data/RNASeq/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0/* data/RNASeq/
	rm data/RNASeq/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0

data/nature13385-s2.xlsx:
	wget -P ./data http://www.nature.com/nature/journal/v511/n7511/extref/nature13385-s2.xlsx

data/sample_subtype: data/nature13385-s2.xlsx
	python code/get_subtypes.py > data/sample_subtype
