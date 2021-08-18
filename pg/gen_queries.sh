#!/bin/bash

cd ..

for i in `ls ./queries/*.sql`; do
  q=`basename $i`
  qnm=${q%.sql}
  echo "Processing query $q..."
  cat  $i  |  tac | sed '0,/;/s///' | tac > /tmp/$q
  DSS_QUERY=/tmp ./qgen $qnm | sed 's/limit -1//' | sed 's/day (3)/day/' > /tmp/query-$q 
done



