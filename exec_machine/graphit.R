## Part of "Poor Man's Registration System
## Harald von Waldow <hvw@env.ethz.ch>
## Graphs registrations
## Writes "1" into "isfull.txt" on webserver if
## number of registrands exceeds limit
##

### CONFIGURE ###########################################################

## Host which servers the registration form. Must be reachable
## passwordless via ssh.
WEBSERVER_HOST <- "hvwaldow@data.c2sm.ethz.ch"

## Path to registration directory on webserver
WEBSERVER_REGISTRATION_PATH <- "/data/lab.c2sm.ethz.ch/htdocs/website/registration_inline/klimarunde2014"

# Host on which the result-file is to be written (e.g. webserver, for downloading results)
# Passwordless ssh-login must be configured
RESULTHOST='hvwaldow@data.c2sm.ethz.ch'

# Path on $RESULTHOST wher results are to be written
RESULTPATH='/data/lab.c2sm.ethz.ch/htdocs/website/download/'

## Limit upon reaching thereof "1" is written into the file "isfull.txt"
## Only participation in part2 is limited
limit.part2 <- 430

## y-axis limit (max expected registrations)
MAX_REGISTRATIONS <- 600

## end of registration period
END_OF_REG = "2015-08-04"

### END CONFIGURE ######################################################

options(stringsAsFactors=FALSE)
fn <- "gfx.svg"
d <- read.table("registrations.csv", sep=';',header=TRUE)
ppl.now <- dim(d)[1]
ppl.part1 <- sum(d[,5], na.rm=TRUE)
ppl.part2 <- sum(d[,6], na.rm=TRUE)
ppl.apero <- sum(d[,7], na.rm=TRUE)
if (ppl.part2 >= limit.part2) {
    system(paste("ssh ",WEBSERVER_HOST," 'echo \"1\" >",
                 WEBSERVER_REGISTRATION_PATH,"/isfull.txt'",sep=''))
}
d$TIME <- as.POSIXct(strptime(d$DATE, format="%d %b %Y %H:%M:%S"))
t.offset <- min(as.double(d$TIME))
d$numTIME <- as.double(d$TIME)-t.offset
no.reg <- dim(d)[1]
d <- d[order(d$TIME),]
d$CUM <- seq(1,dim(d)[1])
dsept <- d
svg(filename=fn, width=12, height=9)
par(mar=par("mar")+c(0,1,0,0))
plot(dsept$TIME,dsept$CUM, type='l',
     ylab="Cumulative Registrations", xlab="",
     ylim=c(0,MAX_REGISTRATIONS), xlim=c(min(d$TIME, na.rm=TRUE), as.POSIXct(END_OF_REG)),
     cex=1.3,cex.lab=1.6,cex.axis=1.3)
mtext(paste("last update:",Sys.time()),3,line=-1.1,cex=1.2,adj=0.02)
mtext(paste("registrations now:", ppl.now),3,line=-3,cex=1.4, adj=0.02)
mtext(paste("registrations part 1:", ppl.part1),3,line=-9,cex=1.4, adj=0.02)
mtext(paste("registrations part 2:", ppl.part2),3,line=-11,cex=1.4, adj=0.02)
mtext(paste("registrations apero:", ppl.apero),3,line=-13,cex=1.4, adj=0.02)
dev.off()
system(paste("scp ",fn, " ", RESULTHOST, ":", RESULTPATH, fn, sep=''))
