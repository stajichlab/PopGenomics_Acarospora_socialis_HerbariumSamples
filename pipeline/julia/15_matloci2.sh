#!/bin/bash -l
#SBATCH -p intel -N 1 -n 8 --mem 16gb  --out logs/Matloci2.log

module load ncbi-blast/2.13.0+
module load ncbi_edirect/16.8.20220329 
efetch -db nuccore -id JX402947.1 -format fasta > clavigera_mat1_1.fna
#make a database
makeblastdb -in clavigera_mat1_1.fna -dbtype nucl -out glAcaSoci1.NCBI.haploid.fasta
#run nucleotide BLAST
blastn -db glAcaSoci1.NCBI.haploid.fasta -query clavigera_mat1_1.fna -evalue 1e-5 -outfmt 6 -out clavigera_mat1_1.blastx.tab
