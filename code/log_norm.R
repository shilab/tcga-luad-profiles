args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) 
{
  stop("Input file must be supplied.", call.=FALSE)
}

input_file = args[1]

expr<-read.table(input_file,header=T,row.names=1)

zeroind <- which(expr==0,arr.ind=T)
minimum <- min(expr[expr>0])
expr[zeroind] <- minimum

log_expr <- log2(expr) 
write.table(log_expr,paste(input_file,'.norm',sep=""), quote=F,sep="\t",row.names=T,col.names=T)
