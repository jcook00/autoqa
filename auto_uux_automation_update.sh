#!/bin/bash
#function to update uux version

func_uux_automation_update() {
qa_auto_env=($(docker ps --format "table {{.Names}}" |grep auto | cut -c 4- | rev | cut -c 12- | rev |uniq -d))

  for ((i = 0; i < ${#qa_auto_env[@]}; ++i)); do
      position=$(( $i + 1 ))
      echo "$position)${qa_auto_env[$i]}"
  done

  echo "Please make a selection by entering the number"
  read qa_num
  echo ${qa_auto_env[qa_num -1]}
  
  old_version=`grep version /etc/opt/code/ardent.io/config/qa_${qa_auto_env[qa_num -1]}_auto_main$i | head -1 | awk -F: '{print $2}' | tr -d '"' | tr -d ' '`
  
  echo "Is this the current version you want do update ${old_version} ? Enter Y if correct"
  read ok

if [ `echo $ok` == 'Y' ]; then
  echo 'Enter the new version'
  read new_version
  echo 'Updating Automation UUX with this version' $new_version
  for i in /etc/opt/code/ardent.io/config/qa_${qa_auto_env[qa_num -1]}_auto_main*; do
    echo $i
    sed -i "s:$old_version:$new_version:" /etc/opt/code/ardent.io/config/qa_${qa_auto_env[qa_num -1]}_auto_main*
    echo ${i#/etc/opt/code/ardent.io/config/}
    sudo docker restart ${i#/etc/opt/code/ardent.io/config/} 
  done
else
  echo 'Skipping...'
fi

}
