#!/bin/bash
#SBATCH -p batch --nodes 1 --ntasks 16 --mem 16G --out logs/mummer.%A.log
module load mummer/4.0.0
mummer SCAF_13.fa SCAF_11.fa > mummer_output.txt

