#!/bin/bash

# The directory in which this script is executed
EXECDIR='/home/richardw/Documents/org/event_registration/exec_machine'
# Path to .offlineimaprc
OFFLINEIMAPRCPATH='/home/richardw/Documents/org/event_registration/exec_machine/.offlineimaprc'
# Path to maildir for event registrations
MAILDIRPATH='/home/richardw/Documents/org/event_registration/exec_machine/maildir'
# String that exclusively and reliably occurs only in registration mails
MAIL_ID_STRING='[LandMIP 2015 Registration]'
# Host on which the result-file is to be written (e.g. webserver, for downloading results, or an empty string if the results-file is to be written to a directory mounted on exec_host)
# Passwordless ssh-login must be configured
RESULTHOST=''
# Path on $RESULTHOST wher results are to be written
RESULTPATH='/net/iacweb/web_disk/iaceth/events/landmip/result_html/'

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
