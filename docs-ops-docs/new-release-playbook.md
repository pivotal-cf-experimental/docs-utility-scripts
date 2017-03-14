# New Release Playbook

Refer to the [Release Operations Overview](https://github.com/pivotal-cf-experimental/docs-utility-scripts/blob/master/docs-ops-docs/release-operations-overview.md) before you start this playbook.

## Step One: Prepare cf-current Pipeline

Perform the following steps to add a new group to the **cf-current** pipeline (with no path to production) one to two days before the new release goes GA:

1. Navigate to the [cf-current pipeline in Concourse](https://p-concourse.wings.cf-app.com/teams/system-team-docs-docs-1-88aa/pipelines/cf-current). You should see the following groups: 
	* **oss**
	* **pws**
	* **pcfservices**
	* **pcf-\<CURRENT-VERSION-NUMBER>**
1. Add a new group for **pcf-\<NEW-VERSION-NUMBER>** to **cf-current** pipeline by copying the directory that contains the **pcf-\<CURRENT-VERSION-NUMBER>** group and modifying its configuration files. These examples below assume that `1.10` is the new release, and `1.9` is the current release. 
	1. `cd concourse-scripts-docs/cf-current`
	1. `cp -r pcf-1-9 ./pcf-1-10`
	1. Delete the `pcf-1-9-production` directory.
	1. Rename the remaining `pcf-1-9*` directories within `concourse-scripts-docs/cf-current/pcf-1-10` to `pcf-1-10*`.
	1. Open config.yml in pcf-1-10 and edit the following fields:
		1. Remove Line 3: `book_branch: '1.9'`
(If no branch is specified, it defaults to master.)
		1. Line 5: `app_name: docs-pcf-1-9` => `docs-pcf-1-10`
		1. Line 16: `path: pivotalcf/1-9` => `pivotalcf/1-10`
		1. Remove the production section.
	1. Open `concourse-scripts-docs/cf-current/deployment-resources.yml` and add a new section for the S3 bucket:

		```
		- name: cf-current-pcf-1-10-s3
		   type: s3
		   source:
		     bucket: concourse-interim-steps
		     versioned_file: pcf-1-10-final_app.tar.gz
		     private: true
		     access_key_id: "{{aws-access-key}}"
		     secret_access_key: "{{aws-secret-key}}"
		```
1. Update concourse files with changes using the fly cli with the following rake commands:
	1. `rake fly:login`
	1. `rake scheme:update[cf-current/pcf-<NEW-VERSION-NUMBER>]`
	1. `rake fly:set_pipeline[cf-current]`
	1. `rake pipeline:update[cf-current]`
1. Commit and push the changes to concourse-scripts-docs.
1. Adding the new group adds the capacity to publish these docs using Concourse. Navigate to the [cf-current pipeline in Concourse](https://p-concourse.wings.cf-app.com/teams/system-team-docs-docs-1-88aa/pipelines/cf-current). The groups in the cf-current pipeline should look as follows:
	* **oss**
	* **pws**
	* **pcfservices**
	* **pcf-\<CURRENT-VERSION-NUMBER>**
	* **pcf-\<NEW-VERSION-NUMBER>**
1. Communicate to the docs team at stand-up and with @here in #pcf-docs-team Slack, that there is now a **pcf-\<NEW-VERSION-NUMBER>** group in the cf-current pipeline. Tell the team not to kick off any builds in the **pcf-\<NEW-VERSION-NUMBER>** group, including the bind and staging job.

## Step Two: Push a New Staging App

1. Change into the `docs-book-pivotalcf` directory and switch to the `master` branch.
1. Run `bookbinder bind remote`.
1. When the bind completes, change into the `final_app` directory.
1. Push the app as `docs-pcf-NEW-VERSION-NUMBER-blue`. For example:
	`cf push docs-pcf-1-10-blue -b https://github.com/cloudfoundry/ruby-buildpack#v1.6.28`
1. When the command completes, navigate to the app's route and ensure the content looks good. The route should be provided in the output. For example:
	`urls: docs-pcf-1-10-blue.cfapps.io`
1. Navigate to the Concourse UI and pause the `cf-edge` pipeline.
1. Map the newly deployed app to the route currently mapped to `docs-pcf-edge-blue` and `docs-pcf-edge-green`. For instance:
	`cf map-route docs-pcf-1-10-blue cfapps.io --hostname docs-pcf-staging --path pivotalcf/1-10`
1. Navigate to the route and ensure the content looks good.
1. Stop the running `docs-pcf-edge` app.
1. Kick off a new build of the `pcf-NEW-VERSION-NUMBER-bind` under the `pcf-NEW-VERSION-NUMBER` group in `cf-current`. For instance, `pcf-1-10-bind` under `pcf-1-10` in `cf-current`.
1. Ensure that both `pcf-NEW-VERSION-NUMBER-blue` and `pcf-NEW-VERSION-NUMBER-green` are bound to Elastico service instances.
1. Ensure that both `pcf-NEW-VERSION-NUMBER-blue` and `pcf-NEW-VERSION-NUMBER-green` have basic auth enabled. To enable auth, set the following environment variables: `SITE_AUTH_USERNAME` to YOUR-USERNAME and `SITE_AUTH_PASSWORD` to YOUR-PASWORD.

## Step Three: Publish the New Release Docs

Perform the following steps to publish the new release docs on the day the new release goes GA:

1. Pause cf-edge pipeline.
1. Navigate to the pcf-<NEW-VERSION-NUMBER> group in the [cf-current pipeline in Concourse](https://p-concourse.wings.cf-app.com/teams/system-team-docs-docs-1-88aa/pipelines/cf-current). 
	1. Kick off the bind job, wait for it to populate green builds through to the staging job.
	1. Verify the staging build publishes the new release docs to the staging site.
	1. Kick off the production job, wait for it to finish, and verify that the new release docs are live. 

## Step Three: Update Redirects to Serve the New Release Docs 

Perform the following steps after **Step Two** to point redirects of current docs to the new release docs and as soon as the new release goes GA:

1. Replace the master version of **docs-book-pcfservices/redirects.rb** with the edge version.
	1. `git checkout master`
	1. `git checkout edge redirects.rb`
	1. `git commit -m “Adds new release redirects”`
	1. `git push`
1. Navigate to the **pcfservices group** in the **cf-current** pipeline in [Concourse ](https://p-concourse.wings.cf-app.com/teams/system-team-docs-docs-1-88aa/pipelines/cf-current?groups=pcfservices). 
	1. Kick off the bind job, wait for it to populate green builds through to the staging job.
	1. Verify the staging build publishes the new release docs to the staging site.
	1. Kick off the production job, wait for it to finish, and verify that the Pivotal Cloud Foundry docs link at docs.pivotal.io points to new release docs URL. 

## Step Four: Move PCF-Not-So-Current to cf-previous-versions pipeline

1. Copy the directories from cf-current to cf-previous-versions.
1. Edit deployment-resources.yml to reflect the correct group.
