#!/bin/bash
#   receives RR_DIR, PRIMEDAPP, SPACE, & ORG for cf push and start app with test route 
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' 
set -ex

# push the app
cd $RR_DIR

cf push $PRIMEDAPP -i 1 -m 256M -k 1024M -d cfapps.io -n $PRIMEDAPP-primed-for-prod 

echo "Your app is available at http://$PRIMEDAPP-primed-for-prod.cfapps.io$ANYPATH."