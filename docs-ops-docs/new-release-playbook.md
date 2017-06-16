# New Release Playbook

Refer to the [Release Operations Overview](https://github.com/pivotal-cf-experimental/docs-utility-scripts/blob/master/docs-ops-docs/release-operations-overview.md) before you start this playbook.

## Step One: Prepare cf-current Pipeline

Perform the following steps to add a new group to the **cf-current** pipeline (with no path to production) one to two days before the new release goes GA:

1. Navigate to the [cf-current pipeline in Concourse](https://p-concourse.wings.cf-app.com/teams/system-team-docs-docs-1-88aa/pipelines/cf-current). You should see the following groups: 
	* **oss**
	* **pws**
	* **pcfservices**
	* **pcf-\<CURRENT-VERSION-NUMBER>**
1. Add a new group for **pcf-\<NEW-VERSION-NUMBER>** to **cf-current** pipeline by copying the directory from the **cf-edge** pipeline. The examples below assume that `1.10` is the new release, and that it is currently published by `cf-edge/pcf-core`.
	1. `cd concourse-scripts-docs/cf-current`
	1. `cp -r ../cf-edge/pcf-core ./pcf-1-10`
	1. Open config.yml in pcf-1-10 and edit the following fields:
		1. Line 4: `app_name: docs-pcf-edge` => `docs-pcf-1-10`
	1. Rename the `pcf-core-bind` and `pcf-core-staging` directories to `pcf-1-10-bind` and `pcf-1-10-staging`.
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
1. Update concourse files with changes using the `fly` CLI with the following rake commands:
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
1. Log in to PWS:
	1. `cf api api.run.pivotal.io`
	1. `cf login`
1. Make sure you are targeting the `pivotalcf-staging` space in the `pivotal-pubtools` org:
	```
	cf target -o pivotal-pubtools -s pivotalcf-staging
	```
1. Push the app as `docs-pcf-NEW-VERSION-NUMBER-blue`. For example:
	```
	cf push docs-pcf-1-10-blue -b https://github.com/cloudfoundry/ruby-buildpack#v1.6.28 -i 3
	```
1. When the command completes, navigate to the app's route and ensure the content looks good. The route should be provided in the output. For example:
	```
	urls: docs-pcf-1-10-blue.cfapps.io
	```
1. Navigate to the Concourse UI and pause the `cf-edge` pipeline.
1. Map the newly deployed app to the route currently mapped to `docs-pcf-edge-blue` and `docs-pcf-edge-green`. For instance:
	```
	cf map-route docs-pcf-1-10-blue cfapps.io --hostname docs-pcf-staging --path pivotalcf/1-10
	```
1. Navigate to the route and ensure the content looks good.
1. Bind the new app to the Elastic.co service instance:
	```
	cf bind-service APP_NAME elastic.co
	```
1. Stop the running `docs-pcf-edge` app.
1. Kick off a new build of the `pcf-NEW-VERSION-NUMBER-bind` under the `pcf-NEW-VERSION-NUMBER` group in `cf-current`. For instance, `pcf-1-10-bind` under `pcf-1-10` in `cf-current`.
1. Ensure that both `pcf-NEW-VERSION-NUMBER-blue` and `pcf-NEW-VERSION-NUMBER-green` are bound to Elastico service instances. 
	1. List the service instances bound to apps with `cf services`.
	1. If one or both of the apps aren't bound to `elastic.co`, run `cf bind-service APP_NAME elastic.co`.
1. Ensure that both `pcf-NEW-VERSION-NUMBER-blue` and `pcf-NEW-VERSION-NUMBER-green` have basic auth enabled. To enable auth, set the following environment variables: `SITE_AUTH_USERNAME` to `pivotalcf` and `SITE_AUTH_PASSWORD` to `wilderror16`:
	```
	cf set-env docs-pcf-1-10-blue SITE_AUTH_USERNAME pivotalcf
	cf set env docs-pcf-1-10-blue SITE_AUTH_PASSWORD wilderror16
	cf set-env docs-pcf-1-10-green SITE_AUTH_USERNAME pivotalcf
	cf set-env docs-pcf-1-10-green SITE_AUTH_PASSWORD wilderror16
	```
1. Wait until the new release goes GA, then complete the rest of this playbook.

## Step Three: Push the Production App

Perform the following steps to publish the new release docs on the day the new release goes GA:

1. Pause the `pcf-NEW-VERSION-NUMBER-bind` and `pcf-NEW-VERSION-NUMBER-staging` jobs using the `fly` CLI. For example:
	1. `fly -t wings pause-job --job cf-current/pcf-1-10-bind`
	1. `fly -t wings pause-job --job cf-current/pcf-1-10-staging`
1. Change into `docs-book-pivotalcf` and ensure you're on the `master` branch.
1. Remove the red banner by removing the line in the `config.yml` that specifies that the book consumes the `edge` branch of the `docs-layout-repo`.
1. Update the redirects in `redirects.rb` to point to the correct version.
1. Push and commit your changes to `docs-book-pivotalcf` on `master`.
1. Run `bookbinder bind remote`.
1. When the bind completes, change into the `final_app` directory.
1. Make sure you are targeting the `pivotalcf-prod` space in the `pivotal-pubtools` org:
	```
	cf target -o pivotal-pubtools -s pivotalcf-prod
	```
1. Push the app as `docs-pcf-NEW-VERSION-NUMBER-blue` with a random route. For example:
	```
	cf push docs-pcf-1-10-blue -b https://github.com/cloudfoundry/ruby-buildpack#v1.6.28 --random-route -i 3
	```
1. Retrieve the random route from the command's output and navigate to it. Ensure the content looks good. Make sure that it references the right version, that it does not contain the red banner, and that the redirects are pointing to the 1.10 docs.
1. Change the redirects in `docs-book-pcfservices` but do not commit and push the changes.
1. Add the correct route. For example:
	```
	cf map-route docs-pcf-1-10-blue docs.pivotal.io --path pivotalcf/1-10
	```
1. Push the changes to `docs-book-pcfservices`.
1. When the `pcfservices-staging` job completes, navigate to the [staging site](https://docs-pcf-staging.cfapps.io) to make sure the redirects work properly.
1. If the redirects are working on staging, kick off the `pcfservices-production` build.

## Step Four: Hook Up Concourse

1. Unpause the `pcf-NEW-VERSION-NUMBER-bind` and `pcf-NEW-VERSION-NUMBER-staging` jobs using the `fly` CLI. For example:
	1. `fly -t wings unpause-job --job cf-current/pcf-1-10-bind`
	1. `fly -t wings unpause-job --job cf-current/pcf-1-10-staging`
1. Kick off another `pcf-NEW-VERSION-NUMBER-bind` job and wait for the staging job to complete. 
1. Check the staging site to make sure everything looks good.
1. Change into `concourse-scripts-docs/cf-current/pcf-NEW-VERSION-NUMBER` and open `config.yml`.
1. Add the production job to the config. For example:
	```
	- name: production
          depends_on: staging
          trigger: false
          endpoint: https://api.run.pivotal.io
          organization: pivotal-pubtools
          space: pivotalcf-prod
          routes:
            - domain: docs.pivotal.io
              path: pivotalcf/1-10
	```
1. Update the pipeline with the new config:
	1. `rake fly:login`
	1. `rake scheme:update[cf-current/pcf-NEW-VERSION-NUMBER]`
	1. `rake fly:set_pipeline[cf-current]`
	1. `rake pipeline:update[cf-current]`
1. Add, commit, and push your changes to `concourse-scripts-docs`.
1. Navigate to the Concourse UI. You should now see a `pcf-NEW-VERSION-NUMBER-production` job.
1. Kick off the `pcf-NEW-VERSION-NUMBER-production` job.
1. Pray.
1. When the production job finishes, you should have a search-enabled site. Now Concourse manages everything, so no more manual app pushes.

## Step Five: Move PCF-Not-So-Current to cf-previous-versions pipeline

1. Change into `concourse-scripts-docs`.
1. Move the directory that contains the not-so-current group from `cf-current` to `cf-previous-versions`. For example:
	```
	mv cf-current/pcf-1-9 cf-previous-versions/.
	```
1. Change into `cf-current`.
1. Open `deployment-resources.yml` and cut the section for the not-so-current docs. For example, remove the following section:
	```
	- name: cf-current-pcf-1-9-s3
          type: s3
          source:
            bucket: concourse-interim-steps
            versioned_file: pcf-1-9-final_app.tar.gz
            private: true
            access_key_id: "{{aws-access-key}}"
            secret_access_key: "{{aws-secret-key}}"
    	```
1. Change into `cf-previous-versions`.
1. Open `deployment-resources.yml` and paste the section you cut from the other `deployment-resources.yml` and change the `name` to `cf-previous-versions-pcf-VERSION-NUMBER-s3`. For example:
	```
	- name: cf-previous-versions-pcf-1-9-s3
          type: s3
          source:
            bucket: concourse-interim-steps
            versioned_file: pcf-1-9-final_app.tar.gz
            private: true
            access_key_id: "{{aws-access-key}}"
            secret_access_key: "{{aws-secret-key}}"
    	```
1. Update concourse files with changes using the `fly` CLI with the following rake commands:
	1. `rake fly:login`
	1. `rake scheme:update_all[cf-current]`
	1. `rake scheme:update_all[cf-previous-versions]`
	1. `rake fly:set_pipeline[cf-current]`
	1. `rake fly:set_pipeline[cf-previous-versions]`
	1. `rake pipeline:update[cf-current]`
	1. `rake pipeline:update[cf-previous-versions]`
1. Commit and push the changes to concourse-scripts-docs.
