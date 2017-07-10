# Edge Documentation Playbook

Refer to the [Release Operations Overview](https://github.com/pivotal-cf-experimental/docs-utility-scripts/blob/master/docs-ops-docs/release-operations-overview.md) before you start this playbook.

We publish edge docs using the **cf-edge** pipeline in our concourse CI/CD. 

We start using the **cf-edge** pipeline 30-60 days prior to the release going GA. The **cf-edge** pipeline publishes content for the upcoming release to a staging site. After the release goes GA, we pause the **cf-edge** pipeline until 30-60 days prior to the next release going GA.

## Step One: Publish Current Content From a Versioned Branch

Perform the following steps to move current content from master to a versioned branch:

1. At stand-up and with @here in Slack, tell #pcf-docs and #pcf-docs-team that you are completing this playbook. Specifically, 
	>From this point forward until release, contribute edge content to the master branch. Contribute current content to the versioned branch for that release number (ex. 1.9 content will live on the 1.9 branch). 
1. Determine what the OSS branch will be called, based on what version of CF is included in PCF. For example, PCF 1.11 shipped with CF 259, so the OSS branch is called `259`. Consult the Elastic Runtime Release Notes for more information about which CF version shipped in a particular PCF.
1. Change into your `docs-book-pivotalcf` repo.
1. Check out a new branch called `CURRENT-PCF-VERSION-NUMBER` branch. For example, if the upcoming version of PCF is 1.12, and the current version of PCF is 1.11, the branch should be `1.11`.
	* `$ git checkout -b CURRENT-PCF-VERSION-NUMBER`
1. Open the `config.yml`.
1. Work your way through all the repos listed in the `config.yml` to create new branches from `master`:
	1. `$ git checkout master`
	1. `$ git pull`
	1. `$ git checkout -b NEW-BRANCH`
		<br><br>`NEW-BRANCH` will either be `CURRENT-PCF-VERSION-NUMBER` in a PCF repo, or the OSS branch in a OSS repo. For example, `1.11` or `259`.
	1. `$ git push -u origin NEW-BRANCH`
1. After making all the branches, update the `docs-book-pivotalcf/config.yml` refs with appropriate PCF and OSS branch numbers (1.6/225, 1.7/235, 1.8/239, 1.9/246, etc) for content repos to specify the current version.
	* Current content will publish off of the latest version branch instead of master.
	* Content for the upcoming release will publish off master.
1. Push your changes to `docs-book-pivotalcf` to your new branch:
	* `$ git push -u origin CURRENT-PCF-VERSION-NUMBER`
1. Navigate to **concourse-scripts-docs/cf-current/pcf-CURRENT-VERSION-NUMBER** and open **config.yml**. Below the line that contains the `book:` key-value, add the following:
	* `book_branch: ‘CURRENT-VERSION-NUMBER’`
1. Update concourse changes with the `fly cli`, using the following **rake** commands:
	1. `rake fly:login`
	1. `rake scheme:update_all[cf-current]`
	1. `rake fly:set_pipeline[cf-current]`
1. Commit and push changes to **concourse-scripts-docs**.
1. Check that the current content for PCF publishes from a versioned number branch: 
	1. Navigate to the [cf-current pipeline](https://p-concourse.wings.cf-app.com/teams/system-team-docs-docs-1-88aa/pipelines/cf-current)
	1. Click the group for the current version, `pcf-CURRENT-VERSION`.
	1. Visually verify that the Concourse resource for `docs-book-pivotalcf` points to the correct versioned branch.	1. After the bind job and staging build complete, navigate to the staging site of the current content (ex. https://docs-pcf-staging.cfapps.io/pivotalcf/1-11) to ensure the site displays properly and the content is correct for the version number.

## Step Two: Publish Edge Content From the Master Branch

Perform the following steps to publish edge content from master:

1. Change into `docs-book-pivotalcf/config.yml`.
1. Check out the `master` branch.
1. Edit the relevant values in the following fields to increment version numbers throughout the config. For example, increment `1.9` to `1.10`, and `1-9` to `1-10` in the following sections:
	1. `products: subnav_root:`
	1. `pcf_header:` 
	1. `sections: `
	1. Add a new header to the `local_header_version_list:`
1. Open `docs-book-pivotalcf/redirects.rb`. 
1. Edit the redirects to increment version numbers throughout. For example, increment `1-9` to `1-10` where it appears.
1. Open `docs-book-pcfservices/redirects.rb` and checkout the `edge` branch.
1. Edit the redirects to increment version numbers throughout. For example, increment `1-9` to `1-10` where it appears.
1. Commit and push changes to the core and services repos.
1. Modify **concourse-scripts-docs/cf-edge/deployment-resources.yml**, line 6: `versioned_file: pcf-NEW-VERSION-NUMBER-final_app.tar.gz`
1. Modify **concourse-scripts-docs/cf-edge/pcf-core/config.yml**, line 15: `path: pivotalcf/NEW-VERSION-NUMBER`
1. Update concourse changes with the `fly` cli, using the following **rake** commands:
	1. `rake fly:login`
	1. `rake scheme:update[cf-edge/pcf-core]`
	1. 	`rake fly:set_pipeline[cf-edge]`
1. Commit and push changes to **concourse-scripts-docs**.
1. The **cf-edge** and **cf-current** pipelines push each of the services apps to the same namespace, `docs-pcfservices`, and publish it to the `docs-pcf-staging.cfapps.io` route. So, these two pipelines will each write over the same **docs-pcfservices-blue** and **docs-pcfservices-green** apps in **staging**. To manage this namespacing overload, we only push the **docs-pcfservices** app from the **cf-edge** pipeline for a brief period, during which we follow these steps:
	1. Inform the docs team that you will be pausing the **cf-current** pipelines for a maintenance check.
	1. Pause **cf-current** pipeline, so that the cf-edge pipeline can publish the services and core docs apps.
	1. Kick off the **pcf-core-bind** and the **pcfservices-bind** in the **cf-edge** pipeline.
	1. When both binds complete, navigate to the staging site and check to make sure the correct content displays and that redirects work properly.
	1. When finished, unpause the **cf-current** pipeline and kick off the **pcfservices-bind** in the **cf-current** pipeline to restore the current redirects.
	1. Inform the docs team that cf-current now publishes the latest released version, and that **cf-edge** is set up properly for reviewing edge content.
