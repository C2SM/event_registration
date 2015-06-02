#!/bin/bash

## Part of Poor Man's Registration System
## Harald von Waldow <hvw@env.ethz.ch
## filters registration emails into a csv -file


## parse the concatenated mails into interim-format
iconv -f latin1 -t utf-8 registrations\
| sed -n '
/^Message-ID:/ b newrecord
/^Date:/ H
/^FirstName:/ H
/^LastName:/ H
/^Affiliation:/ H
/^Email:/ H
/^Day1:/ H
/^Day2:/ H
/^Day3:/ H
/^Day2Dinner:/ H
/^Day3Lunch:/ H
/^Vegetarian:/ H
/^Remarks:/ H
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
    firstname=`echo $line |sed -n 's/.*FirstName:\s\{1,\}\([^;]*\).*$/\1/gp'`
    firstname=`echo $firstname |sed -n 's/^ *\(.*\) */\1/gp'`
    lastname=`echo $line |sed -n 's/.*LastName:\s\{1,\}\([^;]*\).*$/\1/gp'`
    lastname=`echo $lastname |sed -n 's/^ *\(.*\) */\1/gp'`
    affiliation=`echo $line |sed -n 's/.*Affiliation:\s\{1,\}\([^;]*\).*$/\1/gp'`
    affiliation=`echo $affiliation |sed -n 's/^ *\(.*\) */\1/gp'`
    email=`echo $line |sed -n 's/.*Email:\s\{1,\}\([^;]*\).*$/\1/gp'`
    day1=`echo $line |sed -n 's/.*Day1:\s\{1,\}\([^;]*\).*$/\1/gp'`
    day1=`echo $day1 |sed -n 's/on/1/gp'`
    day2=`echo $line |sed -n 's/.*Day2:\s\{1,\}\([^;]*\).*$/\1/gp'`
    day2=`echo $day2 |sed -n 's/on/1/gp'`
    day3=`echo $line |sed -n 's/.*Day3:\s\{1,\}\([^;]*\).*$/\1/gp'`
    day3=`echo $day3 |sed -n 's/on/1/gp'`
    day2dinner=`echo $line |sed -n 's/.*Day2Dinner:\s\{1,\}\([^;]*\).*$/\1/gp'`
    day2dinner=`echo $day2dinner |sed -n 's/on/1/gp'`
    day3lunch=`echo $line |sed -n 's/.*Day3Lunch:\s\{1,\}\([^;]*\).*$/\1/gp'`
    day3lunch=`echo $day3lunch |sed -n 's/on/1/gp'`
    vegetarian=`echo $line |sed -n 's/.*Vegetarian:\s\{1,\}\([^;]*\).*$/\1/gp'`
    vegetarian=`echo $vegetarian |sed -n 's/on/1/gp'`
    remarks=`echo $line |sed -n 's/.*Remarks:\s\{1,\}\([^;]*\).*$/\1/gp'`
    remarks=`echo $remarks |sed -n 's/^ *\(.*\) */\1/gp'`

    outline="\"$firstname\";\"$lastname\";\"$affiliation\";$email;\"$date\";$day1;$day2;$day3;$day2dinner;$day3lunch;$vegetarian;\"$remarks\""
    echo $outline
done < tmp.txt  |awk -F\; '{ if (person[$1$2$3]++ == 0) print $0;}'  >tmp1.txt
echo "LASTNAME;FIRSTNAME;AFFILIATION;EMAIL;DATE;DAY1;DAY2;DAY3;DAY2DINNER;DAY3LUNCH;VEGETARIAN;REMARKS" >registrations.csv
cat tmp1.txt |grep ".*[0-9a-zA-Z].*" |sort -f |uniq >>registrations.csv
rm tmp.txt; rm tmp1.txt
