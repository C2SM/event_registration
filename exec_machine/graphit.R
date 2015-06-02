## Part of "Poor Man's Registration System
## Harald von Waldow <hvw@env.ethz.ch>
## Graphs registrations
## Writes "1" into "isfull?.txt" on webserver if
## number of registrands exceeds limit
##

### CONFIGURE ###########################################################

## Host which servers the registration form. Must be reachable
## passwordless via ssh.
WEBSERVER_HOST <- ""

## Path to registration directory on webserver
WEBSERVER_REGISTRATION_PATH <- "/net/iacweb/web_disk/iaceth/events/landmip/registration_form/"

# Host on which the result-file is to be written (e.g. webserver, for downloading results, or an empty string if the results-file is to be written to a directory mounted on exec_host)
# Passwordless ssh-login must be configured
RESULTHOST <- ""

# Path on $RESULTHOST where results are to be written
RESULTPATH='/net/iacweb/web_disk/iaceth/events/landmip/result_html/'

## Limits upon reaching thereof "1" is written into the files "isfull[1-3].txt", set individual limits for each day
limit.day1 <- 50
limit.day2 <- 50
limit.day3 <- 100

## y-axis limit (max expected registrations)
MAX_REGISTRATIONS <- 110

## end of registration period
END_OF_REG = "2015-07-15"

### END CONFIGURE ######################################################

options(stringsAsFactors=FALSE)
fn <- "gfx.svg"
d <- read.table("registrations.csv", sep=';', header=TRUE)
if (nrow(d)>0) {
    ppl.now <- nrow(d)
    ppl.day1 <- sum(d[,"DAY1"], na.rm=TRUE)
    ppl.day2 <- sum(d[,"DAY2"], na.rm=TRUE)
    ppl.day3 <- sum(d[,"DAY3"], na.rm=TRUE)
    ppl.day2dinner <- sum(d[,"DAY2DINNER"], na.rm=TRUE)
    ppl.day3lunch <- sum(d[,"DAY3LUNCH"], na.rm=TRUE)
    ppl.vegetarian <- sum(d[,"VEGETARIAN"], na.rm=TRUE)
    if (ppl.day1 > limit.day1) {
        if (WEBSERVER_HOST=="") {
            system(paste("'echo \"1\" >",
                         WEBSERVER_REGISTRATION_PATH,"/isfull1.txt'",sep=''))
        } else {
            system(paste("ssh ",WEBSERVER_HOST," 'echo \"1\" >",
                         WEBSERVER_REGISTRATION_PATH,"/isfull1.txt'",sep=''))
        }
    }
    if (ppl.day2 > limit.day2) {
        if (WEBSERVER_HOST=="") {
            system(paste("'echo \"1\" >",
                         WEBSERVER_REGISTRATION_PATH,"/isfull2.txt'",sep=''))
        } else {
            system(paste("ssh ",WEBSERVER_HOST," 'echo \"1\" >",
                         WEBSERVER_REGISTRATION_PATH,"/isfull2.txt'",sep=''))
        }
    }
    if (ppl.day3 > limit.day3) {
        if (WEBSERVER_HOST=="") {
            system(paste("'echo \"1\" >",
                         WEBSERVER_REGISTRATION_PATH,"/isfull3.txt'",sep=''))
        } else {
            system(paste("ssh ",WEBSERVER_HOST," 'echo \"1\" >",
                         WEBSERVER_REGISTRATION_PATH,"/isfull3.txt'",sep=''))
        }
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
         ylim=c(0,MAX_REGISTRATIONS), xlim=c(min(d$TIME, na.rm=TRUE), as.POSIXct(END_OF_REG)),cex=1.3,cex.lab=1.6,cex.axis=1.3)
    mtext(paste("last update:",Sys.time()),3,line=-1.1,cex=1.2,adj=0.02)
    mtext(paste("Total # of registrations:", ppl.now),3,line=-3,cex=1.4, adj=0.02)
    mtext(paste("Day 1:", ppl.day1),3,line=-9,cex=1.4, adj=0.02)
    mtext(paste("Day 2:", ppl.day2),3,line=-11,cex=1.4, adj=0.02)
    mtext(paste("Day 3:", ppl.day3),3,line=-13,cex=1.4, adj=0.02)
    mtext(paste("Dinner @ day 2:", ppl.day2dinner),3,line=-15,cex=1.4, adj=0.02)
    mtext(paste("Lunch @ day 3:", ppl.day3lunch),3,line=-17,cex=1.4, adj=0.02)
    mtext(paste("Vegetarian:", ppl.vegetarian),3,line=-19,cex=1.4, adj=0.02)
    dev.off()
} else {    
    svg(filename=fn, width=12, height=9)
    par(mar=par("mar")+c(0,1,0,0))
    plot(1,1)
    mtext(paste("last update:",Sys.time()),3,line=-1.1,cex=1.2,adj=0.02)
    mtext(paste("Total # of registrations:", 0),3,line=-3,cex=1.4, adj=0.02)
    dev.off()
}
if (RESULTHOST=="") {
    system(paste("cp ",fn, " ", RESULTPATH, fn, sep=''))
} else {
    system(paste("scp ",fn, " ", RESULTHOST, ":", RESULTPATH, fn, sep=''))
}
