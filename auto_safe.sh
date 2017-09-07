#!/bin/bash
# http://www.kfirlavi.com/blog/2012/11/06/elegant-locking-of-bash-program/ 
readonly PROGNAME=$(basename "$0")
readonly LOCKFILE_DIR=/tmp
readonly LOCK_FD=200

lock() {
    local prefix=$1
    local fd=${2:-$LOCK_FD}
    local lock_file=$LOCKFILE_DIR/$prefix.lock

    # create lock file
    eval "exec $fd>$lock_file"

    # acquire the lock
    flock -n $fd \
        && return 0 \
        || return 1
}

eexit() {
    local error_str="$@"

    echo $error_str
    exit 1
}

main() {
    lock $PROGNAME \
        || eexit "Only one instance of $PROGNAME can run at one time."

}
main

# enforce running as root user only
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
# prevent control c from exiting menu
trap ‘’ 2