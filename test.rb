require 'json'
require 'open-uri'
require 'base64'


#get and parse the list of stemcell releases from pivnet
stemcells = URI.parse('https://network.pivotal.io/api/v2/products/stemcells/releases').read
stemcells = JSON.parse(stemcells) 
stemcells_list = stemcells['releases']
today = Time.now.strftime("%Y/%m/%d").gsub!('/','-')

#put the list of stemcells in order of their version numbers
sorted_stemcells_list = stemcells_list.sort_by { |h| h['release_date'] }.reverse

right_stemcells = sorted_stemcells_list.select do |d|
d['release_date']
end

stemcells_numbers_list = right_stemcells.map do |r| 
puts r['release_date'] 
	if r['release_date'] == today
		curl -X POST -H 'Content-type: application/json' --data '{"text":"@docteam A new stemcell released today."}' https://hooks.slack.com/services/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
	else
		curl -X POST -H 'Content-type: application/json' --data '{"text":"No new stemcell releases today."}' https://hooks.slack.com/services/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
	end
end
