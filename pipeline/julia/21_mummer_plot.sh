#!/bin/bash
#SBATCH -p batch --nodes 1 --ntasks 16 --mem 16G --out logs/mummer.%A.log
module load mummer/4.0.0
mummerplot mummer_output.txt > plot.png
