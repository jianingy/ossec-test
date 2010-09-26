#!/bin/bash

root=$(dirname $(readlink -f $0))
logtest=$(which 2>/dev/null ossec-logtest $root/bin/ossec-logtest /var/ossec/bin/ossec-logtest)
config=$root/etc/ossec.conf

if [ -z "$logtest" ]; then
  echo >&2 can not find ossec-logtest
  exit 255
fi
echo root=$root config=$config
t=$root/tests/$1.t
sed '1,/^__LOG__/d' $t |  $logtest -D $root -c $config
