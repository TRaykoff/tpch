#!/bin/bash

##docker run --net NW1 --name PG1  -e POSTGRES_HOST_AUTH_METHOD=trust -d postgres:latest

DB="time psql  -a -U postgres -h pg1 ";

$DB -c "DROP DATABASE IF EXISTS tpch;";
$DB -c "CREATE DATABASE tpch;";

DB="$DB   tpch";

$DB < ../dss.ddl 


for i in `ls /tmp/*.tbl`; do
  j=${i%.tbl}
  table=${j#/tmp/}
  echo "Loading $table..." 
  $DB -c  "TRUNCATE $table"
  $DB -c "\\copy $table FROM STDIN CSV DELIMITER '|'" < $i
done


$DB < ../dss.ri;


$DB -c "ANALYZE";




