#!/bin/bash
func_ardent_update() {
  qa_env=($(docker ps --format "table {{.Names}}"|grep qa_4))

  for ((i = 0; i < ${#qa_env[@]}; ++i)); do
      position=$(( $i + 1 ))
      echo "$position)${qa_env[$i]}"
  done

  echo "Please select the environment you want to update."
  read qa_num
  echo ${qa_env[$qa_num-1]}
  
  cur_version=`docker inspect ${qa_env[$qa_num-1]} |grep Image | tail -1 | awk -F"/" '{ print $2}' | tr -d '",'`
  echo "Is this the Ardent version you want do update? Enter Y if correct" $cur_version
  read response

  if [ `echo $response` == 'Y' ];
  then
    echo "Enter the new Ardent version number (just the number)"
    read new_version
    echo "Enter the port number"
    read port
    echo "Preparing to update with" ${qa_env[$qa_num-1]} environment with $new_version on port number $port
    sleep 5
    echo "Please wait while we stop the container ..." ${qa_env[$qa_num-1]}
    sudo docker stop ${qa_env[$qa_num-1]}
    sleep 5
    echo "Please wait while we remove the container ..." ${qa_env[$qa_num-1]}
    sudo docker rm ${qa_env[$qa_num-1]}
    sleep 5
    echo "Please wait while we update the container with the new Ardent version" $new_version
    sudo docker run -d --name=${qa_env[$qa_num-1]} --privileged -i -p ${port}:8001 -v /var/log/ardent.io/0000/${qa_env[$qa_num-1]}:/opt/code/ardent.io/logs -v /etc/opt/code/ardent.io/config/${qa_env[$qa_num-1]}:/opt/code/ardent.io/config.json -t base-local-docker.aus-bin-prd-00.q2dc.local/ardent_v${new_version} /bin/bash -c \"cd /opt/code/ardent.io; npm start\"

    sleep 5 
  else
    echo 'Skipping...'
  fi

}
