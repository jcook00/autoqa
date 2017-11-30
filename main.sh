#!/bin/bash
# This script will update QA Environment on AUS-LNX-DEV-04
# source helper scripts
cur_dir=`pwd`
for f in $cur_dir/auto_*; do source $f; done
# enter a loop
while true
do
  clear 
#  Display a menu selection of commands to run
  echo " =================================== "
  echo   QA Environment Update Menu
  echo " =================================== "
  func_date(){
  date

}

func_date

  echo -e '\t Enter 1 to update UUX'
  echo -e '\t Enter 2 to update Automation UUX'
  echo -e '\t Enter 3 to update Associate'
  echo -e '\t Enter 4 to pull new Ardent'
  echo -e '\t Enter 5 to restart container'
  echo -e '\t Enter 6 to check Ardent Status'
  echo -e '\t Enter 7 to update Ardent'
  echo -e '\t Enter 8 to start container'
  echo -e '\t Enter 9 to stop container' 
  echo -e '\t Enter q to exit the menu'
  echo -e '\n'
  echo -e "Enter your selection "
  read answer
  case $answer in 
    1) func_uux_update ;; 
    2) func_uux_automation_update ;;
    3) func_associate_update ;;
    4) func_pull_ardent ;;
    5) func_restart_container ;;
    6) func_qa_status ;;
    7) func_ardent_update ;;
    8) func_start_container ;;
    9) func_stop_container ;;
    q) exit ;;
  esac
  echo -e "Enter return to continue "
  read input
done