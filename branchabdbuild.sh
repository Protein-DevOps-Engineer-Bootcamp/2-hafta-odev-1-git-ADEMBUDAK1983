#! /bin/bash

###########################
# Author : Adem BUDAK
# quick script for making branch creation a bit easier and build mvn sh
# usage: $ ./branch.sh branchname
#        $ ./branch.sh

###########################

# get current branch name and parse with cut
# you may need to adjust cut command for your shell

current="$(git branch | grep "*" | cut -b 3-)"

# if arg is not set
if [ -z "${1}" ]; then
  echo "Name of new branch?"
  read branch
  # and if on master
  if [ "$current" == 'master' ];then
  echo "WARNING!!!! Creating $branch from Master..."
  git checkout master && git pull origin master && git checkout -b "$branch"
  else
    #if not on master
    echo "Create $branch from $current (c) or from Master (m)?"
    read -p "current(c) / Master(m) ?" cm
    [ $cm == 'c' ] && git checkout -b "$branch"
    [ $cm == 'm' ] && git checkout master && git pull origin master && git checkout -b "$branch"
  fi
#otherwise use $1 arg as branch name
else
  if [ "$current" == 'master' ];then
  echo "Creating $1 from Master..."
  git checkout master && git pull origin master && git checkout -b "$1"
  else
    echo "Create $1 from $current (c) or from Master (m)?"
    read -p "current(c) / Master(m) ?" cm
    [ $cm == 'c' ] && git checkout -b "$1"
    [ $cm == 'm' ] && git checkout master && git pull origin master && git checkout -b "$1"
  fi
fi
 
# Build mvn package

BUILD_COMMAND="mvn package"
USAGE_MESSAGE="
    Usage: ${basename $0} [OPTIONS]
    
    Options:
    -d          <true|false>  Enable maven debug mode.
    -t          <true|false>  Run test or skip test.
"

usage(){
  echo "${USAGE_MESSAGE}"
  exit 1
}

# if ["$#" -ne 1]; then
#     usage
# fi

while getopts ":d:t:" flag
do
    case "${flag}" in
     d| debug=${OPTARG}
        ;;
     t| skip_test=${OPTARG}
        ;;
     *| usage
        ;;
    esac    
done

if [ "${debug}" == "true"]; then
    BUILD_COMMAND+=" -X"
fi

if [ "${skip_test}" == "true" ]; then
    BUILD_COMMAND+= " -Dmaven.test.skip"
fi

eval "$BUILD_COMMAND"

# keep jar file

JARFILE="/target"
DEST="/tmp

branchname=$(branch)
archive_file="$branchname.tgz"

# Print start status message.
echo "Backing up ${JARFILE} to ${DEST}/$archive_file"
date
echo

# Save the file using tar.
tar czf ${DEST}/$archive_file ${JARFILE}





