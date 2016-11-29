
scribe: cli driven production tasks for doc contributors

------
prioritized list
------
						
							--help, -h
√	story			s		[-c, --context: OSS, PCF, PWS]<YOUR-STORY-NAME-AND-NUMBER>:
		Complete
	context 		c 						
		Still needs to run story and create wip branches in order to change context
	add 			a 		
	message			m	

===========MVP================
	fly				f		
		Somewhat of a feature that we already have, this commands reduces some complexity	
	bump			bc		[-p, --production], [-r, --review], [-s, --staging], [--email, -e]
	review 			r
		This feature would be sick, but we don't have PR's running through our system yet.	
	prune 			p
		Cleanup feature

Wraps current function
	get-guide		gg	 	[--all,-a] <NAME-OF-GUIDE>, alias update
		Updater
	bind:			b		<GUIDE-NAME>
		Bookbinder
	watch			w		
		Bookbinder
	edit-config		ec		
		Any Editor
	bordify			bt		[-o, --overwrite] <PATH-TO-IMAGE>
	 	Bordify
======

	
   	add 			a 		
	bordify			bt		[-o, --overwrite] <PATH-TO-IMAGE>
	bind:			b		<GUIDE-NAME>
	bump			bc		[-p, --production], [-r, --review], [-s, --staging],
	edit-config		ec		
	fly				f		
	get-guide		gg	 	[--all, -a] <NAME-OF-GUIDE>
	guide 			g 		[--set, -s] <NAME-OF-GUIDE>
	message			m	
	prune 			p
	review 			r
	story			s		[-c, --context: OSS, PCF, PWS]<YOUR-STORY-NAME-AND-NUMBER>:
	update 			u 		alias get-guide
	watch			w		


cli
    scribe add (alias: a)[-f]<OPTIONAL-ROOT-BRANCH-FROM-WHICH-TO-CHECKOUT>
        creates branch with story name for all tracked changes in guide, or uses default 'wip'
        git commits all patches to guide context interactively, 
        does not git push
    scribe bordify (alias: bt)[-o, --overwrite] <PATH-TO-IMAGE>
        calls bordify on image
    scribe bind: (alias: b, build) <GUIDE-NAME>
        build and serve local doc of guide (calling coare first for all unrelated repos)
        defaults to guide set in .scribe, or sets it by matching from .scribe
    scribe bump (alias: bc)[-p, --production], [-r, --review], [-s, --staging],
            [-nc, --no-commit],[--email, -e]
        creates multi-version multi-repo commits/commits-as-PRs to bump ci/cd
        default merges/PRs story branch commits to master and passes story name in git message
        passes optional `fly trigger-job` to bump for production or review after tests
        passing --email will send pre-generated message to email distirbution list
        calls `scribe fly` if changes exist in book-configs (bookbinder)
        bumps 'fly trigger-job' production or review CI/CD without commits if -nc
    scribe context 
    	returns list of contexts from config
    	with passed argument sets context
    scribe edit-config (alias: ec)
        opens .scribe config from workspace in default editor
        set context list and children content repos for guide/book
        see below for details on guide syntax 
            `context: OSS        `
            `    repo: some-repo    - branch name`
    scribe fly (alias: f)
        sets and updates pipelines from book configs (or other content structure)
    scribe get-guide (alias: gg, update) [--all,-a] <NAME-OF-GUIDE>
        defaults to displaying all the guides on the guide list in .scribe config
         gets and/or updates all appropriate repos for passed guide name 
        default set to last used guide
        calls update with all repos from guide from .scribe config
    scribe guide (alias g) [--set, -s] GUIDE-NAME, [--verbose, -v], [--all, -a]
        defaults to return value of guide based on rest resource, /security, /runtime,
        passing --set changes guide in .scribe config
        passing --all shows all guides from the .scribe config
        passing --verbose shows all children contexts and repos
            guide: security
                context: oss
                    repo-foo - branch master
                    repo-bar - branch master
                context: pws 
                    repo-bar - branch pws
                    repo-baz - branch pws
                context: pcf
                    repo-bar - branch security
                    repo-baz - branch security
                    repo-zoolander - branch security
    scribe message (alias: m)
        returns message body and prompts 'Change commit message? [y/n]'
        message contains story number and description on line two
    scribe prune (alias: p) [--all, -a]
        prunes current set story and story-named branches
        interactively locally prunes branches except in .scribe config
        could also prune older than x months
    scribe review (alias: r)
        reviews, approve and reject PRs that have passed tests from master to staging (for what? context? guide?)
    scribe story: (alias: s)[-c, --context: OSS, PCF, PWS]<YOUR-STORY-NAME-AND-NUMBER>:
            [-v, --verbose]
        returns story name or sets and adds it to .scribe config if arg passed,
        returns name of story context or sets it if flag passed
        returns story status of all git-tracked changes in current context repos
        'context' limits scope of tracking to repos under .scribe config
            context setting acts as flag to publish to contexts
        'verbose' displays story normal return values, the metadata/frontmatter of changed files (owners, contributor team), details about the last successful bump to staging, and lists the repos in current context 
