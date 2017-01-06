#!/bin/bash
# This script receives these variables:
#   ROLLBACKAPP
#   SPACE
#   ORG
#   DOMAIN
#   PATH
#   HOSTNAME
# This script is a rollback script to 'cf start', 'scale', and 'map-route' a slightly older prod app when the normal green/blue cadence of CI/CD fails. The rollback app may be blue, green, yellow, or rose.


MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' 

set -e

cf target -o $ORG -s $SPACE

cf start $ROLLBACKAPP
cf scale $ROLLBACKAPP -i 3
cf map-route $ROLLBACKAPP $DOMAIN $HOSTNAME $ROUTE_PATH

# If blue, stop green:
if [[ $ROLLBACKAPP == *"blue"* ]]
	then
	cf stop ${ROLLBACKAPP/blue/green}
fi

# If green, stop blue
if [[ $ROLLBACKAPP == *"green"* ]]
	then
	echo "  ==> Stopping blue app."
	cf stop ${ROLLBACKAPP/green/blue}
fi

# If yellow, stop blue and green apps
if [[ $ROLLBACKAPP == *"yellow"* ]]
	then
	echo "  ==> Stopping blue app."
	cf stop ${ROLLBACKAPP/yellow/blue}

	echo "  ==> Stopping green app."
	cf stop ${ROLLBACKAPP/yellow/green}
fi

# If rose, stop blue, green, and yellow apps
if [[ $ROLLBACKAPP == *"rose"* ]]
	then
	echo "  ==> Stopping blue app."
	cf stop ${ROLLBACKAPP/rose/blue}

	echo "  ==> Stopping green app."
	cf stop ${ROLLBACKAPP/rose/green}	

	echo "  ==> Stopping yellow app."
	cf stop ${ROLLBACKAPP/rose/yellow}
fi

cf apps

echo "The $ROLLBACKAPP app has been rolled back into service."


