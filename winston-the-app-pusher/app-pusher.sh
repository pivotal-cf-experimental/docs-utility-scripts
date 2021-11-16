#! /bin/bash -x
export PATH=$PATH:/usr/local/bin/

# Change these variables to match the product name, version number, and URL path of the app you are pushing
VERSION="VERSION-NUMBER"
APP_NAME="PRODUCT-NAME-${VERSION}"
URL="PRODUCT-PATH/${VERSION}"

# These environment variables generally stay the same
GREEN="docs-${APP_NAME}-green"
BLUE="docs-${APP_NAME}-blue"

# These are the cf commands that push blue and green apps to staging and prod
target_stage="cf target -s common-staging"
push_blue="cf push ${BLUE} --no-route"
push_green="cf push ${GREEN} --no-route"
map_stage_blue="cf map-route ${BLUE} sc2-04-pcf1-apps.oc.vmware.com --hostname docs-pcf-staging --path ${URL}"
map_stage_green="cf map-route ${GREEN} sc2-04-pcf1-apps.oc.vmware.com --hostname docs-pcf-staging --path ${URL}"
set_user_blue="cf set-env ${BLUE} SITE_AUTH_USERNAME pivotalcf"
set_pass_blue="cf set-env ${BLUE} SITE_AUTH_PASSWORD wilderror16"
set_user_green="cf set-env ${GREEN} SITE_AUTH_USERNAME pivotalcf"
set_pass_green="cf set-env ${GREEN} SITE_AUTH_PASSWORD wilderror16"
restage_blue="cf restage ${BLUE}"
restage_green="cf restage ${GREEN}"
stop="cf stop ${GREEN}"
target_prod="cf target -s common-prod"
map_prod_blue="cf map-route ${BLUE} tas.vmware.com -n pvtl-docs --path ${URL}"
map_prod_green="cf map-route ${GREEN} tas.vmware.com -n pvtl-docs --path ${URL}"
bind_search_blue="cf bind-service ${BLUE} elastic.co"
bind_search_green="cf bind-service ${GREEN} elastic.co"
list_apps="cf apps | grep ${APP_NAME}"

# Push staging apps
eval "$target_stage"
eval "$push_blue"
eval "$push_green"
eval "$map_stage_blue"
eval "$map_stage_green"
eval "$set_user_blue"
eval "$set_pass_blue"
eval "$set_user_green"
eval "$set_pass_green"
eval "$restage_blue"
eval "$restage_green"
eval "$stop"
printf "\nListing docs-${APP_NAME} apps in common-staging...\n"
eval "$list_apps"

# Push prod apps
eval "$target_prod"
eval "$push_blue"
eval "$push_green"
eval "$map_prod_blue"
eval "$map_prod_green"
#eval "$bind_search_blue"
#eval "$bind_search_green"
eval "$restage_blue"
eval "$restage_green"
eval "$stop"
printf "\nListing docs-${APP_NAME} apps in common-prod...\n"
eval "$list_apps"
