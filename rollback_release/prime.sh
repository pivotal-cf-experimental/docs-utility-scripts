#!/bin/bash
#   receives PRIMEDAPP, SPACE, & ORG for cf push and start app with test route 

# echo $PRIMEDAPP
# echo $SPACE
# echo $ORG
set -e
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' 
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

# printf "\n  Let's check the 'cf target'..."
# cf target

# printf "\n  Are you in the right space to push the ${MAGENTA}$PRIMEDAPP${NC} app? [Y/n]"
# while true; do
#     read -p "" yn
#     case $yn in
#         [Yy]* ) echo "\nOK, let's double check by viewing the 'cf apps'...\n"; break;;
#         [Nn]* ) echo "Please 'cf target -s <YOUR-DESIRED-SPACE>\n"; exit;;
#         * ) echo "Please answer yes or no.";;
#     esac
# done

cf target -o $ORG -s $SPACE
cf apps

printf "\nPush the ${MAGENTA}$PRIMEDAPP${NC} app? [Y/n]\n"
while true; do
    read -p '' yn
    case $yn in
        [Yy]* ) echo "Pushing $PRIMEDAPP\n"; break;;
        [Nn]* ) echo "No $PRIMEDAPP will be pushed.\n"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "we pushed $PRIMEDAPP"




# NEW_ORG=pivotal-pubtools
# NEW_SPACE=gemfire82-prod
# NEW_APP_STATIC=docs-gemfire82-green
# NEW_APP=docs-gemfire82-blue

# OLD_ORG=pivotal
# OLD_SPACE=docs
#OLD_APP_BLUE=docs-gemfire-closed-blue
#OLD_APP_GREEN=docs-gemfire-closed-green

# DOMAIN=docs.gopivotal.com
# HOSTNAME=gemfire

#cf target -o ${NEW_ORG} -s ${NEW_SPACE}
#cf start ${NEW_APP}
#cf stop ${NEW_APP_STATIC}

# cf target -o ${OLD_ORG} -s ${OLD_SPACE}
# cf delete-route ${DOMAIN} -n ${HOSTNAME}

# cf target -o ${NEW_ORG} -s ${NEW_SPACE}
# cf map-route ${NEW_APP} ${DOMAIN} -n ${HOSTNAME}
# cf map-route ${NEW_APP_STATIC} ${DOMAIN} -n ${HOSTNAME}

# cf apps

# echo "ruby rr"

# while true; do
#     read -p "Do you wish to install this program? [Y/n]" yn
#     case $yn in
#         [Yy]* ) echo ="yes"; break;;
#         [Nn]* ) echo ="no"; exit;;
#         * ) echo "Please answer yes or no.";;
#     esac
# done

# set +x
# echo ="testing echo"
# read -p 'Press enter to shut down old app'

# set -x

# echo "Do you wish to install this program? [Y/n]"
# select yn in "Yes" "No"; do
#     case $yn in
#         Yes ) echo ="yes"; break;;
#         No ) echo ="no"; exit;;
#     esac
# done


#cf target -o ${OLD_ORG} -s ${OLD_SPACE}

#cf stop ${OLD_APP_BLUE}
#cf stop ${OLD_APP_GREEN}
