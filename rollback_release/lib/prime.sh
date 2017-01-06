#!/bin/bash
# RR calls this script with arguments RR_DIR, PRIMEDAPP, SPACE, & ORG to `cf push` and start app with test route. 
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' 

set -e

cd $RR_DIR

cf push $PRIMEDAPP -i 1 -m 256M -k 1024M -d cfapps.io -n $PRIMEDAPP-primed-for-prod 
cf apps

echo "Your app is available at http://$PRIMEDAPP-primed-for-prod.cfapps.io$ANYPATH."