require 'sinatra'
require 'json'
require 'octokit'

post '/payload' do

  client = Octokit::Client.new :access_token => ENV['git_token']
  @pr_message = "These changes were made on master and need to be made on " + ENV['pre_release']
  @issue_message = "The following commit(s) was made to master and causes conflicts when trying to merge with #{ENV['pre_release']}. Cherry pick the commit(s) from master to #{ENV['pre_release']} and resolve the conflicts." 
  @push = JSON.parse(request.body.read) # push data
  @array_of_commits = []
  @repo = ""
  @new_branch = ""
  if @push['ref'] == "refs/heads/master"
    @push['commits'].each do |i|
    @array_of_commits.push(i['id'])
    @repo = @push['repository']['full_name']
    end
  end

  pre_release_hash = client.refs(@repo)
  pre_release_hash.each do |i|
    if i['ref'] == "refs/heads/" + ENV['pre_release']
      @pre_release_sha = i['object']['sha']
    end
  end
  

  @new_branch = "refs/heads/master-to-pre-release-" + @pre_release_sha[0..5]

  client.create_ref(@repo, @new_branch, @pre_release_sha)
  @conflicts = []

  print "Repo: " + @repo.to_s
  print "Attempting to merge..."
  @array_of_commits.each do |i|
    begin
      r = client.merge(@repo, @new_branch, i)
  rescue Octokit::Conflict => e
      @conflicts.push(i)
      print "Merge failed."
    end
  end

  if @conflicts.length > 0 
    client.create_issue(@repo, "Master to " + ENV['pre_release'], @issue_message + @conflicts.to_s)
    print "Issue created."
    client.delete_ref(@repo, "heads/master-to-pre-release-" + @pre_release_sha[0..5])
    print "Branch deleted."
  else
    @merge_msg = "Merge this pull request to bring commits into the #{ENV['pre_release']} branch."
    client.create_pull_request(@repo, "refs/heads/" + ENV['pre_release'], @new_branch, "Master to " + ENV['pre_release'], @merge_msg)
    print "PR created."
  end

end