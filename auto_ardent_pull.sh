#!/bin/bash
# begin function to pull new ardent
func_pull_ardent() {

  echo "Please type ardent version number that you want to pull"
  read ver_num
  echo ${ver_num}

  echo "Is this the Ardent version you want pull? Enter Y if correct" $ver_num
  read response

  if [ `echo $response` == 'Y' ];
  then
    echo 'Please wait while we pull Ardent with this version' $ver_num
    sudo docker pull base-local-docker.aus-bin-prd-00.q2dc.local/ardent_v${ver_num}
    sleep 15
  else
    echo 'Skipping...'
  fi

}
