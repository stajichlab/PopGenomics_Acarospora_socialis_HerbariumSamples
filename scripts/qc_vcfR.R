library(vcfR)

vcf_file="vcf/ASHerb_JNA_AS_4_v1.SNP.combined_selected.vcf.gz"
dna_file="genome/glAcaSoci1.NCBI.haploid.fasta"

dna <- ape::read.dna(dna_file, format = "fasta")
vcf <- read.vcfR( vcf_file, verbose = FALSE )
chrom <- create.chromR(name='Supercontig', vcf=vcf, seq=dna)
plot(chrom)
chromFilt <- masker(chrom, min_QUAL = 1, min_DP = 30, max_DP = 60, min_MQ = 59,  max_MQ = 60.1)
plot(chromFilt)
chromProc <- proc.chromR(chromFilt, verbose=TRUE)
plot(chromProc)
chromoqc(chromProc, dp.alpha=20)
ad <- extract.gt(vcf, element = 'AD')
knitr::kable(ad[c(1:2,11,30),1:2])
allele1 <- masplit(ad, record = 1)
allele2 <- masplit(ad, record = 2)
ad1 <- allele1 / (allele1 + allele2)
ad2 <- allele2 / (allele1 + allele2)

hist(ad2[,"BigSheepPass"], breaks = seq(0,1,by=0.02), col = "#1f78b4", xaxt="n")
hist(ad1[,"BigSheepPass"], breaks = seq(0,1,by=0.02), col = "#a6cee3", add = TRUE)
axis(side=1, at=c(0,0.25,0.333,0.5,0.666,0.75,1), labels=c(0,"1/4","1/3","1/2","1/3","3/4",1))

# remove homozygotes
gt <- extract.gt(vcf, element = 'GT')
hets <- is_het(gt)

is.na( ad[ !hets ] ) <- TRUE

allele1 <- masplit(ad, record = 1)
allele2 <- masplit(ad, record = 2)

ad1 <- allele1 / (allele1 + allele2)
ad2 <- allele2 / (allele1 + allele2)

hist(ad2[,"BigSheepPass"], breaks = seq(0,1,by=0.02), col = "#1f78b4", xaxt="n")
hist(ad1[,"BigSheepPass"], breaks = seq(0,1,by=0.02), col = "#a6cee3", add = TRUE)
axis(side=1, at=c(0,0.25,0.333,0.5,0.666,0.75,1), labels=c(0,"1/4","1/3","1/2","1/3","3/4",1))


ad <- extract.gt(vcf, element = 'AD')
#ad[1:3,1:4]

allele1 <- masplit(ad, record = 1)
allele2 <- masplit(ad, record = 2)

# Subset to a vector for manipulation.
tmp <- allele1[,"BigSheepPass"]
#sum(tmp == 0, na.rm = TRUE)
#tmp <- tmp[tmp > 0]
tmp <- tmp[tmp <= 30]

hist(tmp, breaks=seq(0,30,by=1), col="#808080", main = "BigSheepPass")

sums <- apply(allele1, MARGIN=2, quantile, probs=c(0.15, 0.95), na.rm=TRUE)
sums[,"BigSheepPass"]

tmp <- allele2[,"BigSheepPass"]
tmp <- tmp[tmp>0]
tmp <- tmp[tmp<=30]

hist(tmp, breaks=seq(1,30,by=1), col="#808080", main="BigSheepPass")

sums[,"BigSheepPass"]
abline(v=sums[,"BigSheepPass"], col=2, lwd=2)
