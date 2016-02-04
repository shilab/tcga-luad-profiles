SHELL=/bin/bash

all: Data setup

setup: 
	mkdir -p data
	mkdir -p results

code/ExpressionMatrix.py:
	wget -P ./code -nd --no-check-certificate https://raw.githubusercontent.com/shilab/tcga_tools/3332172e35db2d3d11f4efe2f5d64891d8ae1e4d/ExpressionMatrix.py

code/overlap.py:
	wget -P ./code -nd --no-check-certificate https://raw.githubusercontent.com/shilab/sample_overlap/a64f2c7ef4796875b80aa7e390e9ec8efbc25cb1/overlap/overlap.py

Data: data/RNASeq data/SNP data/sample_subtype data/tcga_id_snp_filename data/wilkerson.2012.LAD.predictor.centroids.csv.zip data/CentroidMatrix.mediancenter.head data/ExpressionMatrix.filtered.PI.out

data/tcga_id_snp_filename: data/broad.mit.edu_LUAD.Genome_Wide_SNP_6.sdrf.txt
	cut -f 1,2,31,32 data/broad.mit.edu_LUAD.Genome_Wide_SNP_6.sdrf.txt > data/tcga_id_snp_filename

data/broad.mit.edu_LUAD.Genome_Wide_SNP_6.sdrf.txt:
	wget -P ./data https://tcga-data.nci.nih.gov/tcgafiles/ftp_auth/distro_ftpusers/anonymous/tumor/luad/cgcc/broad.mit.edu/genome_wide_snp_6/snp/broad.mit.edu_LUAD.Genome_Wide_SNP_6.mage-tab.1.2012.0/broad.mit.edu_LUAD.Genome_Wide_SNP_6.sdrf.txt

data/RNASeq: 
	mkdir -p data/RNASeq
	wget -P ./data https://tcga-data.nci.nih.gov/tcgafiles/ftp_auth/distro_ftpusers/anonymous/tumor/luad/cgcc/unc.edu/illuminahiseq_rnaseqv2/rnaseqv2/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0.tar.gz
	tar -xzvf data/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0.tar.gz -C data/RNASeq --strip-components=1
	rm data/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0.tar.gz
	rm data/RNASeq/*.rsem.genes.results
	rm data/RNASeq/*.rsem.isoforms.results
	rm data/RNASeq/*.rsem.isoforms.normalized_results
	rm data/RNASeq/*.bt.exon_quantification.txt
	rm data/RNASeq/*.junction_quantification.txt

data/SNP:
	mkdir -p data/SNP
	wget -P ./data --user ShiX --ask-password https://tcga-data.nci.nih.gov/tcgafiles/ftp_auth/distro_ftpusers/tcga4yeo/tumor/luad/cgcc/broad.mit.edu/genome_wide_snp_6/snp/broad.mit.edu_LUAD.Genome_Wide_SNP_6.Level_2.{37.2012.0,58.2002.0,238.2005.0,183.2002.0,258.2006.0,423.2011.0,222.2005.0,160.2002.0,232.2005.0,84.2010.0,119.2010.0,166.2002.0,264.2007.0,196.2002.0,278.2008.0,204.2004.0,406.2011.0,144.2010.0,52.2009.0,213.2004.0}.tar.gz
	ls data/broad.mit.edu_LUAD.Genome_Wide_SNP_6.Level_2.{37.2012.0,58.2002.0,238.2005.0,183.2002.0,258.2006.0,423.2011.0,222.2005.0,160.2002.0,232.2005.0,84.2010.0,119.2010.0,166.2002.0,264.2007.0,196.2002.0,278.2008.0,204.2004.0,406.2011.0,144.2010.0,52.2009.0,213.2004.0}.tar.gz |xargs -I % -n1 tar -xvzf % -C data/SNP --strip-components=1
	rm data/broad.mit.edu_LUAD.Genome_Wide_SNP_6.*.tar.gz

data/nature13385-s2.xlsx:
	wget -P ./data http://www.nature.com/nature/journal/v511/n7511/extref/nature13385-s2.xlsx

data/wilkerson.2012.LAD.predictor.centroids.csv.zip:
	wget -P ./data http://cancer.unc.edu/nhayes/publications/adenocarcinoma.2012/wilkerson.2012.LAD.predictor.centroids.csv.zip
	unzip -d data data/wilkerson.2012.LAD.predictor.centroids.csv.zip

data/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.1.15.0.sdrf.txt:
	wget -P ./data https://tcga-data.nci.nih.gov/tcgafiles/ftp_auth/distro_ftpusers/anonymous/tumor/luad/cgcc/unc.edu/illuminahiseq_rnaseqv2/rnaseqv2/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.mage-tab.1.15.0/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.1.15.0.sdrf.txt

data/nationwidechildrens.org_clinical_patient_luad.txt:
	wget -P ./data https://tcga-data.nci.nih.gov/tcgafiles/ftp_auth/distro_ftpusers/anonymous/tumor/luad/bcr/biotab/clin/nationwidechildrens.org_clinical_patient_luad.txt

data/raw_covariates: data/nationwidechildrens.org_clinical_patient_luad.txt
	cut -f 2,7 data/nationwidechildrens.org_clinical_patient_luad.txt | sed 1,3d > data/raw_covariates

data/covariates: data/raw_covariates
	python code/create_covariates.py data/raw_covariates > data/covariates

data/sample_subtype: data/nature13385-s2.xlsx
	python code/get_subtypes.py > data/sample_subtype

data/ExpressionMatrix: data/RNASeq-new code/ExpressionMatrix.py
	python code/ExpressionMatrix.py 'data/RNASeq-new/*01A*' > data/ExpressionMatrix

data/ExpressionMatrix.norm: data/ExpressionMatrix
	Rscript --vanilla code/log_norm.R data/ExpressionMatrix

data/RNASeq-new: data/RNASeq data/files_id
	mkdir -p data/RNASeq-new
	python rename.py data/files_id 'data/RNASeq/' 'data/RNASeq-new/'

data/files_id: 
	wget -P ./data https://tcga-data.nci.nih.gov/tcgafiles/ftp_auth/distro_ftpusers/anonymous/tumor/luad/cgcc/unc.edu/illuminahiseq_rnaseqv2/rnaseqv2/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.mage-tab.1.15.0/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.1.15.0.sdrf.txt
	cut -f 1,2 data/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.1.15.0.sdrf.txt > data/files_id

data/tcga_gene_ids: data/ExpressionMatrix
	cut -f 1 data/ExpressionMatrix > data/tcga_gene_ids

data/centroid_gene_ids: data/wilkerson.2012.LAD.predictor.centroids.csv
	cut -d',' -f 1 data/wilkerson.2012.LAD.predictor.centroids.csv | sed 's/"//g' > data/centroid_gene_ids

data/common_genes: data/tcga_gene_ids data/centroid_gene_ids
	cat data/centroid_gene_ids data/tcga_gene_ids | sort | uniq -c | grep '2 ' | sed 's/2 //g' | sed 's/^\s*//g' > data/common_genes

