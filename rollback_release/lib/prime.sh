#!/bin/bash
#   receives PRIMEDAPP, SPACE, & ORG for cf push and start app with test route 

set -e
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' 

printf "\n  ${MAGENTA}=>${NC} Make sure you are in the ${MAGENTA}final app${NC} directory of the appropriate ${MAGENTA}book${NC} to push docs.\n"
printf "\n  ${MAGENTA}=>${NC} You are in ${MAGENTA}$PWD${NC} and these are the contents you are about to push:\n\n"

ls -l
 # echo $(ls -l)

printf "\n  ${MAGENTA}=>${NC} Push this directory as the ${MAGENTA}$PRIMEDAPP${NC} app? [Y/n]\n"
while true; do
    read -p '' yn
    case $yn in
        [Yy]* ) echo "  Pushing $PRIMEDAPP\n"; break;;
        [Nn]* ) echo "  No $PRIMEDAPP will be pushed.\n"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "we pushed $PRIMEDAPP"
