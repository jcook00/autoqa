#!/bin/bash
#function to update uux version

func_uux_update() {

  qa_env=($(docker ps --format "table {{.Names}}"|grep qa_4))

  for ((i = 0; i < ${#qa_env[@]}; ++i)); do
      position=$(( $i + 1 ))
      echo "$position)${qa_env[$i]}"
  done

  echo "Please make a selection by entering the number"
  read qa_num
  echo ${qa_env[qa_num -1]}

  old_version=`grep version /etc/opt/code/ardent.io/config/${qa_env[qa_num -1]} | head -1 | awk -F: '{print $2}' | tr -d '"' | tr -d ' '`

  echo "Is this the current version you want do update? Enter Y if correct" $old_version
  read ok

  if [ `echo $ok` == 'Y' ];
  then
    echo 'Enter the new version'
    read new_version
    echo 'Updating UUX with this version' $new_version
    sed -i_`date +%F` "s:$old_version:$new_version:" /etc/opt/code/ardent.io/config/${qa_env[qa_num -1]}
  else
    echo 'Skipping...'
  fi

}
