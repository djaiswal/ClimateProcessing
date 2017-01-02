source("/home/a-m/djaiswal/Scripts/ClimateProcessing/ISIMIP/yearinterval_for_isimip.R")

library(ncdf4)

maindirectory<-"/home/groups/ebimodeling/deepak_tmp/ISIMIP/"
modelname<-"HadGEM"
scenarioname<-"rcp8p5"
year<-2050

yearinterval<-yearinterval_for_isimip(year)

#Relative humidity
filename<-paste(maindirectory,modelname,"/hurs_hadgem2-es_",scenarioname,"_",yearinterval[3],".nc", sep="")
tmp0<-nc_open(filename)
rhs<-ncvar_get(tmp0)
 Lat<-ncvar_get(tmp0,"lat")
 Lon<-ncvar_get(tmp0,"lon")
 nc_close(tmp0)
          
 for (i in 1:length(Lon))
     {
     if(Lon[i]> 180)
       {
       Lon[i]<-Lon[i]-360
     }
   }
               
                N=720*360
                ISIMIPIndex<-data.frame(Ilong=numeric(N), Jlat=numeric(N), Longitude=numeric(N), Latitude=numeric(N))
                indx=1
                 for (ii in 1:720) # Longitude Index
                   {
                     for (jj in 1:360) # Latitude Index
                       {
                         if(!is.na(rhs[ii,jj,1]))
                         {
                         ISIMIPIndex$Ilong[indx]=ii
                         ISIMIPIndex$Jlat[indx]=jj
                         ISIMIPIndex$Longitude[indx]=Lon[ii]
                         ISIMIPIndex$Latitude[indx]=Lat[jj]
                         indx=indx+1
                         } 
                       }
                   }
ISIMIPIndex<-ISIMIPIndex[(ISIMIPIndex$Ilong!=0),]
save(ISIMIPIndex, file="/home/groups/ebimodeling/deepak_tmp/ISIMIP/ISIMIPIndex.RData")

                               
             
            
         
                           
                        

     

                         
