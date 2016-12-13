# Copy/paste the following line to your shell (without the #) to add `update` as an alias:
# echo 'alias update="ruby ~/workspace/docs-utility-scripts/updater.rb"' >> ~/.bash_profile; source ~/.bash_profile

# This file acts as the updater for updater.rb. This script calls updater_core.rb for the docs repositories update functionality.

# Checkout the 'review' branch of this repo for the review functionality of the updater script.

# Updates docs-utility-scripts

def get_current_updater
	puts "Getting newest version of Updater Suite®, and docs-utility-scripts"
	puts "..."
	`cd ~/workspace/docs-utility-scripts; git checkout master; git pull`
	puts "Updater updated."
end

get_current_updater
require "#{Dir.home}" + '/workspace/docs-utility-scripts/updater_core.rb'
