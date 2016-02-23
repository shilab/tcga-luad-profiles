args = commandArgs(trailingOnly=TRUE)

if (length(args)==0)
{
  stop("Input file must be supplied.", call.=FALSE)
}

input_file = args[1]

SNPMatrix <- read.table(input_file,header=T,row.names=1,check.names=F,na.string="NA")

filter_NA <- function(snps, percent)
{
	stopifnot(percent < 1 || percent > 0)
	if (sum(is.na(snps))/length(snps) <= 1-percent)
	{
		return(TRUE)
	}
	else
	{
		return(FALSE)
	}
}

filtered_snps <- apply(SNPMatrix, 1, filter_NA, 0.9)
FilteredSNPMatrix<- SNPMatrix[filtered_snps,]
FilteredSNPMatrix <- cbind(rownames(FilteredSNPMatrix), FilteredSNPMatrix)
colnames(FilteredSNPMatrix)[1] = "ID"
write.table(FilteredSNPMatrix,paste(input_file,'.NAfiltered',sep=""), quote=F,sep="\t",row.names=F,col.names=T)
