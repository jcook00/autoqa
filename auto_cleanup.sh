#!/bin/bash
# begin function to delete backup files in config directory
func_file_maint(){
  cd /etc/opt/code/ardent.io/config/
  old_files=`find . -name "*2017*"` >files_to_delete
  echo "Do you want to delete all of these files ? Enter Y if Correct"	$old_files
  read response
  
  if [ `echo $response` == 'Y' ];
  then
    echo 'Please wait while we delete the files ...'
  for x in `cat files_to_delete`
  do
  rm -rf $x
  sleep 5
  done
  else
    echo 'Skipping...'
  fi

}
