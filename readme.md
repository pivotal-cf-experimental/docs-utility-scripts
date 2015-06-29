This repo contains useful scripts to help with the Pivotal Cloud Foundry docs team's workflow.


utilities:

* coare

	coare is short for 'comment out all repos except'. run this terminal command inside of any docs-book- directory to edit the config.yml file, commenting out all of the repos except ones that match the keyword that you give when prompted. This makes 'bookbinder bind local' run about a zillion times faster.

* find_link KEYWORD

* find_topic KEYWORD / ft KEYWORD

	find_topic searches your workspace directory for html* files have the keyword in their name and give you a menu of the results. selecting a topic from the menu opens the topic in your text editor and git gui (sublime text 2 and gitx by default)

* rerack

	a slight time saver, combining 'bundle exec bookbinder bind local' and 'rackup'

	run this inside final app to cd up to the docs book repo, bind local, cd back down into final_app and rackup.

Installation:

Add the stuff in stuff_to_add_to_bash_profile to your bash profile to enable some useful terminal commands.

Put comment_out_all_repos_except.rb in your ~/bin/ folder so that the 'coare' terminal command can execute its function.



run passive_finder.rb in your workspace directory (or a repo directory) to generate a list of all instances of passive voice contained in all topics nested in that directory.