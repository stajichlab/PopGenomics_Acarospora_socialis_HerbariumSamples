#!/usr/bin/bash -l
#SBATCH -p batch --time 3-0:00:00 --ntasks 16 --nodes 1 --mem 24G --out logs/predict.2%a.log

module load funannotate

# this will define $SCRATCH variable if you don't have this on your system you can basically do this depending on
# where you have temp storage space and fast disks
# SCRATCH=/tmp/${USER}_$$
# mkdir -p $SCRATCH 
module load workspace/scratch

CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi

BUSCO=fungi_odb10 # This could be changed to the core BUSCO set you want to use
INDIR=genome/
OUTDIR=annotate
PREDS=$(realpath prediction_support)
mkdir -p $OUTDIR

export AUGUSTUS_CONFIG_PATH=$(realpath lib/augustus/3.3/config)
export FUNANNOTATE_DB=/bigdata/stajichlab/shared/lib/funannotate_db

SEED_SPECIES=anidulans

funannotate predict --cpus 1 --keep_no_stops --SeqCenter UCLA --busco_db $BUSCO --optimize_augustus \
        --strain 295874 --min_training_models 100 --AUGUSTUS_CONFIG_PATH $AUGUSTUS_CONFIG_PATH \
        -i $INDIR/socialis.reference.sort.mask.fasta --name ASOC295874 --protein_evidence lib/JALDZA01.1.fsa_aa  \
        -s socialis  -o $OUTDIR/Acarospora --busco_seed_species $SEED_SPECIES
