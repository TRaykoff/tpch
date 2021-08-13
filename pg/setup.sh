#!/bin/bash

##docker run --net NW1 --name PG1  -e POSTGRES_HOST_AUTH_METHOD=trust -d postgres:latest

DB="docker exec -i PG1 psql  -a -U postgres";

$DB < ../dss.ddl 


for i in `ls *.tbl`; do
  table=${i/.tbl/}
  echo "Loading $table..."
  #sed 's/|$//' $i > /tmp/$i
  $DB -c  "TRUNCATE $table"
  $DB -c "\\copy $table FROM STDIN CSV DELIMITER '|'" < $i
done

