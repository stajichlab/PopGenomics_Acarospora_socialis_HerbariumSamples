#!/bin/bash
#SBATCH --ntasks 24 --nodes 1 --mem 96G -p batch 
#SBATCH --time 72:00:00 --out logs/iprscan_b.%a.log
module unload miniconda2
module unload miniconda3
module load miniconda3/py39_4.12.0
module load anaconda
module load CodingQuarry/2.0
module load signalp/6.0g
module load gmap/2021-12-17
module load fasta/36.3.8h
module load PASA/2.5.2
module load funannotate/1.8
module unload perl
module unload python
module load signalp/4.1c
module load tmhmm/2.0c
module load iprscan
CPU=1
if [ ! -z $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi
OUTDIR=annotate

  mkdir -p $OUTDIR/Acarospora/annotate_misc
  XML=$OUTDIR/Acarospora/annotate_misc/iprscan.xml
  IPRPATH=$(which interproscan.sh)
  if [ ! -f $XML ]; then
    funannotate iprscan -i $OUTDIR/Acarospora -o $XML -m local -c $CPU --iprscan_path $IPRPATH
  fi
