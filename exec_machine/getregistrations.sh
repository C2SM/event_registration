#!/bin/bash

# The directory in which this script is executed
EXECDIR='/home/l_hvwaldow/klimarunde2014'
# Path to .offlineimaprc
OFFLINEIMAPRCPATH='/home/l_hvwaldow/klimarunde2014/.offlineimaprc'
# Path to maildir for event registrations
MAILDIRPATH='/home/l_hvwaldow/klimarunde2014/maildir'
# String that exclusively and reliably occurs only in registration mails
MAIL_ID_STRING='To: <klimarunde2014.env.ethz.ch>'
# userbane@host where the result-file is to be written to.
# e.g. webserver, for downloading results, or an empty string if the 
# results-file is to be written to a directory mounted on exec_host)
# Passwordless ssh-login must be configured
RESULTHOST='hvwaldow@data.c2sm.ethz.ch'
# Path on $RESULTHOST wher results are to be written
RESULTPATH='/data/lab.c2sm.ethz.ch/htdocs/website/download/'

# RW: only consider files not marked as "trash", i.e. not ending with the letter T
# RW: handle case where $EXECDIR is on the same machine as $RESULTPATH, i.e. "$RESULTHOST" == ""
cd "$EXECDIR" &&\
offlineimap -c "$OFFLINEIMAPRCPATH" &&\
find "${MAILDIRPATH}" -type f ! -name *,ST |\
  xargs grep -l "$MAIL_ID_STRING" |\
  xargs cat > ./registrations &&\
./sedextract.sh registrations &&\
if [ $RESULTHOST ]; then
    scp registrations.csv "${RESULTHOST}:${RESULTPATH}"
    ssh $RESULTHOST "chmod 644 ${RESULTPATH}registrations.csv"
else
    cp registrations.csv "${RESULTPATH}"
    chmod 644 ${RESULTPATH}registrations.csv
fi

/usr/bin/Rscript ./graphit.R
