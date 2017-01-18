#!/bin/bash
# RR calls this script with arguments DOMAIN, RR_DIR, PRIMEDAPP, ROUTE_PATH, DOMAIN, SPACE, & ORG to `cf push` and start app with test route. 
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' 

set -e

# echo "inputs: 
# 	SUBDOMAIN: $SUBDOMAIN
#   RR_DIR: $RR_DIR
#   PRIMEDAPP: $PRIMEDAPP
#   ROUTE_PATH: $ROUTE_PATH
#   DOMAIN: $DOMAIN
#   SPACE: $SPACE
#   ORG: $ORG"

cd $RR_DIR

# case to handle alpha-edge, the only product with subdomain and route_path in the .rr_config
if [[ ${#SUBDOMAIN}>0 ]]
	then

	if [[ ${#ROUTE_PATH}>0 ]] || [[ $PRIMEDAPP == *"docs-edge-pcfservices"* ]]
		then
		cf push $PRIMEDAPP -i 1 -m 256M -k 1024M -d cfapps.io $SUBDOMAIN ${ROUTE_PATH/--path/--route-path}
		echo "cf push $PRIMEDAPP -i 1 -m 256M -k 1024M -d cfapps.io -n $SUBDOMAIN ${ROUTE_PATH/--path/--route-path}"
		cf apps
		echo "Your app is available at http://$SUBDOMAIN.cfapps.io${ROUTE_PATH/--path /.}"
	fi
fi

if [[ ${#SUBDOMAIN}<1 ]]
	then
	cf push $PRIMEDAPP -i 1 -m 256M -k 1024M -d cfapps.io -n $PRIMEDAPP-primed-for-prod $ROUTE_PATH
	cf apps
	echo "Your app is available at http://$PRIMEDAPP-primed-for-prod.cfapps.io${ROUTE_PATH/--path /.}."
fi
