# Use this branch, the 'review' branch, to idempotently add review branches to all repos listed in the config.yml files of the four docs books: OSS, PWS, core & services. If this branch is checked out, just run `update` from CL.

# Additionally, the review sites can be used to review changes to the docs-layout-repo, so this script adds the review branch there, as well, and all commercial books publish off of the review branch of the layout repo.

# Checkout the 'review' branch of this repo for the review functionality of the updater script.

# Updates docs-utility-scripts
def get_current_updater
	puts "Getting newest version of Updater Suite® Re√iew, and docs-utility-scripts"
	puts "..."
	`cd ~/workspace/docs-utility-scripts; git checkout master; git pull`
	puts "Updater Re√iew updated."
end

# get_current_updater
require "#{Dir.home}" + '/workspace/docs-utility-scripts/updater_core.rb'
