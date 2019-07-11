# Edge Documentation Playbook

Refer to the [Release Operations Overview](https://github.com/pivotal-cf-experimental/docs-utility-scripts/blob/master/docs-ops-docs/release-operations-overview.md) before you start this playbook.

## Step One: Publish Current Content From a Versioned Branch

To move current content from `master` to a versioned branch, do the following:

1. At stand-up and with @here in Slack, tell #pcf-docs and #pcf-docs-team that you are completing this playbook. Specifically, 
	>From this point forward until release, contribute edge content to the master branch. Contribute current content to the versioned branch for that release number (ex. 2.5 content will live on the 2.5 branch). 

1. Determine what the OSS branch will be called, based on what version of Cloud Foundry shipped closest to the current version of PCF. For example, PCF 2.5 shipped around the same time as CF 7.9, so the OSS branch is called `7.9`. To determine which CF version shipped closest to the release date of the current version of PCF, see the [cf-deployment release page](https://github.com/cloudfoundry/cf-deployment/releases) on GitHub.

1. Change into your `docs-book-pivotalcf` repo.

1. Check out a new branch called `CURRENT-PCF-VERSION-NUMBER` branch. For example, if the upcoming version of PCF is 2.7, and the current version of PCF is 2.6, the branch should be `2.6`.
	* `$ git checkout -b CURRENT-PCF-VERSION-NUMBER`

1. Open the `config.yml`.

1. Work your way through all the repos listed in the `config.yml` to create new branches from `master`:
	1. `$ git checkout master`
	1. `$ git pull`
	1. `$ git checkout -b NEW-BRANCH`
		<br><br>`NEW-BRANCH` will either be `CURRENT-PCF-VERSION-NUMBER` in a PCF repo, or the OSS branch in a OSS repo. For example, `2.6` or `9.3`.
	1. `$ git push -u origin NEW-BRANCH`

1. After making all the branches, update the `docs-book-pivotalcf/config.yml` refs with appropriate PCF and OSS branch numbers (2.4/6.7, 2.5/7.9, 2.6/9.3, etc.) for content repos to specify the current version.
	* Current content will publish off of the latest version branch instead of master.
	* Content for the upcoming release will publish off master.

1. Push your changes to `docs-book-pivotalcf` to your new branch:
	* `$ git push -u origin CURRENT-PCF-VERSION-NUMBER`

1. Navigate to **concourse-scripts-docs/cf-current/pcf-CURRENT-VERSION-NUMBER** and open **config.yml**. Below the line that contains the `book:` key-value, add the following:
	* `book_branch: ‘CURRENT-VERSION-NUMBER’`

1. Update Concourse changes with the `fly cli`, using the following **rake** commands:
	1. `rake fly:login`
	1. `rake scheme:update_all[cf-current]`
	1. `rake fly:set_pipeline[cf-current]`

1. Commit and push changes to **concourse-scripts-docs**.

1. Check that the current content for PCF publishes from a versioned number branch: 
	1. Navigate to the [cf-current pipeline](https://p-concourse.wings.cf-app.com/teams/system-team-docs-docs-1-88aa/pipelines/cf-current)
	1. Click the group for the current version, `pcf-CURRENT-VERSION`.
	1. Visually verify that the Concourse resource for `docs-book-pivotalcf` points to the correct versioned branch.	1. After the bind job and staging build complete, navigate to the staging site of the current content (ex. https://docs-pcf-staging.cfapps.io/pivotalcf/2-6) to ensure the site displays properly and the content is correct for the version number.
	
1. Update the branch names in the [Git Branch Map](https://docs-wiki.cfapps.io/wiki/git/git-branch-map.html) in the Docs Wiki by adding the current PCF version number and its corresponding OSS branch number to the bottom of the list before `master`.

## Step Two: Create New Branch in PCF Book

To create a new versioned branch in `docs-book-pivotalcf`, do the following:

1. `cd` into `docs-book-pivotalcf`.

1. Check out the `master` branch.

1. Edit `/config.yml`.

1. Under `layout_repo: pivotal-cf/docs-layout-repo`, add the following: `layout_repo_ref: 'edge'`. 

1. Edit the relevant values in the following fields to increment version numbers throughout the config. For example, increment `2.6` to `2.7`, and `2-6` to `2-7` in the following sections:
	1. `products: subnav_root:`
	1. `pcf_header:` 
	1. `sections: `
	1. Add a new header to the `local_header_version_list:`

1. Open `docs-book-pivotalcf/redirects.rb`. 

1. Edit the redirects to increment version numbers throughout. For example, increment `2-6` to `2-7` where it appears.

1. Open `docs-book-pivotalcf/config/template_variables.yml`.

1. Change `current_major_version` and `v_major_version` to the new version.

1. Open `docs-book-pivotalcf/master_middleman/source/subnavs/pcf-subnav.erb`.

1. Change the link titles in the subnav file that reference a PCF version to the new version. 

1. Commit and push changes.

## Step Three: Push New CF Apps

To build and push the staging and production sites for the new `master` branch, do the following:

1. `cd` into `concourse-scripts-docs/bin/fly` and download the latest `fly` binary pack from the [concourse](https://github.com/concourse/concourse/releases) repository on GitHub.

1. `cd` into `docs-book-pivotalcf` and go to the `master` branch.

1. Make sure you have the correct Bookbinder Ruby gem installed by running `gem install ./bookbindery-10.1.15.gem`.

1. Run `bundle exec bookbinder bind remote` to create a new app.

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
	cf push docs-pcf-2-7-blue -i 3 -m 256M -k 1024M -s cflinuxfs3 -b null -d cfapps.io -n docs-pcf-staging --no-route
	```
	```
	cf push docs-pcf-2-7-green -i 3 -m 256M -k 1024M -s cflinuxfs3 -b null -d cfapps.io -n docs-pcf-staging --no-route
	```

1. When the `cf push` commands complete, navigate to the app's routes and ensure the content looks good. The route should be provided in the output. For example:
	```
	urls: docs-pcf-2-7-blue.cfapps.io
	```
	```
	urls: docs-pcf-2-7-green.cfapps.io
	```

1. Map each newly deployed app, blue and green, to the destination route.
	```
	cf map-route docs-pcf-2-7-blue cfapps.io --hostname docs-pcf-staging --path pivotalcf/2-7
	```
	```
	cf map-route docs-pcf-2-7-green cfapps.io --hostname docs-pcf-staging --path pivotalcf/2-7
	```

1. Browse to the route and ensure the content looks good.

1. Run `cf target -s pivotalcf-production` to move to the production space, where you will continue "priming the pump" by pushing apps to the production space. 

1. As above, push a green and a blue app -- but  this time, map routes to docs.pivotal.io rather than the staging URL.
	- `cf push docs-pcf-2-7-blue -i 3 -m 256M -k 1024M -s cflinuxfs3 -b null -d docs.pivotal.io --no-route`
	- `cf push docs-pcf-2-7-green -i 3 -m 256M -k 1024M -s cflinuxfs3 -b null -d docs.pivotal.io --no-route`
	- `cf map-route docs-pcf-2-7-blue docs.pivotal.io --path pivotalcf/2-7`
	- `cf map-route docs-pcf-2-7-green docs.pivotal.io --path pivotalcf/2-7`

1. Browse to the route, e.g. `docs.pivotal.io/pivotalcf/2-7`, and ensure the content looks good.

## Step Four: Configure Pipelines for **cf-current** and **cf-previous-versions**

To configure the Concourse pipelines to accommodate the new version, do the following:

1. Navigate to **concourse-scripts-docs/scripts-docs/cf-current**: `cd ~/workspace/concourse-scripts-docs/scripts-docs/cf-current`

1. Make a new subfolder, e.g. `mkdir pcf-2-7`.

1. Copy content from last version folder into new folder, e.g. `cp -rf pcf-2-6/* pcf-2-7`.

1. In `deployment-resources.yml`, add a new S3 bucket definition code chunk, just like the last version one -- copy, paste, and change version numbers.
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

1. In new subfolder `config.yml`, change `book_branch` def to `book_branch : "master"` and change version numbers.

1. In new subfolder, run `mv` to rename the three autogenerated folders so their name have new version number, e.g. `mv pcf-2-6-bind pcf-2-7-bind`.

1. In each of the three folders (e.g. `pcf-2-7-bind`, `pcf-2-7-staging`, and `pcf-2-7-production`) open `plan.yml` and change version numbers.

Only two pipelines should be in `cf-current`: the current release version, ane the new edge version. When a new edge version is created, the oldest version is moved to `cf-previous-versions`. For example, when PCF 2.6 is released and the edge version goes from PCF 2.6 to PCF 2.7, PCF 2.5 must be moved to `cf-previous-versions`.

To move a pipeline to `cf-previous-versions`, do the following:

1. Navigate to **concourse-scripts-docs/scripts-docs/cf-previous-versions**: `cd ~/workspace/concourse-scripts-docs/scripts-docs/cf-previous-versions` (or `cd ../cf-previous-versions` if already in `cf-current`)

1. Make a new subfolder, e.g. `mkdir pcf-2-5`.

1. Navigate back to **cf-current**: `cd ../cf-current`

1. Copy the contents of the subfolder with the same name in `cf-current` to the new subfolder in `cf-previous-versions`, e.g. `cp -rf pcf-2-5/* ../cf-previous-versions/pcf-2-5`

1. Delete the subfolder in `cf-current`, e.g. `rm -f pcf-2-5`

1. Delete the S3 bucket definition code chunk for the removed pipeline from `deployment-resources.yml`.

1. Navigate back to **cf-previous-versions**: `cd ../cf-previous-versions`

1. Add the S3 bucket definition code chunk you removed from `cf-current` to the `deployment-resources.yml` file in `cf-previous-versions`.

## Step Five: Update Pipelines

To update the pipelines you just reconfigured in Concourse, do the following:

1. Make sure the `Gemfile` and `Gemfile.lock` files in your local `docs-book-pivotalcf` repo list the Bookbinder version as `10.1.15`. This is the version required to build and push the apps, which is different from the version Bookbinder uses to build locally. You can stash these changes after updating Concourse.

1. Update Concourse changes with the `fly` cli, using the following **rake** commands:
	1. `rake fly:login`
	1. `export BOOKBINDER_EDGE=true`
	1. `rake scheme:update[cf-current/NEW-VERSION]`
	1. `rake scheme:update_all[cf-previous-versions]`
	1. `rake fly:set_pipeline[cf-current]`
	1. `rake fly:set_pipeline[cf-previous-versions]`

1. Commit and push changes to **concourse-scripts-docs**.

1. Go to Concourse and check the pipelines to make sure they are present and building properly. Once the staging site is green for each, click the **+** icon on each pipeline to ensure that the production sites are running.
