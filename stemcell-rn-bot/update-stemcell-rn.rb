def update_rn
	stemcell_json = JSON.load(File.open('stemcell-releases.json')).to_json
	rn_repo = Octokit::Repository.from_url('https://github.com/pivotal-cf/pcf-release-notes')

	# this should be set as an ENV VAR
	current_pcf_version_number = 'testtesttest'

	stemcell_rn_file = @client.contents(rn_repo, {:path => 'stemcell-rn.html.md.erb', :ref => current_pcf_version_number})

	sha_stemcell_file = stemcell_rn_file['sha']

	decoded_file = Base64.decode64(stemcell_rn_file['content'])

	File.open('tmp', 'w') {|f| f.write decoded_file }

	puts stemcell_json[4]

	# at line 8 of tmp, add stemcell_json[0]


	# @client.update_contents(rn_repo,
 #                 "stemcell-rn.html.md.erb",
 #                 "Updating content",
 #                 stemcell_rn_file['sha'],
 #                 "File content",
 #                 :branch => current_pcf_version_number)

end

