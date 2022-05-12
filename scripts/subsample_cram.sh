#!/usr/bin/bash -l
#SBATCH -p short --mem 64gb -N 1 -n 2 --out logs/subsample.log

module load samtools
module load workspace/scratch
module load BBMap

TMPDIR=$SCRATCH
# B is 4th sample
N=4
#${SLURM_ARRAY_TASK_ID}

#if [ -z $N ]; then
# N=$1
# if [ -z $N ]; then
#     echo "need to provide a number by --array slurm or on the cmdline"
#     exit
# fi
#fi

SAMPFILE=samples.csv

if [ -f config.txt ]; then
    source config.txt
fi

hostname
date
IFS=,
SEED=141
FRACTION=0.25
tail -n +2 $SAMPFILE | sed -n ${N}p | while read STRAIN READS
do
    ALNFILE=$ALNFOLDER/$STRAIN.$HTCEXT
    samtools view -O CRAM -F 4 --subsample $FRACTION --subsample-seed $SEED -o $ALNFOLDER/$STRAIN.subsample.$HTCEXT --reference $REFGENOME $ALNFILE
    samtools index $ALNFOLDER/$STRAIN.subsample.$HTCEXT
#    reformat.sh in=$SCRATCH/$STRAIN.bam out=$ALNFOLDER/$STRAIN.subsamp.bam 
done
