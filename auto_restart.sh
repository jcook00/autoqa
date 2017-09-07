#!/bin/bash
# function to restart a qa environment container
func_restart_container() {
  qa_env=($(docker ps --format "table {{.Names}}"|grep qa_4))

  for ((i = 0; i < ${#qa_env[@]}; ++i)); do
      position=$(( $i + 1 ))
      echo "$position)${qa_env[$i]}"
  done

  echo "Please make a selection by entering the number"
  read qa_num
  echo ${qa_env[qa_num -1]}
  echo "Is this the environment you want to restart?" $qa_num
  read response

  if [ `echo $response` == 'Y' ];
  then
    echo 'Please wait while we Restart your container...'
    sudo docker stop ${qa_env[qa_num -1]}
    sleep 10
    sudo docker start ${qa_env[qa_num -1]}
    sleep 5
    echo 'Done'
  else
    echo 'Skipping...'
  fi

}
