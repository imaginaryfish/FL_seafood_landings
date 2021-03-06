library(lubridate)

setwd('~/Documents/R/Github/FL_seafood_landings/data')

### load data, skip first 9 lines because they are metadata
data <- read.csv('fl_landings_year.csv',skip=9)
### make some factors for easier parsing
data$Area.Description <- as.factor(data$Area.Description)
data$Species <- as.factor(data$Species)
### pull out Gag Grouper
ind_gag <- grep('gag',data$Species,ignore.case = T)
### pull out Ft Myers
ind_FM <- grep('fort myers',data$Area.Description,ignore.case = T)
### pull out Gag landed in Fort Myers
ind_FM_gag <- base::intersect(ind_gag,ind_FM)

gag <- data[ind_FM_gag,]

barplot(gag$Pounds,names.arg = gag$Year)
barplot(gag$Estimated.Value,names.arg = gag$Year)


### data by month
data <- read.csv('fl_landings_month.csv',skip=9)
data <- data[data$Year>2013,]
ind_gag <- grep('grouper, red',data$Species,ignore.case = T)
ind_ytd <- which(data$Month=='January' |
                      data$Month=='February' |
                      data$Month=='March' |
                      data$Month=='April' |
                      data$Month=='May' |
                      data$Month=='June')
### pull out Gag landed in year to date
ind_gag_ytd <- base::intersect(ind_gag,ind_ytd)
gag <- data[ind_gag,]
gag <- data[ind_gag_ytd,]
# gag <- data
sum_agg <- aggregate(gag$Estimated.Value,by=list(gag$Year),sum,na.rm=T)
plot(sum_agg$Group.1,sum_agg$x)

plot(gag$Year,gag$Pounds)
plot(gag$Year,gag$Estimated.Value)

boxplot(gag$Pounds~gag$Year)
boxplot(gag$Estimated.Value~gag$Year)

mths <- unique(gag$Month)
# plot(0,0,xlim=c(2013,2021),ylim=c(1e5,25e5))
setwd('~/Documents/R/Github/FL_seafood_landings/figures')
png('grouper_landings.png',width=12,height=10,units='in',res=300)
par(bg='gray20',mar=c(5,5,4,1))
b <- boxplot(gag$Estimated.Value~gag$Year,
             at=2014:2020,
             col='gray20',variwidth=T,border='white',
             xlab='Year',ylab='Estimated Value (millions USD)',
             staplewex=0,lty=1,lwd=2,axes=F,col.lab='white',cex.lab=2)
axis(1, col="white", col.ticks="white", col.axis="white", cex.axis=1.5)
axis(2, seq(5e5,25e5,5e5), seq(.5,2.5,.5), col="white", col.ticks="white", col.axis="white", cex.axis=1.5,las=1)
title('Florida red grouper landings ',cex.main=3,col.main='white')
mtext('Source: Florida Fish and Wildlife Commission',
      line=3,side=1,adj=1,cex=1,col='white')
mtext('Graphic by: Brendan Turley @crabtails',
      line=4,side=1,adj=1,cex=1,col='white')
box(col='white')
for(i in 1:6){
  temp <- gag[gag$Month==mths[i],]
  points(temp$Year,temp$Estimated.Value,
         col=(i+1),pch=i,lty=i,typ='b',lwd=4,cex=4)
}
legend('topright',
       c('Jan','Feb','Mar','Apr','May','Jun'),
       pch=1:6,col=2:7,bty='n',cex=2,lwd=3,text.col='white',pt.cex=3,lty=1:6)
dev.off()
# median_agg <- aggregate(gag$Estimated.Value,by=list(gag$Year),median,na.rm=T)
# points(median_agg$Group.1,median_agg$x,pch='-',cex=2,lwd=3)

sum_agg <- aggregate(gag$Estimated.Value,by=list(gag$Year),mean,na.rm=T)
plot(sum_agg)
