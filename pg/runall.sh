#!/bin/bash
docker exec -i Deb1 bash -c "cd /mnt/tpch/pg; ./gen_queries.sh; exit;  " ;
docker exec -i Deb1 /mnt/tpch/pg/run.py  --timeout=500 --pghost=c1 /tmp/query-*.sql > c1.log 2>&1 ;
docker exec -i Deb1 /mnt/tpch/pg/run.py  --timeout=500 --pghost=pg1 /tmp/query-*.sql  > pg1.log 2>&1 ;

docker exec -i Deb1 /mnt/tpch/pg/run.py  --timeout=500 --pghost=c1 /tmp/query-*.sql >> c1.log 2>&1 ;
docker exec -i Deb1 /mnt/tpch/pg/run.py  --timeout=500 --pghost=pg1 /tmp/query-*.sql >> pg1.log 2>&1 ;
