#!/bin/bash -l
#SBATCH -p intel -N 1 -n 8 --mem 16gb  --out logs/Matloci.log

module load ncbi-blast/2.13.0+
module load ncbi_edirect/16.8.20220329 
efetch -db nuccore -id JX402933.1 -format fasta > clavigera.fna
#make a database
makeblastdb -in glAcaSoci1.NCBI.haploid.fna -dbtype nucl -out glAcaSoci1.NCBI.haploid
#run nucleotide BLAST
blastn -db glAcaSoci1.NCBI.haploid.fasta -query clavigera.fna -evalue 1e-5 -outfmt 6 -out clavigera.blastx.tab


