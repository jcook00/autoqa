#!/bin/bash
# function to update associate version
func_associate_update() {
  qa_env=($(docker ps --format "table {{.Names}}"|grep qa_4))

  for ((i = 0; i < ${#qa_env[@]}; ++i)); do
      position=$(( $i + 1 ))
      echo "$position)${qa_env[$i]}"
  done

  echo "Please make a selection by entering the number"
  read qa_num
  echo ${qa_env[qa_num -1]}

  old_assoc_version=`grep version /etc/opt/code/ardent.io/config/${qa_env[qa_num -1]} | tail -1 | awk -F: '{print $2}' | tr -d '"' | tr -d ' '`

  echo "Is this the current version you want do update? Enter Y if correct" $old_assoc_version
  read ok

  if [ `echo $ok` == 'Y' ];
  then
    echo 'Enter the new associate version'
    read new_assoc_version
    echo 'Updating Associate with this version' $new_assoc_version
    sed -i_`date +%F` "s:$old_assoc_version:$new_assoc_version:" /etc/opt/code/ardent.io/config/${qa_env[qa_num -1]}
  else
    echo 'Skipping...'
  fi
}
