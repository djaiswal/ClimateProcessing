#!/bin/bash
#PBS -S /bin/bash
#PBS -M deepakebimodelling@gmail.com
#PBS -m abe
#PBS -l mem=10GB

module load R/3.0.2
module load netcdf

R CMD BATCH /home/a-m/djaiswal/Scripts/ClimateProcessing/ISIMIP/ISIMIP-indexing.r  /home/a-m/djaiswal/Scripts/ClimateProcessing/ISIMIP/ISIMIP-indexing.Rout


