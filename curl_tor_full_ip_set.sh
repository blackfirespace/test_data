#!/bin/bash

FILE=".tmp_tor_full_ip_set"
[ -f $FILE ] && rm $FILE
sudo ipset list c_bd_tor_full_ip_set > $FILE

timeout=5
maxtime=5
OUTFILE="tor_full_ip_set.txt"
line_index=0
IFS=$' ,\t\n'
while read line
do
  if [[ -n "$line" && ! $line =~ ": " ]]; then
    array=($line)
    test_url=${array[0]}
    if [[ "$test_url" == \#* || "$test_url" == "ip" ]]; then
      #echo "skip $line_index: $test_url"
    else
      #echo "test $line_index: $test_url"
      resp=`curl -I -s --connect-timeout $timeout -m $maxtime -w "%{http_code}" -o /dev/null $test_url`
      #echo $resp
      if [[ "$resp" != "000" ]]; then
        echo $test_url  >> $OUTFILE
      fi
    fi
  fi
  ((line_index++))
done < $FILE
# git add $OUTFILE
# git commit -m "Update Tor Full IPSet"
# git push origin main
