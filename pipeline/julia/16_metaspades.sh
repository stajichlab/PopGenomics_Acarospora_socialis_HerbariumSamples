#!/usr/bin/bash
#SBATCH -p batch --ntasks 24 --mem 384G --out logs/metaspades.%a.log -N 1
#SBATCH --array=28-29
conda create --name myenv1
source activate base 
conda activate myenv1
conda init bash
module load spades/3.15.4
module load AAFTF

SAMPLES=samples.csv
INDIR=input
OUTDIR=asm
MEM=384
CPU=$SLURM_CPUS_ON_NODE
if [ -z $CPU ]; then
	CPU=2
fi
N=${SLURM_ARRAY_TASK_ID}

if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "Need an array id or cmdline val for the job"
        exit
    fi
fi

IFS=,
sed -n ${N}p $SAMPLES | while read SAMPLE SEQFILE
do
    FILE_ARR=($INDIR/$SEQFILE)
    echo "${FILE_ARR[0]} ${FILE_ARR[1]}"
    if [ ! -d $OUTDIR/${SAMPLE} ]; then
        spades.py --meta -1 ${FILE_ARR[0]} -2 ${FILE_ARR[1]} -o $OUTDIR/${SAMPLE} --threads $CPU --mem $MEM
    elif [ ! -f $OUTDIR/${SAMPLE}/scaffolds.fasta ]; then
        spades.py -o $OUTDIR/${SAMPLE} --restart-from last
    else
        echo "Already processed $SAMPLE see $OUTDIR/$SAMPLE"
    fi
done
