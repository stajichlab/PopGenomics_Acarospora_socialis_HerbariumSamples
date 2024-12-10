#!/bin/bash
#SBATCH -p batch --nodes 1 --ntasks 16 --mem 16G --out logs/translate_strigata_search.%A.log

module load parallel
module load fasta/36.3.8h
#mkdir -p EXPANDED-results
CUTOFF=1e-5
QUERY=protein/mat1-1-1_pep.fasta
DBFOLDER=strigata/GCA_022814355.1_ASM2281435v1_genomic.fna
OUTDIR=tfastx3_results
PREF=$(basename $QUERY .fasta) #this is going to name the file after the query

CPU=$SLURM_CPUS_ON_NODE
CPU_PER=2
JOBS=1
if [ ! $CPU ]; then
    CPU=1
    CPU_PER=1
    JOBS=1
else
    #do math....
    JOBS=$(expr $CPU / $CPU_PER)
fi

mkdir -p $OUTDIR
mkdir -p logs/

search() {
    dna=$1
    echo "DNA is $dna"
    REPORT=$OUTDIR"/"$PREF"-vs-"$(basename $dna .fasta)".TFASTX.tab"
    echo "REPORT IS $REPORT OUTDIR is $OUTDIR QUERy is $QUERY"
    if [ ! -e $REPORT ]; then
        tfastx36 -T $CPU_PER -m 8c -d 0 -E $CUTOFF $QUERY $dna  > $REPORT
    fi
}

export OUTDIR PREF CPU_PER QUERY CUTOFF
export -f search

parallel -j $JOBS search ::: $DBFOLDER
