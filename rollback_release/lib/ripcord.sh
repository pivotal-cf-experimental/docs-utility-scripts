#!/bin/bash
# This script receives ROLLBACKAPP, SPACE, & ORG
# It is a rollback script to 'cf start', 'scale', and 'map-route' a one day stale prod app 

set -ex
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' 

cf target -o $ORG -s $SPACE
cf apps
printf "\n  ===== Final confirmation =====\n  Are you sure you want to roll back to the ${MAGENTA}$ROLLBACKAPP${NC} app? [Y/n]\n"

while true; do
    read -p '' yn
    case $yn in
        [Yy]* ) echo "  Pushing $ROLLBACKAPP\n"; break;;
        [Nn]* ) echo "  No $ROLLBACKAPP will be pushed.\n"; exit;;
        * ) echo "  Please answer yes or no.";;
    esac
done

echo "we pushed $ROLLBACKAPP"
