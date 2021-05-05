
require_relative 'httplinkfinder.rb'
require_relative 'httplinkvalidator.rb'
require_relative 'httplinkreplacer.rb'
require_relative 'topicvalidator.rb'

class TestHarness

	def RunTest0

	end 

	def RunTest1
		puts "creating test data"
		test_list = [
			["https://docs-pcf-staging.cfapps.io/platform/application-service/2-20/concepts/http-routing.html#tls-to-back-end", "test5.html"], 
			["https://docs-pcf-staging.cfapps.io/platform/application-service/2-10/concepts/http-routing.html#tls-to-back-end", "test6.html"], 
			["https://docs-pcf-staging.cfapps.io/platform/2-10/release-notes/index.html", "test4.html"],
			["http://docs.pivotal.io/platform/application-service/2-9/concepts/http-routing.html#tls-to-back-end", "test5.html"], 
			["http://docs.pivotal.io/platform/application-service/2-10/concepts/http-routing.html#tls-to-back-end", "test6.html"], 
			["https://docs.pivotal.io/platform/2-10/release-notes/index.html", "test4.html"]
		]
		#test_list = [["https://docs.pivotal.io/pks/1-6/release-notes.html", "test1.html"], ["http://docs.pivotal.io/pks/1-6/Xreleasenotes.html", "test2a.html"],["https://docs.pivotal.io/pks/1-6/Xreleasenotes.html", "test2b.html"],["http://docs.pivotal.io/pks/1-7/release-notes.html", "test3.html"]]
		validation_tester1 = HTTPLinkValidator.new

		puts "starting tests"
		validation_tester1.ValidateLinks(test_list)
		puts "test completed: #{validation_tester1.links_list_findings.to_s}"

	end

	def RunTest2
		#what does a linux path look like? use expand_path to determine a file's full path

		puts "test file"
		exists_result = File.exists?("../../../temp/findme.txt")
		puts "exists_result: #{exists_result}"
		exists_path = File.expand_path("../../../temp/findme.txt")           #=> "/home/oracle/bin"
		puts "expanded path: #{exists_path}"
		#  returns: "expanded path: /Users/olivergraves/temp/findme.txt"
	end

	def RunTest3

		puts "Creating test content"
		test_content = "words more words [link desc 1](link text 1) words more words [link desc 2](link text 2).\n\rwords more words [link desc 3]\n\r    (link text 3)."
		test_content = " #{test_content} words more words <a href=\"link text 1b\">link desc 1b</a> words more words <a href=\"link text 2b\">link desc 2b</a>.\n\rwords more words <a href=\"link text 3b\">\n\r     link desc 3b</a>."

		validation_tester1 = HTTPLinkFinder.new
		test_results = validation_tester1.FindAllLinks(test_content)

		puts "test_results href: #{validation_tester1.links_array_href.length} - #{validation_tester1.links_array_href}"
		puts "test_results markdown: #{validation_tester1.links_array_mkdown.length} - #{validation_tester1.links_array_mkdown}"
		puts "test_results combined: #{validation_tester1.links_list.length} - #{validation_tester1.links_list}"

	end

	def RunTest4
		test_url = "https://docs.pivotal.io/tkgi/1-8/release-notes.html"

		validation_tester1 = HTTPLinkFinder.new

		validation_tester1.FindLinksInTopic(test_url)

		puts "test_results href: #{validation_tester1.links_array_href.length} - #{validation_tester1.links_array_href}"
		puts "test_results markdown: #{validation_tester1.links_array_mkdown.length} - #{validation_tester1.links_array_mkdown}"
		puts "test_results combined: #{validation_tester1.links_list.length} - #{validation_tester1.links_list}"
	end

	def RunTest5

		test_url_root = "https://docs.pivotal.io"
		test_url = "https://docs.pivotal.io/tkgi/1-8/release-notes.html"

		#validation_tester1 = HTTPLinkFinder.new
		#validation_tester1.FindLinksInTopic(test_url)

		validation_tester2 = TopicValidator.new
		validation_tester2.ValidateTopic(test_url_root, test_url)

		#puts "urls: #{validation_tester2.test_urls.length} #{validation_tester2.test_urls}"
		#puts "descriptions: #{validation_tester2.test_url_descriptions.length} #{validation_tester2.test_url_descriptions}"

	end


	def RunTest6
		test_url_root = "https://docs.pivotal.io"
		test_url = "https://docs.pivotal.io/application-service/2-10/overview/index.html"

		#validation_tester1 = HTTPLinkFinder.new
		#validation_tester1.FindLinksInTopic(test_url)

		validation_tester2 = TopicValidator.new
		validation_tester2.ValidateTopic(test_url_root, test_url)

		test_url_root = "https://docs-pcf-staging.cfapps.io"
		test_url = "https://docs-pcf-staging.cfapps.io/tas-kubernetes/0-n/index.html"

		#validation_tester1 = HTTPLinkFinder.new
		#validation_tester1.FindLinksInTopic(test_url)

		validation_tester2 = TopicValidator.new
		validation_tester2.ValidateTopic(test_url_root, test_url)

		test_url = "https://docs-pcf-staging.cfapps.io/tkgi/1-9/windows-logging.html"

		validation_tester2 = TopicValidator.new
		validation_tester2.ValidateTopic(test_url_root, test_url)

		#puts "urls: #{validation_tester2.test_urls.length} #{validation_tester2.test_urls}"
		#puts "descriptions: #{validation_tester2.test_url_descriptions.length} #{validation_tester2.test_url_descriptions}"

	end

	def RunTest7


		test_url_root = "https://docs-pcf-staging.cfapps.io"
		test_url = "https://docs-pcf-staging.cfapps.io/tas-kubernetes/0-n/index.html"

		validation_tester2 = TopicValidator.new
		validation_tester2.ValidateTopic(test_url_root, test_url)

	end

	def RunTest8


		test_url_root = "https://docs-pcf-staging.sc2-04-pcf1-apps.oc.vmware.com/"
		test_url = "https://docs-pcf-staging.sc2-04-pcf1-apps.oc.vmware.com/tas-kubernetes/0-n/index.html"

		validation_tester2 = TopicValidator.new
		validation_tester2.ValidateTopic(test_url_root, test_url)

	end

end


tester1 = TestHarness.new
tester1.RunTest8
