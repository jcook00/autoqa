# function to stop a qa environment container
func_stop_container() {
  qa_env=($(docker ps --format "table {{.Names}}" --filter "status=running"|grep qa_4))

  for ((i = 0; i < ${#qa_env[@]}; ++i)); do
      position=$(( $i + 1 ))
      echo "$position)${qa_env[$i]}"
  done

  echo "Please make a selection by entering the number"
  read qa_num
  echo ${qa_env[qa_num -1]}
  echo "Is this the environment you want to Stop? Enter Y if correct" ${qa_env[qa_num -1]}
  read response

  if [ `echo $response` == 'Y' ];
  then
    echo 'Please wait while we Stop your container...'
    sudo docker stop ${qa_env[qa_num -1]}
    sleep 5
    echo 'Done'
  else
    echo 'Skipping...'
  fi

}
