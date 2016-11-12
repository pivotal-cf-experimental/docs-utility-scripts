

scribe: cli driven production tasks for doc contributors
	
cli
	scribe update [-g, --guide][-a, -all]
		default set to last used guide
		calls update with all branches from .scribe config
	scribe status: [-c, --context: OSS, PCF, PWS]
		tracks change in workspace or of files listed in .scribe config 
		displays relevant metadata/frontmatter of changed files (owners, contributor team) if set
		status of last bump to staging
	scribe bind: [-g, --guide] <GUIDE-NAME>
		publishes local doc of guide set in .scribe, or sets it by matching from .scribe
	scribe add-commit:
		git commits all patches to guide interactively, but does not git push
	scribe bump [-p, --production], [-r, --review], [-s, --staging]:
		defaults to staging
		pushes commits to staging, and trigger-job to bump production or review if pass
		creates multi-version multi-repo commits to ci/cd
		pushes add-commits to master on repos and updates ci/cd (fly), starts test suite
		if commits pass 
			git merge to staging branch
			test suite ==> staging = === = > production
		else
			git reverts 
	scribe fly:
		sets and updates pipelines from book configs (or other content structure)
	scribe checkout [-s, --story: <STORY-NUMBER>]:
		returns branch name or sets it
	scribe branch:
		alias 'scribe checkout'
	scribe message, -m
		returns message body and prompts 'Change commit message? [y/n]'
		message contains story number and description on line two
	scribe prune
		prunes branches except in .scribe config
		



		# handle_args
find_home # helper sets workspace([what?]) and show pwd 
add_docs_dirs_repos #helper adds repos to model


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

