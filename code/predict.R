args = commandArgs(trailingOnly=TRUE)

if (length(args)==0)
{
  stop("Input file must be supplied.", call.=FALSE)
}

input_file = args[1]

expr<-read.table(input_file,header=T,row.names=1, check.names=F)
centroids<-read.table('data/centroids.tsv',header=F,row.names=1)

predict_subtype <- function(expr)
{
  subtypes = c('TRU','prox.-prolif.','prox.-inflam')
  vec <- c(cor(expr,centroids$V2),cor(expr,centroids$V3),cor(expr,centroids$V4))
  return(subtypes[which(vec==max(vec))])
}

preds <- as.data.frame(lapply(expr, predict_subtype))
colnames(preds) <- colnames(expr)
write.table(preds,"data/subtype-predictions",quote=F,sep="\t",col.names=T, row.names=F)

TRU_samples <- t(c("ID", colnames(preds)[preds=="TRU"]))
PP_samples <- t(c("ID", colnames(preds)[preds=="prox.-prolif."]))
PI_samples <- t(c("ID", colnames(preds)[preds=="prox.-inflam"]))

write.table(TRU_samples, "data/TRU_samples", quote=F, sep="\t", col.names=F, row.names=F)
write.table(PP_samples, "data/PP_samples", quote=F, sep="\t", col.names=F, row.names=F)
write.table(PI_samples, "data/PI_samples", quote=F, sep="\t", col.names=F, row.names=F)
