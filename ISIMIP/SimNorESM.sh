#!/bin/bash
#PBS -S /bin/bash
#PBS -M deepakebimodelling@gmail.com
#PBS -m abe
#PBS -t 2050-2050
#PBS -l mem=3GB

module load R/3.0.2
module load netcdf

R CMD BATCH --no-save "--args $PBS_ARRAYID" /home/a-m/djaiswal/Scripts/ClimateProcessing/ISIMIP/isimip-processing-NorESM.R  /home/a-m/djaiswal/Scripts/ClimateProcessing/ISIMIP/isimip-processing-NorESM$PBS_ARRAYID.Rout


