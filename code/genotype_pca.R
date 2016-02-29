args = commandArgs(trailingOnly=TRUE)

if (length(args)!=2)
{
  stop("Input file and subtype must be supplied.", call.=FALSE)
}

input_file = args[1]
subtype = args[2]

genotype_pc <- function(snp_filename, subtype)
{
	library(ggplot2)
	snps <- read.table(snp_filename,header=T,row.names=1,stringsAsFactors=F,check.names=F)
	oldsnpcolnames <- colnames(snps)
	colnames(snps) <- paste('x', colnames(snps),sep='')
	snp_pc <- princomp(~ ., data=snps, center=F,scale=F,na.action=na.omit)

	pc1_2 <- as.data.frame(snp_pc$loadings[,1:2])
	rownames(pc1_2) <- oldsnpcolnames
	colnames(pc1_2) <- c("PC1","PC2")
	pc1_2 <- t(pc1_2)
	pc1_2<- cbind(rownames(pc1_2), pc1_2)
	colnames(pc1_2)[1] = "ID"
	write.table(pc1_2,paste0('data/',subtype,'_genotype_pc_covariates'),col.names=T,row.names=F,quote=F,sep="\t")

	pdf(paste0(subtype,'_genotype-screeplot.pdf'))
	screeplot(snp_pc, type='lines')
	dev.off()

	p1p2 <- cbind(snp_pc$loadings[,1],snp_pc$loadings[,2])

	race <- read.table('id-race',header=F,row.names=1,na.strings='NA',stringsAsFactors=T)
	rownames(race) <- paste('x', rownames(race),sep='')
	pc1pc2<-cbind.data.frame(p1p2,race$V2[match(rownames(p1p2),rownames(race))])
	colnames(pc1pc2) <- c('PC1','PC2','Race')

	pcaplot<-ggplot(pc1pc2,aes(x=PC1,y=PC2,colour=factor(Race)))+geom_point()+labs(x="PC1",y="PC2",colour="Race",title=paste0(subtype," PC1 vs PC2"))
	ggsave(paste0('results/',subtype,'_pc1_pc2.pdf'),plot=pcaplot)
}

genotype_pc(input_file, subtype)
