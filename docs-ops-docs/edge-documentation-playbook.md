# Edge Documentation Playbook

Refer to the [Release Operations Overview](https://github.com/pivotal-cf-experimental/docs-utility-scripts/blob/master/docs-ops-docs/release-operations-overview.md) before you start this playbook.

We publish edge docs using the **cf-edge** pipeline in our concourse CI/CD. 

We start using the **cf-edge** pipeline 30-60 days prior to the release going GA. The **cf-edge** pipeline publishes content for the upcoming release to a staging site. After the release goes GA, we pause the **cf-edge** pipeline until 30-60 days prior to the next release going GA.

## Step One: Publish Current Content From a Versioned Branch

Perform the following steps to move current content from master to a versioned branch:

1. Create and checkout CURRENT-VERSION-NUMBER branch in the docs-book-pivotalcf repo.
1. Populate config.yml refs with appropriate commercial and OSS branch numbers (1.6/225, 1.7/235, 1.8/239, 1.9/246) for content repos to specify the current version
	1. Current content will publish off of the latest version branch instead of master.
	1. Content for the upcoming release will publish off master.
1. Create new branches in content repos that publish the PCF core book.
	1. (Option 1) Use rr switcheroo to create new branches in all corresponding content repos. `Switcheroo` will parse **docs-book-pivotalcf/config.yml** and ask interactively to populate new branches based on the following naming scheme:
		1. New PCF release number for commercial content repos
		1. Corresponding OSS release number for OSS content repos
	1. (Option 2) Manually create new branches in all corresponding content repos manually depending on the following naming scheme:
		1. New PCF release number for commercial content repos
		1. Corresponding OSS release number for OSS content repos
		1. Commit and push changes to **docs-book-pivotalcf** and new content repo branches. 
1. At stand-up and with @here in Slack, tell #pcf-docs and #pcf-docs-team that you are completing this playbook. Specifically, 
>From this point forward until release, contribute edge content to the master branch. Contribute current content to the versioned branch for that release number (ex. 1.9 content will live on the 1.9 branch). 
1. Navigate to **concourse-scripts-docs/cf-current/pcf-CURRENT-VERSION-NUMBER** and open **config.yml**. Below the line that contains the `book:` key-value, add the following:
`book-branch: ‘EDGE-VERSION-NUMBER’`
1. Update concourse changes with the `fly cli`, using the following **rake** commands:
	1. `rake fly:login`
	1. `rake scheme:update_all[cf-edge]`
	1. 	`rake fly:set_pipeline[cf-edge]`
1. Commit and push changes to **concourse-scripts-docs**.
1. Check that the current content for PCF publishes from a versioned number branch: 
	1. Navigate to the [cf-current pipeline](https://p-concourse.wings.cf-app.com/teams/system-team-docs-docs-1-88aa/pipelines/cf-current)
	1. Click the group for the current version, pcf-CURRENT-VERSION
	1. Visually verify that the concourse resource for docs-book-pivotalcf points to the correct versioned branch, 1.9 in the example below: 

	image missing
	
	1. After the bind job and staging build complete, navigate to the staging site of the current content (ex. https://docs-pcf-staging.cfapps.io/pivotalcf/1-9) to ensure the site displays properly and the content is correct for the version number.

## Step Two: Publish Edge Content From the Master Branch

Perform the following steps to publish edge content from master:

1. Open **docs-book-pivotalcf/config.yml** on the master branch.
1. Edit the relevant values in the following fields to increment version numbers throughout the config. For example, increment `1.9` to `1.10`, and `1-9` to `1-10` in the following sections:
	1. `products: subnav_root:`
	1. `pcf_header:` 
	1. `sections: `
	1. Add a new header to the `local_header_version_list:`
1. Open **docs-book-pivotalcf/redirects.rb** and checkout the `master` branch. 
1. Edit the redirects to increment version numbers throughout. For example, increment `1-9` to `1-10` where it appears.
1. Open **docs-book-pcfservices/redirects.rb** and checkout the `edge` branch.
1. Edit the redirects to increment version numbers throughout. For example, increment `1-9` to `1-10` where it appears.
1. Commit and push changes to the core and services repos.
1. Modify **concourse-scripts-docs/cf-edge/deployment-resources.yml**, line 6: `versioned_file: pcf-NEW-VERSION-NUMBER-final_app.tar.gz`
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

## Step Three: Update the Utility Configs

1. Update the **scribe** config:
	1. Open **docs-utility-scripts/rollback_release/rr_config.yml**
	1. Add a new product section for the next version product, including its new key/values. 
1. Populate **scribe** with new map numbers (**docs-utility-scripts/scribe/scribe#map**)
1. Update **docs-utility-scripts/rollback_release/rr_config.yml** `PCF-Alpha-Edge` values:
	1. `branch: EDGE-VERSION-NUMBER`
	1. `route_path: '--path /pivotalcf/NEW-VERSION-NUMBER`

