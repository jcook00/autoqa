#!/bin/bash
# This script will Check The Status Of QA Environment on AUS-LNX-DEV-04
readonly PROGNAME=$(basename "$0")

func_qa_status() {
  func_qa_safe()

}


func_qa_safe() {
  ps aux | grep "${PROGNAME}"
  if [ `echo $PROGNAME` ]; then
    echo "The ${PROGNAME} is already running"
    exit
  else
    func_qa_check("true")
  fi

}

func_qa_check(choice) {
  if [ `echo $choice` == "true" ]; then
  qa_ardent_env=($(docker ps --format "table {{.Names}}" --filter "status=exited" |grep qa))
    for ((i = 0; i < ${#qa_ardent_status[@]}; ++i)); do
        position=$(( $i + 1 ))
        echo "$position)${qa_ardent_env[$i]}"
    done
  
    for i in "${qa_ardent_env[@]}"; do
        echo $i
        echo "${i} is not running"
        echo 'Done'
    done
  fi

}

func_qa_notify(env, status) {
  # webhook post message

}

func_qa_action(env) {
  docker start ${env}
  docker ps | grep ${env}
  if [ `echo $env` ]; then
    func_qa_notify($env, "UP") # webhook post message ${env} is UP
  else
    func_qa_notify($env, "Failed To Start")
  fi
}
