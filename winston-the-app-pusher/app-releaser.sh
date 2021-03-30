#! /bin/bash -x
export PATH=$PATH:/usr/local/bin/

# Change these variables to match the product name, version number, and URL path of the app you are releasing 
VERSION="VERSION-NUMBER"
APP_NAME="PRODUCT-NAME-${VERSION}"
URL="PRODUCT-PATH/${VERSION}"

# These environment variables generally stay the same
GREEN="docs-${APP_NAME}-green"
BLUE="docs-${APP_NAME}-blue"

unset_green_user="cf unset-env ${GREEN} SITE_AUTH_USERNAME"
unset_green_pass="cf unset-env ${GREEN} SITE_AUTH_PASSWORD"
unset_blue_user="cf unset-env ${BLUE} SITE_AUTH_USERNAME"
unset_blue_pass="cf unset-env ${BLUE} SITE_AUTH_PASSWORD"
restage_green="cf restage ${GREEN}"
restage_blue="cf restage ${BLUE}"
stop_green="cf stop ${GREEN}"
stop_blue="cf stop ${BLUE}"

printf "\nRemoving basic auth from the docs-${APP_NAME} apps...\n"
eval "$unset_green_user"
eval "$unset_green_pass"
eval "$unset_blue_user"
eval "$unset_blue_pass"
printf "\nRestaging the docs-${APP_NAME} apps...\n"
eval "$restage_green"
eval "$restage_blue"
printf "\n Stopping ${GREEN} so that only ${BLUE} is running...\n"
eval "$stop_green"

