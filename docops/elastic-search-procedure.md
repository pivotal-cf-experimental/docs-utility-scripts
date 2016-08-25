
## Adding user created 'elastic.co' service to `pubtools` org spaces

1. Target the staging site: `cf target -o pivotal-pubtools -s pivotalcf-staging`

1. Create user-provided service: `cf create-user-provided-service 'elastic.co' -p 'sslUri, uri'`
This command will create a prompted response to supply the passphrases for both the 'sslUri' and 'uri' endpoints. The password added to the user created service in the console UI is a concatenation of the protocol, credentials for the `readwrite` user, and endpoint:
`http://readwrite:<readwrite password>@<url>`
`https://username:PASSWORD@23423423423423.us-east-1.aws.found.io:9243`
The credentials for these components are in LastPass `Shared-PubTools` folder under `Elastic Cloud Staging & Prod Cluster Users` and the endpoint is found in the Overview page of the Elastic.co account. The login for the Elastic.co service is in the `Shared-Pubtools` folder under `elastic.co` Lastpass entry. If you are binding to production use the `production` cluster details on the `elastic.co` website and if you are binding to staging, use the `staging` cluster details.

1. From the PWS UI, bind all staging sites to the service from console GUI: 
	1. "pcf services", blue & green
	1. "pivotalcf-staging", blue & green
	1. "pcf-services-pre-release", blue & green
	1. "pcf", blue & green
	1. "pws-pre-release", blue & green
	1. "pcf-1-6", blue & green
	1. "pcf-1-8", blue & green
	1. "pcf-1-9", blue & green


1. Starting with PCF Services in `pivotalcf-staging`, use concourse to kick off the deploy job for that book in order to index and switch to elastic.co. You must do PCF Services FIRST! 

1. Check the builds to make sure they bind to elastic.co, and not searchly, as viewed from the concourse staging "deploy" output, such as:
```
Binding service elastic.co to app docs-pcf-1-8-green in org pivotal-pubtools / space pivotalcf-staging as cfaccounts+cfdocs@pivotallabs.com...
OK
App docs-pcf-1-8-green is already bound to elastic.co.
```

Repeat the steps above for each space that requires `elastic.co` service, such as:

* pws-staging, blue & green (8/24)
* pws-prod (done 8/24)
* hdb-develop-staging
* hawq-131-staging
* apache-hawq-200-staging