data/CentroidMatrix: data/common_genes data/ExpressionMatrix.norm
	join -1 1 -2 1 data/common_genes <(sort -k1,1 data/ExpressionMatrix.norm) > data/CentroidMatrix -t $$'\t'

data/CentroidMatrix.mediancenter.head: data/CentroidMatrix
	Rscript --vanilla code/mediancenter.R data/CentroidMatrix
	cat <(head -n 1 data/ExpressionMatrix) data/CentroidMatrix.mediancenter > data/CentroidMatrix.mediancenter.head

data/centroids.tsv: data/wilkerson.2012.LAD.predictor.centroids.csv data/common_genes
	join -1 1 -2 1 data/common_genes <(sort -k1,1 <(sed 's/,/\t/g' data/wilkerson.2012.LAD.predictor.centroids.csv | sed 's/"//g' | sed 1d)) -t $$'\t' > data/centroids.tsv	

data/ExpressionMatrix.filtered: data/ExpressionMatrix
	Rscript --vanilla code/filterexpression.R data/ExpressionMatrix

data/subtype-predictions: data/CentroidMatrix.mediancenter.head data/centroids.tsv
	Rscript --vanilla code/predict.R data/CentroidMatrix.mediancenter.head

data/TRU_samples: data/subtype-predictions

data/PP_samples: data/TRU_samples

data/PI_samples: data/PP_samples

data/ExpressionMatrix.filtered.TRU.out: data/ExpressionMatrix.filtered code/overlap.py data/TRU_samples data/PP_samples data/PI_samples
	python code/overlap.py -e 'TRU' data/TRU_samples data/ExpressionMatrix.filtered
	python code/overlap.py -e 'PP' data/PP_samples data/ExpressionMatrix.filtered
	python code/overlap.py -e 'PI' data/PI_samples data/ExpressionMatrix.filtered

data/ExpressionMatrix.filtered.PP.out: data/ExpressionMatrix.filtered.TRU.out

data/ExpressionMatrix.filtered.PI.out: data/ExpressionMatrix.filtered.PP.out

code/quantile_norm.R:
	wget -P ./code -nd --no-check-certificate https://raw.githubusercontent.com/shilab/meQTL_functions/master/R/quantile_norm.R

data/ExpressionMatrix.filtered.TRU.out.norm: code/quantile_norm.R data/ExpressionMatrix.filtered.TRU.out
	Rscript --vanilla code/qnorm.R data/ExpressionMatrix.filtered.TRU.out

data/snp_id_name: data/GenomeWideSNP_6.na35.annot.csv
	cut -d',' -f 1,2 data/GenomeWideSNP_6.na35.annot.csv | awk '$$0!~"#" {print}'| sed -e 's/"//g' -e 's/,/\t/g' > data/snp_id_name

data/SNP_positions: data/GenomeWideSNP_6.na35.annot.csv
	awk '$$0!~"#" {print}' data/GenomeWideSNP_6.na35.annot.csv | cut -d',' -f 2,3,4 | sed -e 's/"//g' -e 's/,/\t/g' > data/SNP_positions
