#!/bin/bash
# author: jianingy.yang AT gmail DOT com

root=$(dirname $(readlink -f $0))
logtest=$(which 2>/dev/null ossec-logtest $root/bin/ossec-logtest /var/ossec/bin/ossec-logtest)
config=$root/etc/ossec.conf

if [ -z "$logtest" ]; then
  echo >&2 can not find ossec-logtest
  exit 255
fi

passed=0
total=0
array0=( "${array0[@]}" "new1" )
for t in $root/tests/*.t; do
  basename=$(basename $t)
  unset _rules _levels
  while read __; do
    [[ $__ =~ "^Rule id: '([0-9]+)'" ]] && _rules=( "${_rules[@]}" "${BASH_REMATCH[1]}" )
    [[ $__ =~ "^Level: '([0-9]+)'" ]] && _levels=( "${_levels[@]}" "${BASH_REMATCH[1]}" )
  done < <(sed '1,/^__LOG__/d' $t |  $logtest -D $root -c $config 2>&1)
  unset error rules levels
  eval "$(sed '/^__LOG__/,$d' $t)"
  for i in $(seq 0 "$((${#_rules[@]} - 1))"); do
    if [ "x${_rules[$i]}" != "x${rules[$i]}" ]; then
      echo >&2 "$basename: #$i rule (=${_rules[$i]}) mismatch (should =${rules[$i]})."
      error=1
    elif [ "x${_levels[$i]}" != "x${levels[$i]}" ]; then
      echo >&2 "$basename: #$i level (=${_levels[$i]}) mismatch (should =${levels[$i]})."
      error=1
    fi
    [ -n "$error" ] && break
  done

  if [ -z "$error" ]; then
    ((passed++))
    echo >&2 "$basename: passsed"
  fi

  ((total++))
done

echo "successful/total = $passed / $total"
