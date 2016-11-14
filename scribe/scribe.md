

scribe: cli driven production tasks for doc contributors
	
	add 			a 		
	bordify			bt		[-o, --overwrite] <PATH-TO-IMAGE>
	bind:			b		<GUIDE-NAME>
	bump			bc		[-p, --production], [-r, --review], [-s, --staging],
	edit-config		ec		
	fly				f		
	get-guide		gg	 	[--all,-a] <NAME-OF-GUIDE>
	message			m	
	prune 			p
	review 			r
	story			s		[-c, --context: OSS, PCF, PWS]<YOUR-STORY-NAME-AND-NUMBER>:
	watch			w		


cli
	scribe add (alias: a)[-f]<OPTIONAL-ROOT-BRANCH-FROM-WHICH-TO-CHECKOUT>
		creates branch with story name for all tracked changes, or uses default 'wip'
		git commits all patches to guide context interactively, 
		does not git push
	scribe bordify (alias: bt)[-o, --overwrite] <PATH-TO-IMAGE>
		calls bordify on image
	scribe bind: (alias: b, build) <GUIDE-NAME>
		build and serve local doc of guide 
		defaults to guide set in .scribe, or sets it by matching from .scribe
	scribe bump (alias: bc)[-p, --production], [-r, --review], [-s, --staging],
			[-nc, --no-commit]
		creates multi-version multi-repo commits/commits-as-PRs to bump ci/cd
		default merges/PRs story branch commits to master and passes story name in git message
		passes optional `fly trigger-job` to bump for production or review after tests
		calls `scribe fly` if changes exist in book-configs (bookbinder)
		bumps 'fly trigger-job' production or review CI/CD without commits if -nc
	scribe edit-config (alias: ec)
		opens scribe .config from workspace in default editor
		set context list and children content repos for guide/book
			`context: OSS		`
			`	repo: some-repo	`
			`	repo: foo-repo	`
			`	repo: bar-repo	`
			`context: custom	`
			`	repo: baz-repo	`
			`	repo: doge-repo	``
	scribe fly (alias: f)
		sets and updates pipelines from book configs (or other content structure)
	scribe get-guide (alias: gg, update) [--all,-a] <NAME-OF-GUIDE>
		defaults to displaying all the guides on the guide list in .scribe config
	 	gets and/or updates all appropriate repos for passed guide name 
		default set to last used guide
		calls update with all repos from guide from .scribe config
	scribe message (alias: m)
		returns message body and prompts 'Change commit message? [y/n]'
		message contains story number and description on line two
	scribe review (alias: r)
		reviews, approve and reject PRs that have passed tests from master to staging
	scribe story: (alias: s)[-c, --context: OSS, PCF, PWS]<YOUR-STORY-NAME-AND-NUMBER>:
			[-v, --verbose]
		returns story name or sets and adds it to .scribe config if arg passed,
		returns name of story context or sets it if flag passed
		returns story status of all git-tracked changes in current context repos
		'context' limits scope of tracking to repos under .scribe config
		'verbose' displays story normal return values, the metadata/frontmatter of changed files (owners, contributor team), details about the last successful bump to staging, and lists the repos in current context 
	scribe prune (alias: p) [--all, -a]
		prunes current set story and story-named branches
		interactively locally prunes branches except in .scribe config
	scribe watch (alias: w)
		builds and interactively updates local version of guide with build tool

CI/CD test suite
	commits
		if commits pass deploy script 
			create PR against staging branch
			test suite ==> staging = === = > production
		else
			git checkout branch onto story branch from message or 'wip:author'
			git checkout master
			git revert bad commits from repos mentioned in git message
	PRs
		if PRs against master pass deploy script tests (bind, etc)
			accept PR against master
			move content to staging for review
			test suite ==> staging = === = > production
		else
			don't accept PR
			close it?
			show failing test link

		# handle_args
find_home # helper sets workspace([what?]) and show pwd 
add_docs_dirs_repos #helper adds repos to model


Requirements


Examples story status output
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

