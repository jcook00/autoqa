# function to start a qa environment container
func_start_container() {
  qa_env=($(docker ps --format "table {{.Names}}" --filter "status=exited" |grep qa))

  for ((i = 0; i < ${#qa_env[@]}; ++i)); do
      position=$(( $i + 1 ))
      echo "($position)${qa_env[$i]}"
  done

  echo "Please make a selection by entering the number"
  read qa_num
  echo ${qa_env[qa_num -1]}
  echo "Is this the environment you want to Start?" $qa_num
  read response

  if [ `echo $response` == 'Y' ];
  then
    echo 'Please wait while we Start your container...'
    sudo docker start ${qa_env[qa_num -1]}
    sleep 5
    echo 'Done'
  else
    echo 'Skipping...'
  fi

}
