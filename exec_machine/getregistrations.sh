#!/bin/bash

# The directory in which this script is executed
EXECDIR='/home/l_hvwaldow/klimarunde2014'
# Path to .offlineimaprc
OFFLINEIMAPRCPATH='/home/l_hvwaldow/klimarunde2014/.offlineimaprc'
# Path to maildir for event registrations
MAILDIRPATH='/home/l_hvwaldow/klimarunde2014/maildir'
# String that exclusively and reliably occurs only in registration mails
MAIL_ID_STRING='To: <klimarunde2014.env.ethz.ch>'
# Host on which the result-file is to be written (e.g. webserver, for downloading results)
# Passwordless ssh-login must be configured
RESULTHOST='hvwaldow@data.c2sm.ethz.ch'
# Path on $RESULTHOST wher results are to be written
RESULTPATH='/data/lab.c2sm.ethz.ch/htdocs/website/download/'

cd "$EXECDIR" &&\
offlineimap -c "$OFFLINEIMAPRCPATH" &&\
find "$MAILDIRPATH" -type f |\
  xargs grep -l "$MAIL_ID_STRING" |\
  xargs cat > ./registrations &&\
./sedextract.sh registrations &&\
scp registrations.csv "${RESULTHOST}:${RESULTPATH}"
ssh $RESULTHOST "chmod 644 ${RESULTPATH}registrations.csv"

/usr/bin/Rscript ./graphit.R
