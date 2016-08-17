#!/bin/bash

##
# Pierwszy argument wiersza: baza z ktorej kopiujemy
# Drugi argument wiersza: baza do ktorej kopiujemy
##

mkdir ${2}_backup

for i in {1..14}
do
  	table=`cat 1 | awk '{ print $1 }' | sed -n ${i}p`
	DATEROW=`cat 1 | awk '{ print $3 }' | sed -n ${i}p`
	echo -ne "Creating backup of ${2}.${table} ...\n"
	cd ${2}_backup
	mysqldump $2 $table | gzip > ${2}_${table}.sql.gz
	echo -ne "Backup created in: `pwd`\n"
	cd ..
	mysqldump $1 $table --skip-add-drop-table --no-create-info --where="${DATEROW} >= DATE_SUB(NOW(), INTERVAL 18 DAY)" > ${1}_${table}.sql
#	mysql $2 < ${1}_${table}.sql
done

for w in {15..18}
do
	TABLE1=`cat 1 | awk '{ print $1 }' | sed -n ${w}p`
	echo -ne "Creating backup of ${2}.${TABLE1} ...\n"
	cd ${2}_backup
	mysqldump $2 $TABLE1 > ${2}_${TABLE1}.sql
	echo -ne "Backup created in: `pwd`\n"
	cd ..
	mysqldump $1 $TABLE1 > ${1}_${TABLE1}.sql
#	mysql $2 < ${1}_${TABLE1}.sql
done
