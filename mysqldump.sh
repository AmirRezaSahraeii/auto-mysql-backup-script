#!/bin/bash
#set your variables
User="user"
Password="password"
Host="host"
db_name="database name"
backup_path="destination of your backup file"
sqlLogin="-u$User -p$Password "

#backup name with exact date as a gzip file
date=$(date +"%Y-%m-%d-%H-%M") 
db_backup="db_${date}.sql.gzip"

#if you want to exclude some databases, use this script
DatabasesToExclude=""
excludedDatabases="'information_schema','performance_schema'" #here I wanted to exclude these two

for DB in `echo "${DatabasesToExclude}"`
do
    excludedDatabases="${excludedDatabases},'${DB}'"
done

mysqlOptions="--routines --triggers --events" #to get all Events, stored procedures etc

sudo mysqldump $sqlLogin -h$Host $mysqlOptions $db_name | gzip > $backup_path/${db_backup}

#To delete backup files older than....lets say 2 minutes
find $backup_path/*.sql.gzip -type f -mmin +2 -exec rm {} \;
