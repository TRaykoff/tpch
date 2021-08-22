#!/bin/bash


DB="time docker  exec -i ${1:-pg1}  psql  -a -U postgres  ";
TBL_PATH="${2:-/tmp}"
DDL="${3:-../dss.ddl}"

echo "DB command: $DB"
echo "Table path: $TBL_PATH"
echo "DDL: $DDL"
 

$DB -c "DROP DATABASE IF EXISTS tpch;";
$DB -c "CREATE DATABASE tpch;";

DB="$DB   tpch";

$DB < $DDL 


for i in `ls $TBL_PATH/*.tbl`; do
  j=${i%.tbl}
  table=`basename $j`
  echo "Loading $table..." 
  $DB -c  "TRUNCATE $table"
  $DB -c "\\copy $table FROM STDIN CSV DELIMITER '|'" < $i
done

if [[ ! $DDL == *columnar* ]]; then
	$DB < ../dss.ri;
fi;


$DB -c "VACUUM ANALYZE";




