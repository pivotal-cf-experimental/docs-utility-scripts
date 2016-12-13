#!/bin/bash

MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' 

echo 'alias rr="ruby ~/workspace/docs-utility-scripts/rollback_release/rr"' >> ~/.bash_profile
printf "\n${MAGENTA}  The rollback_release app is ready to go!\n\n  You can now run it with 'rr' from any directory at the command line.${NC}"
source ~/.bash_profile

