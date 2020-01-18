library(httr)
library(jsonlite)
library(svDialogs)
library(data.table)

if(file.exists("config")){
  keys0 <- read.csv(file = "config", colClasses = c("x" = "character"))
  keys <- c(keys0$x)
} else {
  dlg_message("Error: Config file not found.", type = "ok")
  stop()
}
input <- dlgInput("Enter Team number")$res
teamkey <- paste("frc",input,sep="")

year1 <- keys[1]
year1 <- as.numeric(substr(year1,1,4))
year2 <- tail(keys,n=1)
year2 <- as.numeric(substr(year2,1,4))

districtranking=list()
for(i in 1:length(keys)){
  districtranking[[i]]=read.csv(file = keys[i])
}

districtranking=setNames(districtranking,keys)

points=c()
year=c()
for(j in 1:length(districtranking)){
  ind=which(districtranking[[j]]$team_key==teamkey)
  counter=length(points)
  points=append(points,districtranking[[j]][ind,1])
  counter2=length(points)
  if (counter2>counter){
    tempyear=names(districtranking)[j]
    tempyear2=substr(tempyear,start = 1,stop = 4)
    year=append(year,tempyear2)
  }
}

df2=data.frame(year,points,input)

names(districtranking)

y=year2-year1
x=(y-(length(df2$year)))+2

AllData=do.call(rbind,districtranking)
AllData$year=substr(rownames(AllData),1,4)

dt_AllData=as.data.table(AllData)

setkeyv(dt_AllData,c('team_key','year')) # easy sorting for data.table class type
imp_dt_AllData=dt_AllData[,list(year=year,improv=c(-99999,diff(points))),by=c('team_key')]
imp_dt_AllData=subset(imp_dt_AllData, improv!=-99999)

boxplot(imp_dt_AllData$improv~as.numeric(imp_dt_AllData$year),xlab = "Season/Year",ylab = "Improvement")
points(x:y,diff(df2$points),type='l',lwd=2,col='red')

#plot(df)
#plot((df$year),df$points,type='l')
#plot(diff(df$points),type='l')

#ind=which(fullrankings[[1]]$team_key==teamkey)
#a=data.frame(fullrankings[[1]]$point_total,fullrankings[[1]]$team_key)
#fullrankings[[1]][ind,]
#plot(auto,score)

#hist(log(score))
#mod=lm(score~auto,data = rawData)
#summary(mod)
#plot(score~auto)
#abline(mod,col='red')
