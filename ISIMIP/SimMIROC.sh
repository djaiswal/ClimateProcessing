#!/bin/bash
#PBS -S /bin/bash
#PBS -M deepakebimodelling@gmail.com
#PBS -m abe
#PBS -t 2045-2045
#PBS -l mem=3GB

module load R/3.0.2
module load netcdf

R CMD BATCH --no-save "--args $PBS_ARRAYID" /home/a-m/djaiswal/Scripts/ClimateProcessing/ISIMIP/isimip-processing-MIROC.R  /home/a-m/djaiswal/Scripts/ClimateProcessing/ISIMIP/isimip-processing-MIROC$PBS_ARRAYID.Rout


