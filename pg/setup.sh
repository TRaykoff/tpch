#!/bin/bash


DB="time docker  exec -i ${1:-pg1}  psql  -a -U postgres  ";
TBL_PATH="${2:-/tmp}"

echo "DB command: $DB"
echo "Table path: $TBL_PATH"
 

$DB -c "DROP DATABASE IF EXISTS tpch;";
$DB -c "CREATE DATABASE tpch;";

DB="$DB   tpch";

$DB < ../dss.ddl 


for i in `ls $TBL_PATH/*.tbl`; do
  j=${i%.tbl}
  table=`basename $j`
  echo "Loading $table..." 
  $DB -c  "TRUNCATE $table"
  $DB -c "\\copy $table FROM STDIN CSV DELIMITER '|'" < $i
done


$DB < ../dss.ri;


$DB -c "VACUUM VERBOSE ANALYZE";