HERECONFIG-->
    context:
        - <CONTENT-REPO>
        - <OTHER-CONTENT-REPO>
            
<--HERECONFIG

    scribe update (alias: u)
        calls update for the context repos
    scribe watch (alias: w)
        builds and interactively updates local version of guide with build tool (calling coare against unrelated repos)

feature request
    scribe context matcher: 


Understanding multiple context, versioned products within a guide setting using single-sourced content:

CURRENT-STATE-OF-THE-WORLD:
	/pivotalcf/1-8/buildpacks/java/gsg-spring.html
	/book/version/guide/section/topic#block

Where '/book' could be better associated with clear product naming, this schema should continue to be useful for our publishing. Currently, we have too many topics for the number of sections and we do not treat our guides as first-class tiers. Users and contributors, writers especially, will be better served by guides that are assigned to core team members alongside engineering liaisons.

Tooling needs:
Need block level granularity to publish or not publish to context
All content in OSS repos must be open source.
Commercial content needs to be publishable alongside OSS.
Need contributors to be able to see partial (or granular) content in readmes.
Need to fully separate backend content from its publication.
Need to be able to reuse content in multiple guides, sections or topics.

Understanding blocks
Blocks must become first-class supported tiers of the publishing schema, too!

feature request: 
	block_print function
	A block_print function would allow any block level detail from a marked anchor tag to be re-used anywhere in our docs. Attached submodules or our current book config supply the reusable content. Not all content needs to be reuseable.
	If we can call a block from any other section, we can curate that from the OSS that we need and not worry about it populating our core docs. This effort adds one syntatical element, one that inherits greatly from the existing `partial` function. CI commits that add below the function call commented-out copy of the latest published version of the block make it easier for contibutors to review document when editing.

	block level variable scope
	We should be able to set the value of a variable on the page, so that blocks are mobile, but there value can be set in the front matter of a page as ```var.foo='Page Name'``` and overridden in the block itself using <% var.foo='local value' %> 


content
content
content

.scribe file
The .scribe file and its guide context and settings allow scribe to focus on a subset of repos or dirs in the user workspace. The set context will limit the repos and branches in those repos that scribe will act upon, such as checking git status (scribe status), creating and editing git message (scribe message), bumping the repos with or without batch commits (scribe bump [--nc], etc. From a user perspective, this functionality allows the user to focus on changes that modify documentation from a particular publishing context, the '1.7 PCF docs' or the 'PWS' docs, for example. By managing the git branches and limited scope of repos, the user gains a quicker iteration loop to update the docs, and abstracts the complexity of understanding and managing which branches inform which product docs. From the CLI, the user sets 'scribe guide -s <CONTEXT>' and moves on.

How to set up the config files?
	From a bookbinder perspective (for users using bookbinder), it would be swell if the config could populate with a short list of book repos and branches for those. While nice, that increases the scope of the contexts to the entire book. Not a terrible place to begin, but ideally we limit the scope to guide-level, not book level. Are both possible? Why not? Let's start with the book level and create subsets from there building off of the template of those product-wide contexts. 

product/version/guide/section/topic.html
pivotalcf/1-7/adminguide/config/somethingfoo.html

Context: security_oss 	
	version: current 
		guide: security
			repo-foo
			repo-bar

Context: security_1_7 
	version: 1-7
		guide: security
			repo-bar - branch 1-7
			repo-baz - branch 1-7

Context: security_1_8
	version: 1-8
		guide: security
			repo-bar - branch 1-8
			repo-baz - branch 1-8

Context: security_pws
	version: current
		guide: security
			repo-bar - branch master
			repo-baz - branch master
			repo-zoolander - branch master

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

	context:
		- <CONTENT-REPO>
		- <OTHER-CONTENT-REPO>


# =============



