#! /bin/bash -x
export PATH=$PATH:/usr/local/bin/

# Change these variables to match the product name, version number, and URL path of the app you are pushing
VERSION="VERSION-NUMBER"
APP_NAME="PRODUCT-NAME-${VERSION}"
URL="PRODUCT-PATH/${VERSION}"

# These environment variables generally stay the same
GREEN="docs-${APP_NAME}-green"
BLUE="docs-${APP_NAME}-blue"

# These commands push blue and green apps to staging and prod
target_stage="cf target -s pivotalcf-staging"
push_blue="cf push ${BLUE} --no-route"
push_green="cf push ${GREEN} --no-route"
map_stage_blue="cf map-route ${BLUE} cfapps.io --hostname docs-pcf-staging --path ${URL}"
map_stage_green="cf map-route ${GREEN} cfapps.io --hostname docs-pcf-staging --path ${URL}"
set_user_blue="cf set-env ${BLUE} SITE_AUTH_USERNAME pivotalcf"
set_pass_blue="cf set-env ${BLUE} SITE_AUTH_PASSWORD wilderror16"
set_user_green="cf set-env ${GREEN} SITE_AUTH_USERNAME pivotalcf"
set_pass_green="cf set-env ${GREEN} SITE_AUTH_PASSWORD wilderror16"
restage_blue="cf restage ${BLUE}"
restage_green="cf restage ${GREEN}"
stop="cf stop ${GREEN}"
target_prod="cf target -s pivotalcf-prod"
map_prod_blue="cf map-route ${BLUE} docs.pivotal.io --path ${URL}"
map_prod_green="cf map-route ${GREEN} docs.pivotal.io --path ${URL}"

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
eval "$target_prod"
eval "$push_blue"
eval "$push_green"
eval "$map_prod_blue"
eval "$map_prod_green"
eval "$restage_blue"
eval "$restage_green"
eval "$stop"
