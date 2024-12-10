#!/usr/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=16 --mem 16gb
#SBATCH --output=logs/annotfunc.%a.log
#SBATCH --time=2-0:00:00
#SBATCH -p batch -J annotfunc
#SBATCH --array=1
module unload miniconda2 miniconda3 perl python
module load funannotate
module load phobius

export FUNANNOTATE_DB=/bigdata/stajichlab/shared/lib/funannotate_db
CPUS=$SLURM_CPUS_ON_NODE
OUTDIR=annotate
INDIR=genome
BUSCO=fungi_odb10

if [ -z $CPUS ]; then
  CPUS=1
fi

  funannotate annotate --antismash $OUTDIR/Acarospora/antismash_local/socialis_295874.gbk --busco_db $BUSCO -i $OUTDIR/Acarospora/predict_results --species "Acarospora socialis" --cpus $CPUS
