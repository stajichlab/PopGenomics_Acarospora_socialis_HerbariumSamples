#!/bin/bash
#SBATCH -p short --nodes 1 --ntasks 16 --mem 16G --out logs/extract.%A.log

#1. Convert a multi-line multi-fasta file <$fasta> into a one-liner multi-fasta <$converted_fasta> and sort the one-liner in numerical order.
# **(replace $fasta and $converted_fasta with real file names)**

awk '/^>/ {printf("\n%s__",$0);next; } { printf("%s__",$0);}  END {printf("\n");}' /bigdata/stajichlab/shared/projects/Lichen/Acarospora_socialis_HerbariumSamples/genome/glAcaSoci1.NCBI.haploid.fasta | sort -n > converted_glAcaSoci1.NCBI.haploid.fasta

#2. Sort and make unique your ID headers. (replace $GOOD_ID and $GOOD_ID_sorted with real file names)

sort -n SCAF_11.txt | sort -u > SCAF_11_sorted.txt

#3. Use the fixed-string fgrep combined with LC_ALL=C command to extract all fasta sequences matched to the headers. 

LC_ALL=C fgrep -w -f SCAF_11_sorted glAcaSoci1.NCBI.haploid.fasta | awk -F'__' '{for(i=1; i<NF; i+=1) {print $i}}' > SCAF_11.fasta

