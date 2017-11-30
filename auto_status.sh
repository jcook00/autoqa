#!/bin/bash
# This script will Check The Status Of QA Environment on AUS-LNX-DEV-04
readonly PROGNAME=$(basename "$0")

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

func_qa_status() {
  func_qa_safe()

}

func_qa_safe() {
  ps aux | pgrep "${PROGNAME}"
  if [ `echo $PROGNAME` == "auto_status.sh" ]; then
    echo "The ${PROGNAME} is already running"
    exit
  else
    func_qa_check("true")
  fi

}

func_qa_check(choice) {
    qa_ardent_env=($(docker ps --format "table {{.Names}}" --filter "status=exited" |grep qa))
    for ((i = 0; i < ${#qa_ardent_status[@]}; ++i)); do
        position=$(( $i + 1 ))
        echo "$position)${qa_ardent_env[$i]}"
    done
  
    for i in "${qa_ardent_env[@]}"; do
        echo $i
        echo "${i} is not running"
        if [ `echo $choice` == "true" ]; then
          func_qa_notify($i, "Down")
          func_qa_action($i)
        fi
        echo 'Done'
    done

}

func_qa_notify(env, status) {
  curl -H "Content-Type: application/json" -X POST -d'{"text":"This ${env} is in this status: ${status}"}' https://outlook.office.com/webhook/92da222c-50ca-4ab5-8640-12964bf34bf6@86b38324-0fb6-44c7-b3dc-5dc60d472331/IncomingWebhook/2f5a58ae3fbf48b79f422683fd86f375/afdc9d55-bfcb-4247-b97e-1f87483d16cd

}

func_qa_action(env) {
  docker start ${env}
  sleep 5
  docker ps | grep ${env}
  if [ `echo $env` ]; then
    func_qa_notify($env, "UP") # webhook post message ${env} is UP
  else
    func_qa_notify($env, "Failed To Start")
  fi
}
