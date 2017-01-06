This README describes Rollback Release installation, use and management.

Installing RR:
To install Rollback Release, clone or pull the `docs-utility-scripts` repo and run this command in a shell, which adds an alias for `rr` to your bash profile that includes passing one environment variable to the program at runtime:

`sh $HOME/workspace/docs-utility-scripts/rollback_release/install/rollback_release.sh; source ~/.bash_profile`

Why Rollback Release?

There are many spaces, orgs and apps for which the docs teams are responsible. Keeping track of _all_ of them in your head is near impossible, and referring to Apps Man can be time consuming and does not offer `cf push`. The `cf` command line is an excellent tool to manage our production needs, but requires extensive knowledge of its flags and our deployment schema to successfully navigate delivering new docs or recovering from downtime.

There are two main functions of RR:
  1. To semi-automatically release new apps in a safe and consistent manner. To accomplish this goal, RR performs two distinct tasks. 
    1. You call `rr prime` to push an app to a non-production route and can then visually inspect it for accuracy. 
    2. You call `rr release` to start and scale your app, map it to a known, pre-defined route (production, staging, review), and stop the blue or green counterpart to that app (the old app).
  2. To roll back to older, functional apps (stale, but good, versions of our docs) to reduce production errors, stress and downtime. `rr ripcord` is the tool to safely accomplish this task. 

The `.rr_config` YAML file contains the details for each of our versioned products, including book, app_name, branch, space, org, hostname, domain, route_path. Our products include PCF-1-9, PCF-1-8, PCF-1-7, PCF-1-6, PCF-Review, PCF-Services, PCF-Services-Review, CF, CF-Review, PWS, and PWS-Review.

Using RR:

All of the `rr` commands prompt you for choices

You can also refer to `rr` help display for description about the three sub-commands to `rr`.