#!/bin/bash
# This script will Check The Status Of QA Environment on AUS-LNX-DEV-04

func_qa_check() {
  qa_ardent_status=($(docker ps --format "table {{.Names}}" --filter "status=exited" |grep qa))
  for ((i = 0; i < ${#qa_ardent_status[@]}; ++i)); do
      position=$(( $i + 1 ))
      echo "$position)${qa_ardent_status[$i]}"
  done

  if [ `echo $status` != 'exited' ];
  then
    echo 'All Environments are running...'
    #send notification to Teams Channel
  else
    for i in ${qa_ardent_status}; do
    echo $i
    x=${#qa_ardent_status}
    # \t{{.Status}}
    # arr=( $x )
    echo "There are ${x} containers that are not running..."
    #send notification to Teams Channel
    echo 'Done'
  fi

}
