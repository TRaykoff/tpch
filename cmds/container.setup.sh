#!/bin/bash

cat >> ~/.bashrc << 'EOF'
export LS_OPTIONS='--color=auto'
eval "$(dircolors -b)"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
EOF


. ~/.bashrc 

apt update;

apt install -y postgresql-client python3 python3-pip git less vim procps time gcc make  man  \
	inetutils-ping \
	postgresql-common libpq-dev ; 

pip3 install psycopg2 argparse pandas ;  

