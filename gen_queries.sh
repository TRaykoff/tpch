#!/bin/bash


for i in {1..22} ; do
  cat  queries/$i.sql | sed 's/;//'  > /tmp/$i.sql
  echo " " > query-$i.sql
  DSS_QUERY=/tmp ./qgen $i  | sed 's/limit -1//' | sed 's/day (3)/day/' >> query-$i.sql 
done



