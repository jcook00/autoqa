#!/bin/bash
# This script will Check The Status Of QA Environment on AUS-LNX-DEV-04
readonly PROGNAME=$(basename "$0")
readonly LOCKFILE_DIR=/tmp

echo $1

func_qa_status() {
  echo "Hello qa status function"
  func_qa_safe
}

func_qa_check() {
    qa_ardent_env=($(docker ps --format "table {{.Names}}" --filter "status=exited" |grep qa))
    for ((i = 0; i < ${#qa_ardent_env[@]}; ++i)); do
        position=$(( $i + 1 ))
        echo "$position)${qa_ardent_env[$i]}"
    done
  
    H=$(date +%H) 
    for i in "${qa_ardent_env[@]}"; do
        echo "${qa_ardent_env[$i]} is not running"
        if [ `echo $1` == "True" ]; then
          func_qa_notify ${qa_ardent_env[$i]} "Down"
        elif (( 20 <= $H && $H < 8 )); then
          #func_qa_action(${qa_ardent_env[$i]})
          echo ${qa_ardent_env[$i]}
        fi
        echo 'Done'
    done
}


func_qa_safe() {
  if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
  fi

  if [ $1 =='START' ]; then
    LOCKFILE=${LOCKFILE_DIR}/${PROGNAME}_lock.txt
    if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
      echo "already running"
      exit
    fi

    trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
    echo $$ > ${LOCKFILE}
    while true; do
      func_qa_check True
      echo "Running 'func_qa_check' function with exit code $?. Respawning.. " >&2
      sleep 300
    done
  else
    rm -f ${LOCKFILE}
    kill `cat ${LOCKFILE}`
  fi

}

func_qa_notify (){
  out="This ${1} is in this status: ${2}"
  echo $out
  curl -H "Content-Type: application/json" -X POST -d"{\"text\":\"$out\"}" https://outlook.office.com/webhook/92da222c-50ca-4ab5-8640-12964bf34bf6@86b38324-0fb6-44c7-b3dc-5dc60d472331/IncomingWebhook/2f5a58ae3fbf48b79f422683fd86f375/afdc9d55-bfcb-4247-b97e-1f87483d16cd
  #curl -H "Content-Type: application/json" -X POST -d'{"text":"This ${1} is in this status: ${2}"}'
}

func_qa_action() {
  docker start $1
  sleep 5
  docker ps | grep $1
  if [ `echo $env` ]; then
    func_qa_notify $1, "UP" # webhook post message ${env} is UP
  else
    func_qa_notify $1, "Failed To Start"
  fi
}

func_qa_status
