require 'net/http'

class HTTPLinkFinder

	attr_reader :links_list
	attr_reader :skipped_folder_list
	attr_reader :skipped_file_list

	attr_reader :links_array_href
	attr_reader :links_array_mkdown

	def initialize
		@links_list = []
		@skipped_folder_list = []
		@skipped_file_list = []

		@links_array_href = []
		@links_array_mkdown = []
	end

	def FindLinksInFolder(folder_path)

		#Verify folder exists
		#for each file in folder
		#   Is this a folder? recurse File.ftype(file_name)    returns “file'', “directory'', and other strings
		#   Is file .html.md.erb?  File.fnmatch?( pattern, path, [flags] ) → (true or false)click to tog
		#   Determine file Status  File.readable?(file_name) File.size(file_name) 
		#        Add file's BAD Status to BAD Status List
		#   Read File
		#       Collect links in file
		#       Add links in file to links list

	end

	def FindLinksInFile(file_path)
		#Verify file exists
		#Open file   File.open(filename, mode="r" [, opt])
		#If possible collapse file to single line, then check if there are any links
		# look for links:
		#   links can be of form <a href="http.*"> or [display text](http.*)
		#   return all found links

		file_content = ""
		file_link_list = []

		file_content = ReadFileContent(file_path)
		if file_content.length > 0 then
			FindAllLinks(file_content)
			#if file_link_list.length > 0 then
			#	#append all items to the main links list
			#	@links_list += file_link_list
			#end

		end

	end

	def FindLinksInTopic(url_path)
		#Verify file exists
		#Open file   File.open(filename, mode="r" [, opt])
		#If possible collapse file to single line, then check if there are any links
		# look for links:
		#   links can be of form <a href="http.*"> or [display text](http.*)
		#   return all found links

		file_content = ""
		file_link_list = []

		file_content = ReadFileContentFromStagingTopic(url_path)		#ReadFileContentFromTopic(url_path)
		if file_content.length > 0 then
			FindAllLinks(file_content)
			#if file_link_list.length > 0 then
			#	#append all items to the main links list
			#	@links_list += file_link_list
			#end

		end

	end

	def ReadFileContentFromTopic(url_path)
		uri_to_read = URI(url_path) 
		file_content = Net::HTTP.get(uri_to_read)

		revised_content = CleanUpContent(file_content)

		revised_content
	end

	def ReadFileContentFromStagingTopic(url_path)
		test_uri = URI(url_path)
		http_obj = Net::HTTP.new(test_uri.host, test_uri.port)
		http_obj.use_ssl = true
		#http_obj.verify_mode = OpenSSL::SSL::VERIFY_PEER		#VERIFY_NONE # You should use VERIFY_PEER in production
		return_get = Net::HTTP::Get.new(test_uri.request_uri)
		return_get.basic_auth('pivotalcf', 'wilderror16')
		return_response = http_obj.request(return_get)

		file_content = return_response.body

		revised_content = CleanUpContent(file_content)

		revised_content
	end

	def ReadFileContent(file_path)
		exists_result = File.exists?(file_path)
		file_content_raw = []
		file_content = ""

	end

	def CleanUpContent(content_raw)
		revised_content = content_raw
		revised_content.gsub!(/a href=/, "a^^^href=")
		revised_content.gsub!(/\s/, "")
		revised_content.gsub!("\n", "")
		revised_content.gsub!("\r", "")
		revised_content.gsub!(/a\^\^\^href=/, "a href=")

		revised_content

	end

	def FindAllLinks(file_content)
		#The desired code will not be tricked into reporting any instance of http as a link requiring validation.
		# I think we want to only test the link types that will cause an error:
		# Links in [Description](Link Content) format
		# Links in <a href="Link Content">Description</a> format
		# 
		# Pattern matching is more complicated if returns and spaces must be accounted for
		# We could remove all white space before processing content

		file_content_searchable = CleanUpContent(file_content)
		#file_content_searchable = file_content
		#file_content_searchable.gsub!(/a href=/, "a^^^href=")
		#file_content_searchable.gsub!(/\s/, "")
		#file_content_searchable.gsub!("\n", "")
		#file_content_searchable.gsub!("\r", "")
		#file_content_searchable.gsub!(/a\^\^\^href=/, "a href=")

		link_pattern_a = /<a href="([^\"]*)">([^<]*)<\/a>/
		link_pattern_b = /\[([^\]]*)\]\(([^\)]*)\)/

		link_pattern_c = /<a href="([^\"]*)">[^<]*<\/a>|\[([^\]]*)\]\(([^\)]*)\)/

		#links_array_raw = file_content_searchable.scan(link_pattern_c)
		#links_array = CreateUsableLinksList(links_array_raw)
		#The scan will return an array of arrays
		#If the sub arrays match the returns in Rubular the desired content is in different postions
		#within the sub array depending on if the hit was pattern 1 or pattern 2
		

		#might as well let ruby do the heavy lifting instead
		links_array_a = file_content_searchable.scan(link_pattern_a)
		links_array_b = file_content_searchable.scan(link_pattern_b)

		#links_array = links_array_a.concat(links_array_b)

		@links_array_href += links_array_a
		@links_array_mkdown += links_array_b

		@links_list += links_array_a
		@links_list += links_array_b

	end


end

