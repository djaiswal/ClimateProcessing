# To read Index for a given latitude and Longitude
getNARRforBioCro<-function(lat,lon,year){
USlayer<-read.table("/home/groups/ebimodeling/met/NARR/ProcessedNARR/NARRindex.txt")
index=which.min((lat-USlayer$Latt)^2+(lon-USlayer$Lonn)^2)
i=USlayer$Iindex[index]
j=USlayer$Jindex[index]
filename=paste("/home/groups/ebimodeling/met/NARR/ProcessedNARR/",year,formatC(i,width=3,flag=0),formatC(j,width=3,flag=0),".RData",sep="")
load(filename)
return(dat)
}


getNARRsoil<-function(lat,lon,year){
USlayer<-read.table("/home/groups/ebimodeling/met/NARR/ProcessedNARR/NARRindex.txt")
index=which.min((lat-USlayer$Latt)^2+(lon-USlayer$Lonn)^2)
i=USlayer$Iindex[index]
j=USlayer$Jindex[index]
filename=paste("/home/groups/ebimodeling/met/NARR/ProcessedNARR/soilm/",year,formatC(i,width=3,flag=0),formatC(j,width=3,flag=0),".RData",sep="")
load(filename)
return(sSoilm)
}



