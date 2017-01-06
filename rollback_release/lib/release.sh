#!/bin/bash
# receives RELEASE_APP, OLD_APP, SPACE, & ORG for cf push and start app with test route 
# This script receives these variables:
#   RELEASE_APP
#   SPACE
#   ORG
#   DOMAIN
#   PATH
#   HOSTNAME
# This script is a release script to 'cf start', 'scale', and 'map-route' a new prod app to the natural green/blue cadence of CI/CD. The rollback app may be blue, green, yellow, or rose.
set -ex

echo 'Checking inputs:'
echo $RELEASE_APP
echo $SPACE
echo $ORG
echo $DOMAIN
echo $HOSTNAME

MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' 

cf apps

cf target -o $ORG -s $SPACE

cf start $RELEASE_APP
cf scale $RELEASE_APP -i 3

cf map-route $RELEASE_APP $DOMAIN $HOSTNAME $ROUTE_PATH
# If blue, stop green:
if [[ $RELEASE_APP == *"blue"* ]]
	then
	cf stop ${RELEASE_APP/blue/green}
fi

# If green, stop blue
if [[ $RELEASE_APP == *"green"* ]]
	then
	echo "  ==> Stopping blue app."
	cf stop ${RELEASE_APP/green/blue}
fi

cf apps

echo "The $RELEASE_APP app has been released into production."




