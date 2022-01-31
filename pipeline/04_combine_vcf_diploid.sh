#!/usr/bin/bash
#SBATCH -p intel --mem 64gb -N 1 -n 4 --out logs/concat_vcf_diploid.log -p short

module unload miniconda2
module load miniconda3
source activate cyvcf2
module load bcftools
module load yq

CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi
if [ -f config.txt ]; then
	source config.txt
else
	echo "need a config.txt"
fi

if [ -z $FINALVCF ]; then
	echo "Need to define FINALVCF in config.txt"
	exit
fi
if [ -z $SLICEVCF ]; then
	echo "Need to define SLICEVCF in config.txt"
	exit
fi
if [[ -z $POPYAML || ! -s $POPYAML ]]; then
	echo "Cannot find \$POPYAML variable - set in config.txt"
	exit
fi
IN=$SLICEVCF.diploid
FINALVCF=$FINALVCF.diploid
mkdir -p $FINALVCF

for POPNAME in $(yq eval '.Populations | keys' $POPYAML | perl -p -e 's/^\s*\-\s*//' | grep TestFresh)
do
  for TYPE in SNP INDEL
  do
     OUT=$FINALVCF/$PREFIX.$POPNAME.$TYPE.combined_selected.vcf.gz
     QC=$FINALVCF/$PREFIX.$POPNAME.$TYPE.combined_selected.QC.txt
     if [ ! -s $OUT ];  then
     	bcftools concat -Oz -o $OUT --threads $CPU $IN/$POPNAME/${PREFIX}.*.${TYPE}.selected.vcf.gz
     	tabix $OUT
     fi
     if [[ ! -s $QC || $OUT -nt $QC ]]; then
     	./scripts/vcf_QC_report.py --vcf $OUT -o $FINALVCF/$PREFIX.$POPNAME.$TYPE.combined_selected.QC.txt
     fi

   done
 done
