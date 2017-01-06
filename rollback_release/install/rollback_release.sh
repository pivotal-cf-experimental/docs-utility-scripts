#!/bin/bash
# To install rollback_release, run this script by pasting the following command at the command line (not including the '#' symbol):
# sh $HOME/workspace/docs-utility-scripts/rollback_release/install/rollback_release.sh

set -e

MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' 
echo 'alias rr="env RR_PWD=$PWD ruby $HOME/workspace/docs-utility-scripts/rollback_release/rr"' >> ~/.bash_profile
echo 'source ~/.bash_profile'
printf "\n${MAGENTA}  The rollback_release app is ready to go!\n\n  You can now run it with 'rr' from any directory at the command line.${NC}\n"
