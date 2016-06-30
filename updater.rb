# Copy/paste the following line to your shell (without the #) to add `update` as an alias:
# echo 'alias update="ruby ~/workspace/docs-utility-scripts/updater.rb"' >> ~/.bash_profile; source ~/.bash_profile

# This file now acts as the updater for updater and the update functionality
#   for docs repos lives in updater_core.rb, which this script calls.

# Updates docs-utility-scripts
def get_current_updater
	puts "Getting newest version of Updater Suite® and docs-utility-scripts"
	puts "..."
	`cd ~/workspace/docs-utility-scripts; git checkout master; git pull`
	puts "All good."
end

get_current_updater
require "#{Dir.home}" + '/workspace/' + 'docs-utility-scripts/updater_core.rb'
