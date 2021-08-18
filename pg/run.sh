#!/bin/bash


DB="time  psql -h pg1  -a -U postgres tpch ";


for i in `ls /tmp/query-*.sql`; do 
	echo "Query: $i...";
	$DB < $i ; 
done;


