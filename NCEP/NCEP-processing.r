## I'm trying to figure out ways of manipulating netCDF data

args <- commandArgs(TRUE)

if(length(args) == 0){
  warning("args is missing")
}else{
  k <- as.character(args)
}
k<-as.numeric(k)
isleapyear<-function(year){
  if(year%%100==0)
    {
    if(year%%400==0)test<-1
    }
  else
    {
      if(year%%4==0) {
                      test<-1
                    }
      else test<-0
    }
  test
}
library(ncdf4)
library(BioCro,lib.loc="/home/a-m/djaiswal/R/library")
#get how many years are needed in the 4th dimension of climate data to aggregate
dimyr<-1

#this variable is to track year's ID index in multidimensional array
iyear<-0
 #declare arrays for each of the five variables needed (ignore 366 days of leap year)
                             shum4d<-array(0,dim=c(192,94,366,dimyr))
                             solar4d<-array(0,dim=c(192,94,366,dimyr))
                              temp4d<-array(0,dim=c(192,94,366,dimyr))
                             tempmin4d<-array(0,dim=c(192,94,366,dimyr))
                              tempmax4d<-array(0,dim=c(192,94,366,dimyr))
                               wind4d<-array(0,dim=c(192,94,366,dimyr))
                               precip4d<-array(0,dim=c(192,94,366,dimyr))
iii<-k-1
for (i in 1:dimyr)
    {

                           #declaring array to read netcdf files
                    shum<-array(0,dim=c(192,94,366))
                    solar<-array(0,dim=c(192,94,366))
                    temp<-array(0,dim=c(192,94,366))
                    tempmin<-array(0,dim=c(192,94,366))
                    tempmax<-array(0,dim=c(192,94,366))
                    wind<-array(0,dim=c(192,94,366))
                    precip<-array(0,dim=c(192,94,366))

      
     iii<-iii+1 
     tmp0<-nc_open(paste("/home/groups/ebimodeling/met/NCEP/SpecificHumidity/shum.2m.gauss.",iii,".nc",sep=""))
     shum<-ncvar_get(tmp0)
     nc_close(tmp0)
     tmp0<-nc_open(paste("/home/groups/ebimodeling/met/NCEP/Temperature/air.2m.gauss.",iii,".nc",sep=""))
     temp<-ncvar_get(tmp0)
     nc_close(tmp0)
     tmp0<-nc_open(paste("/home/groups/ebimodeling/met/NCEP/MinTemperature/tmin.2m.gauss.",iii,".nc",sep=""))
     tempmin<-ncvar_get(tmp0)
     nc_close(tmp0)
     tmp0<-nc_open(paste("/home/groups/ebimodeling/met/NCEP/MaxTemperature/tmax.2m.gauss.",iii,".nc",sep=""))
     tempmax<-ncvar_get(tmp0)
     nc_close(tmp0)
     tmp0<-nc_open(paste("/home/groups/ebimodeling/met/NCEP/WindspeedU/uwnd.10m.gauss.",iii,".nc",sep=""))
     wind<-ncvar_get(tmp0)
     nc_close(tmp0)
     tmp0<-nc_open(paste("/home/groups/ebimodeling/met/NCEP/SolarRadiation/dswrf.sfc.gauss.",iii,".nc",sep=""))
     solar<-ncvar_get(tmp0)
     nc_close(tmp0)
     tmp0<-nc_open(paste("/home/groups/ebimodeling/met/NCEP/Precipitation/prate.sfc.gauss.",iii,".nc",sep=""))
     precip<-ncvar_get(tmp0)
             Lat<-ncvar_get(tmp0,"lat")
             Lon<-ncvar_get(tmp0,"lon")
     nc_close(tmp0)
           iyear<-iyear+1 # year index is outside tripple for loop because it is controlled by outside for loop [i]
                     for (ii in 1:192) #longitude index
                     {
                       for(jj in 1:94)#latitude index
                         {
                          for(kk in 1:365)# day index (ignoring leap year for now)
                            {
                              shum4d[ii,jj,kk,iyear]=shum[ii,jj,kk]
                               temp4d[ii,jj,kk,iyear]=temp[ii,jj,kk]
                               tempmin4d[ii,jj,kk,iyear]=tempmin[ii,jj,kk]
                               tempmax4d[ii,jj,kk,iyear]=tempmax[ii,jj,kk]
                               wind4d[ii,jj,kk,iyear]=wind[ii,jj,kk]
                               solar4d[ii,jj,kk,iyear]=solar[ii,jj,kk]
                               precip4d[ii,jj,kk,iyear]=precip[ii,jj,kk]
                              
                             }
                           }
                     }
          # remove unnecessary  R objects. They are recycled in the loop if planting and harvesting takes place in different year
             remove(shum,temp,wind,solar,precip,tempmin,tempmax)           
                  }

