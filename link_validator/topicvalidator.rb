require_relative 'httplinkfinder.rb'
require_relative 'httplinkvalidator.rb'

class TopicValidator

	attr_reader :site_root
	attr_reader :site_url

	attr_reader :links_array_href
	attr_reader :links_array_mkdown

	attr_reader :test_urls
	attr_reader :test_url_descriptions

	def initialize
		@site_root = ""
		@links_array_href = []
		@links_array_mkdown = []

		@test_urls = []
		@test_url_descriptions = []
	end

	def ValidateTopic(topic_site_root, topic_url)

		@site_root = topic_site_root
		@site_url = topic_url

		link_finder = HTTPLinkFinder.new
		link_finder.FindLinksInTopic(@site_url)

		@links_array_href = link_finder.links_array_href
		@links_array_mkdown = link_finder.links_array_mkdown

		url_pos = 0
		descr_pos = 1
		BuildTestURLsLists(links_array_href, url_pos, descr_pos)

		url_pos = 1
		descr_pos = 0
		BuildTestURLsLists(links_array_mkdown, url_pos, descr_pos)

		validation_tester = HTTPLinkValidator.new

		puts "starting tests: href links:#{links_array_href}  - markdown links: #{links_array_mkdown}"
		validation_tester.ValidateLinks(@test_urls)
		puts "test completed: #{validation_tester.links_list_findings.to_s}"

	end

	def BuildTestURLsLists(links_array, url_pos, descr_pos)
		links_array.each{ |single_url_pair|
			single_url = single_url_pair[url_pos]
			single_desc = single_url_pair[descr_pos]
			if single_url[0] == "#" then
				#puts "ignoring #{single_url}"
			else
				if single_url[0] == "/" then
					single_url = "#{@site_root}#{single_url}"
					#puts "enhancing #{single_url}"
				end

				single_url_research = [single_url, "Topic Name-#{single_desc}"]

				@test_urls << single_url_research
				@test_url_descriptions << single_desc

			end
		}

	end

end