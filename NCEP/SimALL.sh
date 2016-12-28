#!/bin/bash
#PBS -S /bin/bash
#PBS -M deepakebimodelling@gmail.com
#PBS -m abe
i=1948

until [ $i -ge 2012 ]

do
   qsub -j oe -d /home/a-m/djaiswal/Scripts/ClimateProcessing/NCEP/SHscripts/ SHscripts/NCEPsim${i}.sh 

i=`expr $i + 1`

done
