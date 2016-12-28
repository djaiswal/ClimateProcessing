
library(ncdf4)

                    shum<-array(0,dim=c(192,94,366))
                 
     tmp0<-nc_open(paste("/home/groups/ebimodeling/met/NCEP/SpecificHumidity/shum.2m.gauss.",2000,".nc",sep=""))
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
               
                N=192*94
               NCEPIndex<-data.frame(Ilong=numeric(N), Jlat=numeric(N), Longitude=numeric(N), Latitude=numeric(N))
                indx=1
                 for (ii in 1:192) # Longitude Index
                   {
                     for (jj in 1:94) # Latitude Index
                       {
                         NCEPIndex$Ilong[indx]=ii
                         NCEPIndex$Jlat[indx]=jj
                         NCEPIndex$Longitude[indx]=Lon[ii]
                         NCEPIndex$Latitude[indx]=Lat[jj]
                         indx=indx+1
                       }
                   }
save(NCEPIndex, file="/home/groups/ebimodeling/met/NCEP/NCEPIndex.RData")

                               
             
            
         
                           
                        

     

                         
