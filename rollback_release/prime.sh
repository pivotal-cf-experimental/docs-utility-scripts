#!/bin/bash
#   receives PRIMEDAPP, SPACE, & ORG for cf push and start app with test route 

set -e
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' 

# cf target -o $ORG -s $SPACE
# cf apps


 echo $(ls -l)

printf "\n  ${MAGENTA}=>${NC} Push the ${MAGENTA}$PRIMEDAPP${NC} app? [Y/n]\n"
while true; do
    read -p '' yn
    case $yn in
        [Yy]* ) echo "  Pushing $PRIMEDAPP\n"; break;;
        [Nn]* ) echo "  No $PRIMEDAPP will be pushed.\n"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "we pushed $PRIMEDAPP"
