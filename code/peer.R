library(peer)
args = commandArgs(trailingOnly=TRUE)

if (length(args)!=2)
{
  stop("Input file and subtype must be supplied.", call.=FALSE)
}

input_file = args[1]
subtype = args[2]

expr <- read.table(input_file, header=T, row.names=1, check.names=F)

model = PEER()
PEER_setPhenoMean(model,t(as.matrix(expr)))
PEER_setNk(model,30)
PEER_update(model)

factors = PEER_getX(model)
factors <- t(factors)
colnames(factors) <- colnames(expr)

get_colname <- function(number)
{
	return(paste0('PEER',number))
}

rownames(factors) <- sapply(seq_along(1:nrow(factors)),get_colname)
factors<-cbind(rownames(factors),factors)
colnames(factors)[1]<-"ID"

write.table(factors, paste0('data/',subtype,'_peer_factors'), col.names=T,row.names=F,sep="\t",quote=F)
