#!/bin/bash
#SBATCH --nodes 1 --ntasks 8 --mem 16G --out logs/antismash_b.%a.log -J antismash
#SBATCH --array=1
conda create --name myenv1
source activate base 
conda activate myenv1
conda init bash
module load antismash
which antismash
hostname
CPU=1
if [ ! -z $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi

OUTDIR=annotate
INPUTFOLDER=predict_results

 
 # if [[ ! -d $OUTDIR/$name/antismash_local && ! -s $OUTDIR/$name/antismash_local/index.html ]]; then
    #	antismash --taxon fungi --output-dir $OUTDIR/$name/antismash_local  --genefinding-tool none \
      #    --asf --fullhmmer --cassis --clusterhmmer --asf --cb-general --pfam2go --cb-subclusters --cb-knownclusters -c $CPU \
      #    $OUTDIR/$name/$INPUTFOLDER/*.gbk
    time antismash --taxon fungi --output-dir $OUTDIR/Acarospora/antismash_local \
      --genefinding-tool none --fullhmmer --clusterhmmer --cb-general \
      --pfam2go -c $CPU $OUTDIR/Acarospora/$INPUTFOLDER/*.gbk
  
