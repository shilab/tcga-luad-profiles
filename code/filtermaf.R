library(MatrixEQTL)

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0)
{
  stop("Input file must be supplied.", call.=FALSE)
}

input_file = args[1]

MAF=0.05
snps = SlicedData$new()$LoadFile(input_file);

cat('SNPs before filtering:',nrow(snps),'\n')
if( MAF > 0 ) {
    maf.list = vector('list', length(snps))
    for(sl in 1:length(snps)) {
        slice = snps[[sl]];
        maf.list[[sl]] = rowMeans(slice,na.rm=TRUE)/2;
        maf.list[[sl]] = pmin(maf.list[[sl]],1-maf.list[[sl]]);
    }
    maf = unlist(maf.list)
    snps$RowReorder(maf>MAF);
    cat('SNPs after filtering:',nrow(snps),'\n');
    rm(maf, sl, maf.list);
}

snps_mat <- as.matrix(snps)
snps_mat <- cbind(rownames(snps), snps_mat)
colnames(snps_mat)[1] <- "ID"
write.table(snps_mat,paste0(input_file,'.MAFfiltered'),row.names=F,col.names=T,sep="\t",quote=F)
