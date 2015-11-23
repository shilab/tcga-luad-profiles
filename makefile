all: data

data: RNASeq

RNASeq: unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0
    mv unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0 RNASeq/

unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0: unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0.tar.gz
    tar -xzvf unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0.tar.gz
    rm unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0.tar.gz

unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0.tar.gz:
    wget https://tcga-data.nci.nih.gov/tcgafiles/ftp_auth/distro_ftpusers/anonymous/tumor/luad/cgcc/unc.edu/illuminahiseq_rnaseqv2/rnaseqv2/unc.edu_LUAD.IlluminaHiSeq_RNASeqV2.Level_3.1.14.0.tar.gz
