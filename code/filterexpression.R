args = commandArgs(trailingOnly=TRUE)

if (length(args)==0)
{
  stop("Input file must be supplied.", call.=FALSE)
}

input_file = args[1]

ExpressionMatrix <- read.table(input_file,header=T,row.names=1,check.names=F)

filter_zeros <- function(gene_expr, percent)
{
	stopifnot(percent < 1 || percent > 0)
	if (length(which(gene_expr>0))/length(gene_expr) >= percent)
	{
		return(TRUE)
	}
	else
	{
		return(FALSE)
	}
}

filtered_genes <- apply(ExpressionMatrix, 1, filter_zeros, 0.9)
FilteredExpressionMatrix <- ExpressionMatrix[filtered_genes,]
write.table(FilteredExpressionMatrix,paste(input_file,'.filtered',sep=""), quote=F,sep="\t",row.names=T,col.names=T)
