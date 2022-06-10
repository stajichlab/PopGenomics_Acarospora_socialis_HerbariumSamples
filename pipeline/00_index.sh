#!/bin/bash -l
#SBATCH -p short -n 4 -N 1 --mem 8gb
module load htslib
module load samtools
module load bwa/0.7.17
module load java
module load BBMap
if [ -f config.txt ]; then
	source config.txt
fi

if [[ ! -f $REFGENOME.fai || $REFGENOME -nt $REFGENOME.fai ]]; then
	samtools faidx $REFGENOME
fi
if [[ ! -f $REFGENOME.bwt || $REFGENOME -nt $REFGENOME.bwt ]]; then
	bwa index $REFGENOME
fi

bbmap.sh ref=$REFGENOME

DICT=$(dirname $REFGENOME)/$(basename $REFGENOME .fasta)".dict"

if [[ ! -f $DICT || $REFGENOME -nt $DICT ]]; then
	rm -f $DICT
	samtools dict $REFGENOME > $DICT
	ln -s $DICT $REFGENOME.dict 
fi
