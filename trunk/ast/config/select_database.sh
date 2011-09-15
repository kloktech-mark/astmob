#!/usr/bin/env bash

# Determin the colo, and copy the right file 

cd /home/example/ast/current/config

# Determine colo
domain=`/bin/hostname -f | awk -F. '{i=NF-2;print $i}'`
# Set database file to use
mydb=./database.$domain.yml


# Copy the file
if [ -f $mydb ]; then
  cp $mydb ./database.yml
else
  echo "Couldn't find $mydb"
  exit 1
fi
