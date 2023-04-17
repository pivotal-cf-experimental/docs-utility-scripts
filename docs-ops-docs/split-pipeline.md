# Splitting an Unversioned Pipeline into Two Versioned Pipelines

**Note:** These playbooks are out of date. For current practices, see [Splitting an Unversioned Pipeline into Two Versioned Pipelines](https://docs-wiki.cfapps.io/wiki/pipelines/split-pipeline.html) in the docs wiki.

**Note to services writers:** Don't follow the procedures on this page. This is core-specific content.

## Step One: Creating New Version Branches of the Content and Book Repositories

1. `cd` into the content repository for the pipeline you want to split.

1. Run `git pull`.

1. Check out a new branch called CURRENT-VERSION-NUMBER branch. For example, if the upcoming version of PAS for Windows (PASW) is v2.8, and the current version of PASW is v2.7, the branch should be 2.7.<br>Make sure you run `git checkout -b CURRENT-VERSION-NUMBER` from the `master` branch. Whichever branch you run this command from, that is the branch that gets copied into the new branch. For example, if you were to run the command from the `2.5` branch, the contents of the new branch would be copied from `2.5`, not `master`.
    * `git checkout -b CURRENT-VERSION-NUMBER`
    * `git push -u origin CURRENT-VERSION-NUMBER`

1. `cd` into the book repository for the pipeline you want to split.

1. Run `git pull`.

1. Check out a new branch called CURRENT-VERSION-NUMBER branch. For example, if the upcoming version of PAS for Windows (PASW) is v2.8, and the current version of PASW is v2.7, the branch should be 2.7.
    * `git checkout -b CURRENT-VERSION-NUMBER`
    * `git push -u origin CURRENT-VERSION-NUMBER`

1. Open the new branch's `config.yml`.
    1. Under `repository`, add a `ref` with the appropriate branch number for content repos to specify the current version. For example, `'2.7'`. Make sure the value for `ref` is contained in single quotes, or Concourse will not recognize it.
        * Current content will publish off of the latest version branch instead of `master`.
        * Content for the upcoming release will publish off `master`.
    1. Add a path for the current version at the end of `directory` and `url_prefix`.
    1. Update `latest_stable_version`, `local_product_version`, and `display_name` to the current version.

1. Commit and push your changes.

1. Check out the `master` branch.

1. Open `config.yml`.
    1. Under `layout_repo_ref: 'master'`, add `layout_repo_ref: 'edge'`.
    1. Under `repository`, add a `ref` to specify `'master'` as the branch from which the branch pulls. Make sure the value for `ref` is contained in single quotes, or Concourse will not recognize it.
    1. Add a path for the edge version at the end of `directory` and `url_prefix`.
    1. Update `latest_stable_version`, `local_product_version`, and `display_name` to the edge version.
    1. Add a new header with the edge versions to the `local_header_version_list` underneath the current header listed with the current version’s `url_prefix` and `display_name`.

1. Open `redirects.rb` and edit any redirects with version numbers to increment version numbers throughout. For example, increment 2-6 to 2-7 where it appears.

1. Open `config/template_variables.yml`. If the variables are present, change `current_major_version` and `v_major_version` to the edge version.

1. Open `master_middleman/source/subnavs/NAME-OF-SUBNAV.erb` and change the link titles in the subnav file that reference a version to the edge version.

1. Commit and push your changes. 


## Step Two: Build and Push Staging and Production Sites

1. Make sure you are on the `master` branch of the book repository.

1. Make sure you have the correct Bookbinder Ruby gem installed by running `gem install ./bookbindery-10.1.15.gem`.

1. Run `bundle exec bookbinder bind remote` to create a new app.

1. `cd` into the `final_app` directory.

1. Log in to PWS:
    * `cf api api.run.pivotal.io`
    * `cf login`

1. Make sure you are targeting the pivotalcf-staging space in the pivotal-pubtools org by running `cf target -o pivotal-pubtools -s pivotalcf-staging`.

1. Rename the current unversioned pipelines from `docs-PIPELINE-blue` and `docs-PIPELINE-green` to `docs-PIPELINE-CURRENT-VERSION-blue` and `docs-PIPELINE-CURRENT-VERSION-green`. For example:
    * `cf rename docs-windows-blue docs-windows-2-7-blue`
    * `cf rename docs-windows-green docs-windows-2-7-green`

1. Push a new versioned app twice, as `docs-PIPELINE-NEW-VERSION-NUMBER-blue` and `docs-PIPELINE-NEW-VERSION-NUMBER-green`. For example:
    * `cf push docs-windows-2-8-blue -i 3 -m 256M -k 1024M -s cflinuxfs3 -b null --no-route`
    * `cf push docs-windows-2-8-green -i 3 -m 256M -k 1024M -s cflinuxfs3 -b null --no-route`

1. Map each newly deployed app, blue and green, to the destination route.
    * `cf map-route docs-windows-2-8-blue cfapps.io --hostname docs-pcf-staging --path windows/2-8`
    * `cf map-route docs-windows-2-8-green cfapps.io --hostname docs-pcf-staging --path windows/2-8`

1. Run `cf target -s pivotalcf-prod` to move to the production space.

1. As above, rename the current unversioned pipelines from `docs-PIPELINE-blue` and `docs-PIPELINE-green` to `docs-PIPELINE-CURRENT-VERSION-blue` and `docs-PIPELINE-CURRENT-VERSION-green`. For example:
    * `cf rename docs-windows-blue docs-windows-2-7-blue`
    * `cf rename docs-windows-green docs-windows-2-7-green`

1. As above, push a new versioned blue and green app -- but this time, map routes to docs.pivotal.io rather than the staging URL.
    * `cf push docs-windows-2-8-blue -i 3 -m 256M -k 1024M -s cflinuxfs3 -b null --no-route`
    * `cf push docs-windows-2-8-green -i 3 -m 256M -k 1024M -s cflinuxfs3 -b null --no-route`
    * `cf map-route docs-windows-2-7-blue docs.pivotal.io --path windows/2-8`
    * `cf map-route docs-windows-2-7-green docs.pivotal.io --path windows/2-8`

1. Add basic auth to all staging apps. For more information, see [Add Basic Auth to a Documentation Set](https://docs-wiki.cfapps.io/wiki/pipelines/basic-auth.html).

1. Restage all staging apps by running `cf restage docs-PIPELINE-VERSION-blue` and `cf restage docs-PIPELINE-VERSION-green`.


## Step Three: Configure the Concourse Pipelines

1. Navigate to `concourse-scripts-docs/cf-current`.

1. Make a new subfolder. For example, `mkdir windows-2-8`.

1. Copy content from last version folder into new folder. For example, `cp -rf windows/* windows-2-8`.

1. Rename the last version’s folder to specify its version. For example, `mv windows windows-2-7`.

1. In `deployment-resources.yml`, add a new S3 bucket definition code chunk beneath the previous pipeline’s code chunk by copying and pasting it, then adding version numbers to both.
  	```
	- name: cf-current-PIPELINE-CURRENT-VERSION-s3
	  type: s3
	  source:
	    bucket: concourse-interim-steps
	    versioned_file: PIPELINE-CURRENT-VERSION-final_app.tar.gz
	    private: true
	    access_key_id: "{{aws-access-key}}"
	    secret_access_key: "{{aws-secret-key}}"
	- name: cf-current-PIPELINE-EDGE-VERSION-s3
	  type: s3
	  source:
	    bucket: concourse-interim-steps
	    versioned_file: PIPELINE-EDGE-VERSION-final_app.tar.gz
	    private: true
	    access_key_id: "{{aws-access-key}}"
	    secret_access_key: "{{aws-secret-key}}"
	```

1. Open the current version’s `config.yml`.
    1. Change `book_branch def` to `book_branch: 'CURRENT-VERSION'`.
    1. Add the current version number to the end of both `path`s.

1. Rename each subfolder to include the current version number. For example:
    * `mv windows-bind windows-2-7-bind`
    * `mv windows-staging windows-2-7-staging`
    * `mv windows-production windows-2-7-production`

1. In the `bind` subfolder, open `plan.yml`.
    * Change the branches specified in the book and content repo resources from `master` to the current version. For example, `docs-book-windows-master` becomes `docs-book-windows-2.7`, and `docs-pcf-windows-master` becomes `docs-pcf-windows-2.7`.
    * Add the current version number to `task`. For example, `windows-bind` becomes `windows-2-7-bind`.
    * Add the current version number to the subfolders listed in `file`. For example, `concourse-scripts/cf-current/windows/windows-bind/task.yml` becomes `concourse-scripts/cf-current/windows-2-7/windows-2-7-bind/task.yml`.
    * Under `in_parallel`, add the current version number to the S3 bucket defined in `put`. For example, `cf-current-windows-s3` becomes `cf-current-windows-2-7-s3`.

1. In the `staging` subfolder, open `plan.yml`.
    * Under `in_parallel`, add the current version number to both `passed`s and `resource`. For example, `windows-bind` becomes `windows-2-7-bind`, and `cf-current-windows-s3` becomes `cf-current-windows-2-7-s3`.
    * Under `params`, add the current version number to the path defined in `DEPLOY_DETAILS`. For example, `concourse-scripts/cf-current/windows/config.yml` becomes `concourse-scripts/cf-current/windows-2-7/config.yml`.

1. In the `production` subfolder, open `plan.yml`.
    * Under `in_parallel`, add the current version number to both `passed`s and the `resource` under `site-source`. For example, `windows-staging` becomes `windows-2-7-staging`, and `cf-current-windows-s3` becomes `cf-current-windows-2-7-s3`.
    * Under `params`, add the current version number to the path defined in `DEPLOY_DETAILS`. For example, `concourse-scripts/cf-current/windows/config.yml` becomes `concourse-scripts/cf-current/windows-2-7/config.yml`.

1. Change into the edge version's folder.

1. Repeat steps 2 through 5, but adding in the edge version number instead of the current version number.

1. Make sure the Gemfile and Gemfile.lock files in your local book repository list the Bookbinder version as `10.1.15`. This is the version required to build and push the apps, which is different from the version Bookbinder uses to build locally. You can stash these changes after updating Concourse.

1. Update Concourse changes with the fly CLI, using the following rake commands:
    1. `rake fly:login`
    1. `export BOOKBINDER_EDGE=true`
    1. `rake scheme:update_all[PIPELINE-GROUP]`
    1. `rake fly:set_pipeline[PIPELINE-GROUP]`

1. Commit and push your changes.

1. Go to Concourse and check the pipelines to make sure they are present and building properly. Once the staging site is green for each, click the + icon on each pipeline to ensure that the production sites are running.

**Note:** If you see the error `RuntimeError: Too many apps mapped to route! Apps: docs-pas-kubernetes-blue, docs-pas-kubernetes-green` in the staging build in Concourse, log in to Apps Manager and ensure that one of the apps is stopped.
