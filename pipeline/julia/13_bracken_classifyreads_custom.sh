#!/bin/bash -l

#SBATCH --partition=batch
#SBATCH --cpus-per-task=24
#SBATCH --mem=200g
#SBATCH --time=0-72:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name="kracken"

# Building custom Kraken database
module load kraken2/2.1.2
module load ncbi-blast	

DBNAME="custom_DB"
#FNA="/bigdata/stajichlab/shared/projects/Lichen/Acarospora_socialis_HerbariumSamples/custom_DB/library/lichen/lichen.fna"
fa_dir_1KFG=/bigdata/stajichlab/shared/projects/1KFG/2021/NCBI_fungi/assemblies/DNA
find ${fa_dir_1KFG}/ -name '*.fasta' -print0 | xargs -0 -I{} -P 8 -n1 kraken2-build --add-to-library {} --db $DBNAME

#kraken2-build --add-to-library $FNA --db $DBNAME

kraken2-build --build --threads 24 --db $DBNAME

echo "custom build complete"
