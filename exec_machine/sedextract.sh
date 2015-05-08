#!/bin/bash

## Part of Poor Man's Registration System
## Harald von Waldow <hvw@env.ethz.ch
## filters registration emails into a csv -file


## parse the concatenated mails into interim-format
iconv -f latin1 -t utf-8 registrations\
| sed -n '
/^Message-ID:/ b newrecord
/^Date:/ H
/^Name:/ H
/^Email:/ H
/^Teil_1:/ H
/^Teil_2:/ H
/^Apero:/ H
$ b newrecord
b

:newrecord
x
p
' |sed 's/^Message-ID:.*$/NEWRECORD/' |tr "\n" ";"\
  |sed 's/^;//'\
  |sed 's/$/\n/'\
  |sed 's/NEWRECORD;/\n/g' >tmp.txt;

## Extract registration info.
## This needs to me modified for other contents of
## the registration form.
## Refer to http://www.grymoire.com/Unix/Sed.html in case of question ;). 
while read line; do
    date=`echo $line |sed -n 's/^Date:\s\{1,\}\([^;]*\).*/\1/gp'`
    date=`echo $date |sed 's/.*, \(.*\) \+.*/\1/g'`
    name=`echo $line |sed -n 's/.*Name:\s\{1,\}\([^;]*\).*$/\1/gp'`
    name=`echo $name |sed -n 's/^ *\(.*\) */\1/gp'`
    lastname=${name##* }
    email=`echo $line |sed -n 's/.*Email:\s\{1,\}\([^;]*\).*$/\1/gp'`
    teil1=`echo $line |sed -n 's/.*Teil_1:\s\{1,\}\([^;]*\).*$/\1/gp'`
    teil1=`echo $teil1 |sed -n 's/on/1/gp'`
    teil2=`echo $line |sed -n 's/.*Teil_2:\s\{1,\}\([^;]*\).*$/\1/gp'`
    teil2=`echo $teil2 |sed -n 's/on/1/gp'`
    apero=`echo $line |sed -n 's/.*Apero:\s\{1,\}\([^;]*\).*$/\1/gp'`
    apero=`echo $apero |sed -n 's/on/1/gp'`
    # Hommage to the Grand Organizer
    if [[ "$email" =~ "this.rutishauser" ]]; then apero="1"; fi
    outline="\"$lastname\";\"$name\";$email;\"$date\";$teil1;$teil2;$apero"
    echo $outline
done < tmp.txt  |awk -F\; '{ if (person[$1$2$3]++ == 0) print $0;}'  >tmp1.txt
echo "LASTENAME;FULLNAME;EMAIL;DATE;PART1;PART2;APERO" >registrations.csv
cat tmp1.txt |grep ".*[0-9a-zA-Z].*" |sort -f |uniq >>registrations.csv
rm tmp.txt; rm tmp1.txt
