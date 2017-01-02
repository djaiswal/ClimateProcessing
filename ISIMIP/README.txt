Purpose of isimip-indexing.sh is to create a file to relate index i an dindex j with latitude and longitude. This file is created so that access to processed weacther file can be made easily based on simply values of i and j (of ISIMIP climate data).

to run use qsub isimip-indexing.sh

To process climate data for each of the five models, do run:
qsub Simgfdl.sh 
qsub  SimHadgem.sh  
qsub SimIPSL.sh  
qsub SimMIROC.sh  
qsub SimNorESM.sh

[requires original .nc files in the ebimodlling folder]

#running all the simulations may result in error (perhaps due to memory
restrictions). Therefore, identify which output was not correctly produced and
then rerun it only. for Example qsub SimHadGEM.sh resulted in error in 2044
year. However, when I rerun 2044 alone, everything was fine.







