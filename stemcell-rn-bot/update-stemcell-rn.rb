
def build_new_rn
	#build new release notes file

	header = ["---", "title: Stemcell Release Notes", "Owner: BOSH", "---", " ", "This topic includes release notes for stemcells used with Pivotal Cloud Foundry (PCF) versions 1.10.x."]
	
	#add the header to the file
	File.open('tmp', 'w') do |f| 
      f.puts(header)
	  end

	JSON.parse(@existing_stemcell_json).each do |f|

		#create stemcell number header
		stemcell_number = f[0][1].split(" ").last
		stemcell_number_a_id = stemcell_number.gsub(".", "-")
		stemcell_number_header = "\#\# <a id=\"#{stemcell_number_a_id}\"></a>#{stemcell_number}"

		#create date
		date = f[1][1]
		dateline = DateTime.parse(date).strftime("**Release Date**: %B %-d, %Y")

		# create body
		body = f[2][1]
		# if body is more than one line, format it properly
		if body.include?("\n")
			body = body.gsub("\n", "\n" * 2)
		end

		# write the file
		File.open('./tmp', 'a') do |f| 
	      	f.puts("\n" + stemcell_number_header)
	      	f.puts("\n" + dateline)
	      	f.puts("\n" + body)
	  	end
	  end
end

def update_rn

	rn_repo = Octokit::Repository.from_url('https://github.com/pivotal-cf/pcf-release-notes')
	stemcell_rn_file = @client.contents(rn_repo, {:path => 'stemcell-rn.html.md.erb', :ref => @current_pcf_version_number})

	# update the stemcell release notes
	@client.update_contents(rn_repo,
                 "stemcell-rn.html.md.erb",
                 "Stemcell RN Bot automatically updating content from BOSH GitHub page",
                 stemcell_rn_file['sha'],
                 File.open('./tmp').read,
                 :branch => @current_pcf_version_number)

	# clean up
	File.delete('tmp')

end