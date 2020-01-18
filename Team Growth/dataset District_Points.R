library(httr)
library(jsonlite)
library(svDialogs)
# library(shiny)

maxyear <- dlgInput("Most Recent Season")$res
year <- 2009:maxyear

rawdistrictlist=list()
j=1
"Please wait"
for(i in year){
  rawdistricts <- GET(paste("https://www.thebluealliance.com/api/v3/districts/",i,"?X-TBA-Auth-Key=DzzDoXPk1JshyNjKpjkdDP2RHaqXNVD44xksasNYSxJu5YSmWYkTWvzA9stCcqrB",sep=""))
  rawkey <- rawToChar(rawdistricts$content)
  rawdistrictlist[[j]]  <- fromJSON(rawkey)
  j=j+1
}

fulldistricts=do.call('rbind', rawdistrictlist)
keyvector=fulldistricts$key

rankingurl <- paste("https://www.thebluealliance.com/api/v3/district/",keyvector,"/rankings?X-TBA-Auth-Key=DzzDoXPk1JshyNjKpjkdDP2RHaqXNVD44xksasNYSxJu5YSmWYkTWvzA9stCcqrB",sep="")
fullrankings=list()
k=1
"Please wait"
for(year in rankingurl){
  temp <- GET(year)
  rawranking <- rawToChar(temp$content)
  fullrankings[[k]]  <- fromJSON(rawranking)
  k=k+1
}

l=1
reducedrankings=list()
for(m in fullrankings){
  reducedrankings[[l]]=data.frame(fullrankings[[l]]$point_total,fullrankings[[l]]$team_key)
  names(reducedrankings[[l]])=c("points", "team_key")
  l=l+1
}

reducedrankings=setNames(reducedrankings,keyvector)

o=1
for(n in reducedrankings){
  write.csv(reducedrankings[[o]], file=keyvector[o],row.names = F,quote = F) 
  o=o+1
}

write.csv(keyvector, file="config",row.names = F,quote = F)

"Complete"
dlg_message("Complete.", type = "ok")
