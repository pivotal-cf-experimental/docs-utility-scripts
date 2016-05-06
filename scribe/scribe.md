Requirements

scribe
	report [-v]	Shows any stashed changes on story branch
			-v 	Calls diff
	diff     	Shows changes 

	pull [-v]
		Pulls current (CODE SMELL: pull should only be done on master, prior to,	... yes?)
		-v 		Verbose shows git conflict messages

	story 		Shows all stories in flight (perhaps branches are stored as 'SCRIBE-branch-name-and-id')
		[branch-and-story-id]		Starts new story 
	commit 'commit message'			
	master							Puts all branches back to master, stashing all changes (or committing them with 'wip')
										(any prior 'wip' commits could be squashed into future commits (as default), or rolled back manually)
	deliver							Checks out master merges story branch, deletes branch commits?
	pcf watch --> aliases to a path and 'bookbinder watch' so it can be run from ANYWHERE	
	cf watch
	pws watch - same thing, diff book

## Accept branch-and-story-id

# scribe (default is to report)
## Find all docs-books and store the config content repos.
## Find and identify:
 	workspace
 	books
    content repos for which there are any git status changes

scribe diff (report + verbose)
	shows report + all diffs between HEAD~1 and HEAD

# scribe pull
	pulls all book and content repos and rebases any content
	returns success or failed ('run with -v' for message)
	-v: output any merge conflict or other git messages 

# scribe story (branch-and-story-id)
## Create a new branch to batch add/commit changes
	(stash, checkout -b YOUR-BRANCH, stash pop)


#scribe commit "commit message"
	Batch commit


<!-- ======= -->
# ~/workspace/docs-pcf-install|detached:origin/pre-release S:4 ✗
# master 	|	modified
# 				helpers/...
# 				scribe.rb
#
 				# modified:   cloudform-er-config.html.md.erb
 				# modified:   config-er-vmware.html.md.erb
 				# modified:   pcf-aws-manual-er-config.html.md.erb 				# 

# =============




# how to deal w:
	# rebase conflicts
	# merge conflicts
	# git colors
	# 


# where flow is:
	# change content_repose -->
	# git status -->
	# func(message, branch) = git commit -am "message "

