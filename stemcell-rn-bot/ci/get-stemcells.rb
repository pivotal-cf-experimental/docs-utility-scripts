require 'json'
require 'octokit'
require 'open-uri'
require 'base64'

module Resources
  class Github
    def initialize
      @client = Octokit::Client.new(auto_paginate: true, access_token: ENV['GITHUB_ACCESS_TOKEN'])
    end

    def get_stemcell_releases
      get_bosh_stemcell_releases + get_linux_stemcell_builder_releases
    end

    private
    def get_bosh_stemcell_releases
      bosh_releases = @client.releases 'cloudfoundry/bosh'

      bosh_releases.select do |r|
        r[:name].start_with?("Stemcell")
      end.map do |release|
        release_to_hash(release)
      end
    end

    def get_linux_stemcell_builder_releases
      bosh_releases = @client.releases 'cloudfoundry/bosh-linux-stemcell-builder'
      bosh_releases.map do |release|
        release_to_hash(release)
      end
    end

    def release_to_hash(release)
      version = release[:name][/\d+(\.\d+)?/]
      version_split = version.split('.')
      major_version = version_split[0].to_i
      minor_version = 0
      minor_version = version_split[1].to_i if version_split.length > 1

      {
        'name' => release[:name],
        'version' => release[:name][/\d+(\.\d+)?/],
        'major_version' => major_version,
        'minor_version' => minor_version,
        'body' => release[:body],
        'created_at' => release[:created_at],
        'pivnet_available' => false,
      }
    end
  end

  class Pivnet
    def get_pivnet_releases
      #get and parse the list of stemcell releases from pivnet
      stemcells = URI.parse('https://network.pivotal.io/api/v2/products/stemcells/releases').read
      stemcells = JSON.parse(stemcells)
      stemcells_list = stemcells['releases']

      #put the list of stemcells in order of their version numbers
      sorted_stemcells_list = stemcells_list.sort_by { |h| h['version'] }.reverse

      right_stemcells = sorted_stemcells_list.select do |d|
        d['version'].start_with?("#{@starting_stemcell_version}")
      end

      stemcells_numbers_list = right_stemcells.map do |r|
        r['version']
      end

      return stemcells_numbers_list
    end
  end
end

def sorted_releases_by_major_version(releases)
  result = {}
  releases.each do |release|
    unless result.has_key? release['major_version']
      result[release['major_version']] = []
    end

    result[release['major_version']] << release
  end

  return result.sort.reverse.to_h
end

def main
  pivnet = Resources::Pivnet.new
  github = Resources::Github.new
  pivnet_releases = pivnet.get_pivnet_releases
  github_releases = github.get_stemcell_releases

  output = <<-HEADER
---
title: Stemcell Release Notes
Owner: BOSH
---

This topic includes release notes for Linux stemcells used with Pivotal Cloud Foundry (PCF).\n\n
HEADER

  major_version_releases = sorted_releases_by_major_version(github_releases)

  major_version_releases.each do |major_version, minor_releases|

    output += "## Stemcell v#{major_version}.x (Linux) Release Notes\n\n"
    output += "This topic includes release notes for the #{major_version} line of Linux stemcells used with Pivotal Cloud Foundry (PCF).\n\n"

    minor_releases.sort_by {|release| release['minor_version']}

    minor_releases.each_with_index do |release, i|
      version = release['version']

      output += "### <a id=\"#{version.sub('.', '-')}\"></a>#{version}\n\n"

      output += "**Available in Pivotal Network**\n\n" if pivnet_releases.include?(version)

      release_date = release['created_at'].strftime("%B %d, %Y")
      output += "**Release Date**: #{release_date}\n\n"

      output += release['body']+ "\n\n"

      additional_info_path = 'additional_info'
      additional_context_file = File.join(additional_info_path, "_#{version.sub('.', '-')}.html.md.erb")
      if File.exist?(additional_context_file)
        file = File.open(additional_context_file, "rb")
        output += file.read + "\n\n"
        file.close
      end
    end
  end

  puts output
end

main
