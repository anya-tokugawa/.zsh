export ZTTY_PATH=$TTY
TIMER_LIST=""

function timer_core(){
  sleep $2 && \
  cat <<EOF >> $ZTTY_PATH

ALARM: Spend for $2 seconds!
Subject: $3
EOF
sed -i '/^'"$1"'/d' $HOME/.timer.csv
}

timer(){
  if [[ $# == 0 || $1 == '-h' ]];
  then
    echo "usage: timer 'subject_str' wait_secound."
    return
  fi
  udate=$(date)
  utime=$(date '+%s')
  (timer_core $utime $1 $2 &)>/dev/null 2&>1
  timer_pid=$!
  # CSV: UNIX_TIME,DATE_STR,SUBJECT,TIME_SECONDS,PID
  echo "$utime,$udate,$2,$1,$timer_pid" >> $HOME/.timer.csv
  echo "RUN - $utime $timer_pid"
}
lstimer(){
  cat $HOME/.timer.csv | column -ts,
}
