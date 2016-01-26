args = commandArgs(trailingOnly=TRUE)

if (length(args)==0)
{
  stop("Input file must be supplied.", call.=FALSE)
}

input_file = args[1]

expr<-read.table(input_file,header=F,row.names=1)

median_center <- function(gene_expression)
{
    median_expression <- median(gene_expression)
    gene_expression <- (gene_expression - median_expression)
    return(gene_expression) 
}

med_cent_expr<-t(apply(expr,1,median_center)) 
write.table(med_cent_expr,paste(input_file,'.mediancenter',sep=""), quote=F,sep="\t",row.names=T,col.names=F)

