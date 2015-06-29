#Add this code to your bash profile to enable the utility scripts


# 'find_link KEYWORD' searches the entire workspace directory (exluding the output of bookbinder) for links containing the keyword. it returns a list of these with the line number and file name where the link appears.

function find_link {
	grep -E -r -n --exclude-dir='*final*' --exclude-dir='*output*' "(<a.+href|\().+$1.+html.+(>|\))" ~/workspace
}

export -f find_link

#  run the command 'coare' inside of a docs-book- directory to comment out all of the repos in the config.yml except for those including the keyword entered after the prompt. this makes bookbinder bind local run much faster. run `coare` and just hit enter when prompted for a keyword to uncomment all repos, returning the config.yml to its original state.

function comment_out_all_repos_except {

	ruby /Users/mtrestman/bin/comment_out_all_repos_except.rb $@

}

alias coare='comment_out_all_repos_except'




# command 'gxo' opens current directory in gitx
# comment out or delete this line, and the reference to gxo inside the findtopic function, if you don't use gitx (although I recommend you use gitx)

alias gxo='open -a GitX .'

# command 'subl' opens current directory in sublime text 2
# comment out or delete this line, and the reference to subl inside the findtopic function, if you don't use sublime. if you don't use sublime, replace the subl command in the findtopic function with the command that opens your text editor

alias subl='open -a sublime\ text\ 2'

# command 'bashpro' opens bash profile
alias bashpro='subl ~/.bash_profile'

# command 'find_topic KEYWORD' or 'ft KEYWORD' searches through your workspace directory and returns a menu of topics with the keyword in the title. entering the menu number of the topic opens the topic in sublime and opens the repo containing the topic in gitx.

# if you use a different text editor and/or git gui, replace the lines refering to subl and gxo with commands that open your text editor and git gui.

file_records=()
function findtopic {
	echo 'enter topic to find:  '
	read X
	FILES=`find ~/workspace -name "*${X}*.html*" -not -path '*final_app*' -not -path '*output*'`
	# echo -n 'first file: '
	# echo ${FILES[0]}

	counter=0
	file_records=()
	for FILE in ${FILES[@]}
	do
		echo "${counter}: $FILE"
		echo "----------------------------------------"
		file_records[$counter]=$FILE
		counter=$(( $counter + 1 )) 
	done
	echo 'which file would you like to open?'
	read f_to_o
	subl ${file_records[$f_to_o]}
	dur=`dirname "${file_records[$f_to_o]}"`
	gxo $dur
	cd $dur
}

export -f find_topic
alias ft='findtopic'

# command 'rerack' moves back up a level (out of final_app and back into the docs-book-* directory), executes 'bundle exec bookbinder bind local', then moves back into final_app and executes 'rackup'.

function rerack {
	cd ../ 
	bundle exec bookbinder bind local
	cd final_app
	rackup
}