##Note that spatial range of NCP data is 0 to 360 East
#Which Means 0 to 180 are represent correctly Eastwards and 180 to 360 East simply represents -180 to 0 West
#However, in order to interpret -180 to -360 (w.r.t google, for e.g) we must make following changes
# Lon=Lon+360, so -360 is represented by 0 and -330E is represented by +30E
             
             doy<-seq(1,365)
for (i in 1:length(Lon))
     {
     if(Lon[i]> 180)
       {
       Lon[i]<-Lon[i]-360
     }
   }
 
                 for (ii in 1:192) # Longitude Index 192
                   {
                     for (jj in 1:94) # Latitude Index 94
                       {
                         currentlon<-Lon[ii]
                         currentlat<-Lat[jj]
                                weachyear<-numeric(0)
                                weachday<-numeric(0)
                                weachhumidity<-numeric(0)
                                weachsolar<-numeric(0)
                                weachtemp<-numeric(0)
                                weachwind<-numeric(0)
                                weachprecip<-numeric(0)
                                weachtempmax<-numeric(0)
                                weachtempmin<-numeric(0)
                                   dimyr<-1
                                    for (i in 1:dimyr) # this loop will go multiple times depending on diff betwn harvest and plant
                                    {
                                     iweachyr<-k+i-1
                                     weachyear<-as.vector(c(weachyear,rep(iweachyr,365)))
                                     weachday<-as.vector(c(weachday,seq(1,365)))
                                     # get year index for 4D climdate data,which starts from 1 to number of years
                                     # i also works for the index of 4D array containing data
                                     weachtemp<-as.vector(c(weachtemp,temp4d[ii,jj,1:365,i]))
                                     weachtempmax<-as.vector(c(weachtempmax,tempmax4d[ii,jj,1:365,i]))
                                     weachtempmin<-as.vector(c(weachtempmin,tempmin4d[ii,jj,1:365,i]))
                                     weachhumidity<-as.vector(c(weachhumidity,shum4d[ii,jj,1:365,i]))
                                     weachsolar<-as.vector(c(weachsolar,solar4d[ii,jj,1:365,i]))
                                     weachwind<-as.vector(c(weachwind,wind4d[ii,jj,1:365,i]))
                                     weachprecip<-as.vector(c(weachprecip,precip4d[ii,jj,1:365,i]))

                                    #here I am simply adding one extra row for leap year to avoid probllem with newWEACH
                                     if(isleapyear(iweachyr)==1)
                                             {
                                              weachyear<-c(weachyear,iweachyr)
                                              weachday<-c(weachday,366)
                                              weachtemp<-c(weachtemp,temp4d[ii,jj,365,i]) # simply copy value from last day
                                              weachtempmax<-c(weachtempmax,tempmax4d[ii,jj,365,i])
                                              weachtempmin<-c(weachtempmin,tempmin4d[ii,jj,365,i])
                                              weachhumidity<-c(weachhumidity,shum4d[ii,jj,365,i])
                                              weachsolar<-c(weachsolar,solar4d[ii,jj,365,i])
                                              weachwind<-c(weachwind,wind4d[ii,jj,365,i])
                                              weachprecip<-c(weachprecip,precip4d[ii,jj,365,i]) 
                                            }
                                  }
                           # Now we have extracted all the variables needed
                           #but
                           # unit conversion is needed
                           weachtemp<-weachtemp-273    # kelvin to Centigrade
                           weachtempmax<-weachtempmax-273  # kelvin to centigrade
                           weachtempmin<-weachtempmin-273  # kelvin to Centigrade
                
                           weachsolar<-weachsolar*24*60*60*1e-6 # W/m2 to MJ/m2
                           weachwind<-abs(weachwind*3.85) # wind speed from 10m to 2m an dm/2 to miles/h
                           weachprecip<-weachprecip*(24*60*60)*(1/1000)*39.37 #conerting kg/m2sec to kg.m2 to inches
                           ######################################################################
                           # converting specific humidity into relative humidity (surface flux data does not have RH
                           # reference for calculation "The Rotronic Humidity HandBook"
                           mixingratio<-weachhumidity/(1-weachhumidity)*1000
                          # using mixing ratio and atm pressure, find partial press of water in pascal
                           waterpartialpress<-(1e+5)*mixingratio/(621.9+mixingratio) # in pascal
                           # saturated water vapor pressure using antoine equation
                           satwatervappressmax<-(8.07131-(1730.63/(244.485+weachtempmax)))*133 # in pascal
                           relativehumiditymin<-(waterpartialpress)/(satwatervappressmax) #RH fraction
                           satwatervappressmin<-(8.07131-(1730.63/(244.485+weachtempmin)))*133 # in pascal
                           relativehumiditymax<-(waterpartialpress)/(satwatervappressmin)#RH fraction
                           relativehumidity<-0.5*( relativehumiditymax+relativehumiditymin)

                           # getting rid of missing/strange values (very small negative) of other troublesome climate data to avoid error in simulation
                           weachsolar<-ifelse(weachsolar>32765,30,weachsolar)
                           weachsolar<-ifelse(weachsolar<0,0,weachsolar)
                           weachtempmax<-ifelse(weachtempmax>32765,30,weachtempmax)
                           weachtempmax<-ifelse(weachtempmax<0,0,weachtempmax)
                           weachtempmin<-ifelse(weachtempmin>32765,30,weachtempmin)
                           weachtempmin<-ifelse(weachtempmin<0,0,weachtempmin)
                           weachtemp<-ifelse(weachtemp>32765,30,weachtemp)
                           weachtemp<-ifelse(weachtemp<0,0,weachtemp)
                           relativehumiditymin<-ifelse(relativehumiditymin>1,0.6,relativehumiditymin) # using 1 here for now, later chekc from NCEP website whats being used for missing value
                           relativehumiditymin<-ifelse(relativehumiditymin<0,0.1,relativehumiditymin)
                           relativehumiditymax<-ifelse(relativehumiditymax>1,0.6,relativehumiditymax) # using 1 now
                           relativehumiditymax<-ifelse(relativehumiditymax<0,0.1,relativehumiditymax)
                           relativehumidity<-ifelse(relativehumidity>1,0.6,relativehumidity) #using 1 now
                           relativehumidity<-ifelse(relativehumidity<0,0.1,relativehumidity)
                           weachwind<-ifelse(weachwind>32765,30,weachwind)
                           weachwind<-ifelse(weachwind<0,2,weachwind)
                           weachprecip<-ifelse(weachprecip>32765,0,weachprecip)
                           weachprecip<-ifelse(weachprecip<0,0,weachprecip)
                           
          
                    #Now we are ready to make dataframe to call weach
                   forweach<-data.frame(year=weachyear,day=weachday,solarR=weachsolar,Tmax=weachtempmax,Tmin= weachtempmin,Tavg= weachtemp,RHmax=relativehumiditymax,RHmin=relativehumiditymin,RHavg=relativehumidity,WS= weachwind,precip= weachprecip)
                    #call weachNEW
                    dat<-weachNEW(forweach,lat=-23,ts=1, temp.units="Celsius", rh.units="fraction",ws.units="mph",pp.units="in")
                    filename=paste("/home/groups/ebimodeling/met/NCEP/NCEPProcessed/",k,formatC(ii,width=3,flag=0),formatC(jj,width=3,flag=0),".RData",sep="")
                    save(dat,file=filename)                                  
                       }#latitude index
                   } #longitude index
             
            
         
                           
                        

     

                         
