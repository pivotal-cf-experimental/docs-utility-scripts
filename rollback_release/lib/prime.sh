#!/bin/bash
#   receives PRIMEDAPP, SPACE, & ORG for cf push and start app with test route 
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' 
set -ex

# Need to export path as necessary
ANYPATH=''

# push the app
echo "cf push $PRIMEDAPP -i 1 -m 256M -k 1024M -b https://github.com/cloudfoundry/ruby-buildpack#v1.6.28 -d cfapps.io --no-route"
# Add a test route:
echo "cf map-route $PRIMEDAPP cfapps.io -n $PRIMEDAPP-primed-for-prod" 
# Show link for app
echo "Your app is available at http://$PRIMEDAPP-primed-for-prod.cfapps.io$ANYPATH."