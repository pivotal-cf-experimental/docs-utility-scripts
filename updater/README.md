THE PROBLEM:

With the vast number of docs services repos coming, we need a really easy way to stay current with all the repos. Specifically, we need a script to do the following:

• Go through and check if you have a repo for all of the books from each book config.yml file
• If not, clone the new repo
• Otherwise, $ git pull to keep current with the team

THE SOLUTION

While a number of scripts have gotten us this far (mostly, thanks to Ben!) I've created updater.rb to read each of the docs-books config.yml files, gather the repos, and clone or update them, accordingly. I've added it to the docs-utility-scripts repo. 

DO THIS IF YOU HAVE THE docs-utility-scripts REPO :

Copy/paste the following to your command line:

`cd ~/workspace/docs-utility-scripts`

`git pull`

`echo 'alias update="ruby ~/workspace/docs-utility-scripts/updater/updater.rb"' >> ~/.bash_profile`

`source ~/.bash_profile`

`rm .update_repos.sh`

OR, DO THIS IF YOU DON'T:

Copy/paste the following to your command line:

`cd ~/workspace`

`git clone git@github.com:pivotal-cf-experimental/docs-utility-scripts.git`

`echo 'alias update="ruby ~/workspace/docs-utility-scripts/updater.rb"' >> ~/.bash_profile`

`source ~/.bash_profile`

`rm .update_repos.sh`

AND, THEN, YOU CAN DO THIS:

Run $ update from your command line whenever you want.

TOTALLY-FINE-PRINT DETAILS:

 This script assumes: 
 
• your workspace is located at ~/workspace

• the docs group only has the four books: pcf, pws, cf and services

• you have a .bash_profile file

• you have added your RSA key for git cloning

• you're ok with removing .update_repos.sh (the old repo update script)

• you can clean up your .bash_profile if you want to remove the old "update" alias
