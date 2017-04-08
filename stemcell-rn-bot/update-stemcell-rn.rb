
def build_new_rn(content)
	#build new release notes file

	file = <<-HEADER
---
title: Stemcell Release Notes
Owner: BOSH
---

This topic includes release notes for stemcells used with Pivotal Cloud Foundry (PCF) versions 1.10.x.
HEADER
	
	JSON.parse(content).each do |f|

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

	 	file.concat("\n" + stemcell_number_header + "\n")
	 	file.concat("\n" + dateline + "\n")
	 	file.concat("\n" + body + "\n")

	  end  
	  return file
end

def update_rn(content)

	stemcell_rn_file = @client.contents('pivotal-cf/pcf-release-notes', {:path => 'stemcell-rn.html.md.erb', :ref => @current_pcf_version_number})

	# update the stemcell release notes
	@client.update_contents('pivotal-cf/pcf-release-notes',
                 "stemcell-rn.html.md.erb",
                 "Stemcell RN Bot automatically updating content from BOSH GitHub page",
                 stemcell_rn_file['sha'],
                 content,
                 :branch => @current_pcf_version_number)

end