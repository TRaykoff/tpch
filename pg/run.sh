#!/bin/bash


DB="time docker exec -i PG1 psql  -a -U postgres ";


for i in {1..22};
	do $DB < query-$i.sql ; 
done;


