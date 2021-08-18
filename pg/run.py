#!/usr/bin/python3


from time import time
import argparse
from typing import DefaultDict
import psycopg2 
import sys
from datetime import datetime 
import pandas as pd
from collections import defaultdict 
import pprint



p = argparse.ArgumentParser (formatter_class=argparse.ArgumentDefaultsHelpFormatter)
p.add_argument ("--pghost",  default='pg1',  type=str, help="hostname of PG server"  )
p.add_argument ("--pgdb",  default='tpch',  type=str, help="hostname of PG server"  )
p.add_argument ("--pguser",  default='postgres',  type=str, help="PG username"  )
p.add_argument ("--pgport",  default=5432,  type=int, help="port number of PG server"  )
p.add_argument ("--pgpass",   default='', type=str, help="PG user password"  )
p.add_argument ("--timeout",  default='5',  type=int, help="query timeout in seconds"  )
p.add_argument('qs', nargs=argparse.REMAINDER)

args = p.parse_args()

print ("Options:\n{}".format (pprint.pformat(args.__dict__, indent=8)))

D = defaultdict(list)
pd.set_option ('display.width', 150)
pd.set_option ('display.max_columns', 20)

t=time()
def tictoc(msg="<timing>"):
    global t
    print ("{}: Elapsed: {:0.01f}s @ {:%H:%M:%S}".format (msg, time()-t, datetime.now() ))
    t=time()


#log onto PG
try:
    dbc = psycopg2.connect(database=args.pgdb,
                           user=args.pguser,
                           password=args.pgpass,
                           host=args.pghost,
                           port=args.pgport)
    tictoc ("Logged onto database {}@{}:{}".format(args.pguser, args.pghost, args.pgport))
except  :
    print ("Error logging onto PG", sys.exc_info())
    sys.exit(1)


dbc.set_session(  autocommit=True)
dbc.cursor().execute (f"Set statement_timeout={args.timeout*1000};")

for q in args.qs:
    with open (q) as f:
        sql = f.read()
    print ("*"*80, f"\nRunning query [{q}]:\n{sql}\n", "." * 80)
    t_start = time()
    try:
        cur = dbc.cursor()
        for s in sql.strip().split(';'):
            if len(s) == 0: continue
            cur.execute(s)
            if cur.rowcount > 0:
                rs = cur.fetchmany(10) 
                df = pd.DataFrame(rs,columns=[i[0] for i in cur.description ])
                print (df)
        res = "Success"
    except psycopg2.extensions.QueryCanceledError as e:
        print ("\t...Query timed out")
        res = "Timed out"
    except psycopg2.Error as e: 
        res = f"PG Error: [{e.pgcode}] -- {e.pgerror}"
        print (res)
    except:
        print ("Unexpected error: ", sys.exc_info())
        sys.exit(1)
    finally:
        #dbc.rollback()
        t_end = time()
        cur.close()
    
    print (f"\t...Timing {t_end-t_start:.1f} seconds\n")
    D['query'].append(q)
    D['timing'].append( t_end-t_start )
    D['result'].append (res)

pd.set_option ('display.max_colwidth', 100)
pd.set_option ('display.max_rows', None)
pd.set_option('display.float_format', lambda x: '%.1f' % x)
print (pd.DataFrame(D))

dbc.close()