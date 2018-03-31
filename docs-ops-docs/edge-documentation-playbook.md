# Edge Documentation Playbook

Refer to the [Release Operations Overview](https://github.com/pivotal-cf-experimental/docs-utility-scripts/blob/master/docs-ops-docs/release-operations-overview.md) before you start this playbook.

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

## Step Two: Create New Branch in PCF Book

1. `cd` into `docs-book-pivotalcf`.
1. Check out the `master` branch.
1. Edit `/config.yml`.
1. Under `layout_repo: pivotal-cf/docs-layout-repo`, add the following: `layout_repo_ref: 'edge'`. 
1. Edit the relevant values in the following fields to increment version numbers throughout the config. For example, increment `1.9` to `1.10`, and `1-9` to `1-10` in the following sections:
	1. `products: subnav_root:`
	1. `pcf_header:` 
	1. `sections: `
	1. Add a new header to the `local_header_version_list:`
1. Open `docs-book-pivotalcf/redirects.rb`. 
1. Edit the redirects to increment version numbers throughout. For example, increment `1-9` to `1-10` where it appears.
1. Change all the links in the subnav file to the new version. 
1. Commit and push changes.

## Step Three: Push New CF Apps
1. Run `bundle exec bookbinder bind remote` from the `master` branch of `docs-book-pivotalcf` to create a new app.
1. Change into the `final_app` directory: `cd ~/workspace/docs-book-pivotalcf/final_app`
1. Log in to PWS:
	1. `cf api api.run.pivotal.io`
	1. `cf login`
1. Make sure you are targeting the `pivotalcf-staging` space in the `pivotal-pubtools` org:
	```
	cf target -o pivotal-pubtools -s pivotalcf-staging
	```
1. Push the app twice, as `docs-pcf-NEW-VERSION-NUMBER-blue` and `docs-pcf-NEW-VERSION-NUMBER-green`. For example:
	```
	cf push docs-pcf-1-10-blue -i 3 -k 1024M -b https://github.com/cloudfoundry/ruby-buildpack#v1.6.28 -m 512M --no-route
	```
1. When the `cf push` commands complete, navigate to the app's routes and ensure the content looks good. The route should be provided in the output. For example:
	```
	urls: docs-pcf-1-10-blue.cfapps.io
	```
1. Map each newly deployed app, green and blue, to the destination route. For instance:
	```
	cf map-route docs-pcf-1-10-blue cfapps.io --hostname docs-pcf-staging --path pivotalcf/1-10
	```
1. Browse to the route and ensure the content looks good.
1. Bind each new app to the Elastic.co search service instance:
	```
	cf bind-service APP_NAME elastic.co
	```
1. Enable both blue and green apps with basic auth by setting the environment variables: `SITE_AUTH_USERNAME` to `pivotalcf` and `SITE_AUTH_PASSWORD` to `wilderror16`. For example:
	```
	cf set-env docs-pcf-1-10-blue SITE_AUTH_USERNAME pivotalcf
	cf set env docs-pcf-1-10-blue SITE_AUTH_PASSWORD wilderror16
	cf set-env docs-pcf-1-10-green SITE_AUTH_USERNAME pivotalcf
	cf set-env docs-pcf-1-10-green SITE_AUTH_PASSWORD wilderror16
	```
1. Run `cf restage APP_NAME` on each each app to reflect service and environment var changes.
1. Run `cf stop APP_NAME` to stop one of the apps.
1. Run `cf target -s pivotalcf-production` to move to the production space, where you will continue "priming the pump" by pushing apps to the production space. 
1. As above, run push a green and a blue app, test, set environment vars for basic auth.
  - Map routes to docs.pivotal.io this time, not staging URL. 
  - Skip the `cf bind-service` step with Elastic.co; we don't want edge content search results on production search.
1. `cf push docs-pcf-1-10-green -i 3 -k 1024M -b https://github.com/cloudfoundry/ruby-buildpack#v1.6.28 -m 512M --no-route`
1. `cf map-route docs-pcf-1-10-green docs.pivotal.io --path pivotalcf/1-10`
1. `cf set-env docs-pcf-1-10-blue SITE_AUTH_USERNAME pivotalcf` etc., all four commands as above
1. `cf restage APP_NAME` on each each app.
1. Browse to the route, e.g. `docs.pivotal.io/pivotalcf/1-10`, and ensure the content looks good.
1. `cf stop APP_NAME` to stop one of the apps.

## Step Four: Configure Pipelines for **cf-current** and **cf-previous-versions**

1. Navigate to **concourse-scripts-docs/scripts-docs/cf-current**: `cd ~/workspace/concourse-scripts-docs/scripts-docs/cf-current`
1. Make a new subfolder, e.g. `mkdir pcf-1-11`.
1. Copy content from last version folder into new folder, e.g. `cp -rf pcf-1-10/* pcf-1-11`.
1. In new subfolder `deployment-resources.yml` add new s3 bucket definition code chunk, just like the last version one-- copy, paste, and change version numbers.
```
	- name: cf-current-pcf-OLD-VERSION-s3
	  type: s3
	  source:
	    bucket: concourse-interim-steps
	    versioned_file: pcf-OLD-VERSION-final_app.tar.gz
	    private: true
	    access_key_id: "{{aws-access-key}}"
	    secret_access_key: "{{aws-secret-key}}"
```
1. In new subfolder `config.yml` change `book_branch` def to `book_branch : "master"` and change version numbers.
1. In new subfolder, run `mv` to rename the three autogenerated folders so their name have new version number, e.g. `mv pcf-1-10-bind pcf-1-11-bind`.

## Step Five: Update Pipelines
1. Update concourse changes with the `fly` cli, using the following **rake** commands:
	1. `rake fly:login`
	1. `rake scheme:update[cf-current/NEW-VERSION]`
	1. `rake scheme:update_all[cf-previous-versions]`
	1. `rake fly:set_pipeline[cf-current]`
	1. `rake fly:set_pipeline[cf-previous-versions]`
1. Commit and push changes to **concourse-scripts-docs**.
