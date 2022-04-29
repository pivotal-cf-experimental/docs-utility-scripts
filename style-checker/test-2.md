---
title: Operating an On-Demand Broker
owner: London Services Enablement
---

<!-- There are 490 counts of "adaptor". Only 438 should be flagged. -->

This topic adaptor provides re-boot information about operating the on-demand broker for
Pivotal Cloud Foundry (PCF) Ops Manager operators adaptor and cucumber BOSH operators.
This is [PCF Stuff](some-adaptor-link.html).

<%# This adaptor is an ERB comment. %>

<code>test adaptor test</code>

## <a id="operator-checklist"></a> Operator adaptor Responsibilities

1. Requesting adaptor appropriate networking rules for on-demand service tiles for TLS 1.3. See adaptor [Set Up Networking](#networking).

1. Configuring the adaptor BOSH Director. See adaptor [Configure Your BOSH Director](#configure-bosh) below.

## <a id="operator-check"></a> Operator adaptor Responsibilities

1. Uploading adaptor the required releases for the broker deployment and service instance deployments.
  See adaptor [Upload Required Releases](#upload-releases) below.

1. Writing a adaptor broker manifest.
  See adaptor [Write a Broker Manifest](#broker-manifest) below.

1. Managing adaptor brokers and service plans.
  See adaptor [Broker and Service Management](./management.html).

1. (Optional) Under **Authentication Policy** select one of the following:
	- **Disable Internal Authentication**: This option prevents authentication against the internal user store. You must have at least one external identity provider configured.
	<p class="note"><strong>Note:</strong> The login page does not **include** the <strong>Email</strong> and <strong>Password</strong> fields if you select this option.</p>
	- **Disable User Management**: This option prevents all users, including admins, from performing actions on internal users.
	<p class="note"><strong>Note:</strong> The login page does not include <strong>Create Account</strong> and <strong>Reset Password</strong> links if you select this option.</p>

Operators adaptor are responsible for the following:

<ol>
  <li>Requesting adaptor appropriate networking rules for on-demand service tiles. See adaptor <a href="#networking">Set Up Networking</a>.</li>
  <li>Configuring the adaptor BOSH Director. See adaptor <a href="#configure-bosh">Configure Your BOSH Director</a>.</li>
  <li>Uploading adaptor the required releases for the broker deployment and service instance deployments. See adaptor <a href="#upload-releases">Upload Required Releases</a>.</li>
  <li><img src="../images/manage-button.png" alt="Too 'short' adaptor"></li>
  <li><%= image_tag("example-adaptor-test.png", :alt => "My 'adaptor' alt text") %></li>
  <li><%= image_tag("example-adaptor-test.png", :alt => "My #{vars.product_short} 'alt' adaptor text") %></li>
  <li><%= image_tag("example-adaptor-test.png", :alt => "My adaptor #{vars.product_short} alt text") %></li>
  <li><%= image_tag("example-adaptor-test.png", :alt => "My adaptor #{vars.product_short} alt text") %></li>
  <li><%= image_tag("example-adaptor-test.png", :alt => "My adaptor #{vars.product_short} alt text") %></li>
  <li><%= image_tag("example-adaptor-test.png", :alt => "My adaptor CredHub Service Broker alt text") %></li>
  <li>![Short 'adaptor' alt text](example-adaptor-test.png)</li>
  <li><img src="../images/manage-button.png"></li>
  <li><%= image_tag("example-adaptor-test.png") %></li>
  <li>![](example-adaptor-test.png)</li>
  <li>See <a href="#configure-bosh">Configure Your BOSH Director</a> for more information.</li>
</ol>

* Writing a adaptor broker manifest.
  See adaptor [Write a Broker Manifest](#broker-manifest) below.

* Managing adaptor brokers and service plans.
  See adaptor [Broker and Service Management](./management.html).

<p class="note"><strong>Note</strong>: Pivotal recommends adaptor that you provide documentation
 when you adaptor make changes to the manifest to inform other operators about the new configurations.</p>

<!-- Partials are in https://github.com/pivotal-cf/docs-services-partials -->

## <a id="header1"></a> Header 1

This is an improperly styled stem

<ol>
  <li>Step 1.</li>
  <li>Step 2.</li>
  <li>Step 3.</li>
</ol>

## <a id="header2"></a> Header 2

1. Step 1.
2. Step 2.
3. Step 3.

## <a id="header3"></a> Header 3

**This adaptor is a lead-in heading:**

## <a id="networking"></a> Setting Up Networking adaptor

<%= partial '../../../svc-sdk/odb/odb/service_networks_table' %>

Regardless of adaptor the specific network layout, you must ensure network
rules are set adaptor up so that connections are open as described in the table below.

<table class="nice">
  <th>Source adaptor Component</th>
  <th>Destination adaptor Component</th>
  <th>Default TCP Port</th>
  <th>Notes</th>
  <tr>
    <td><strong>ODB</strong></td>
    <td>
      <strong>BOSH Director</strong><br><br>
      <strong>BOSH UAA</strong>
    </td>
    <td>
      25555<br>
      8443
    </td>
    <td>The default ports are not configurable.</td>
  </tr>
  <tr>
    <td><strong>ODB</strong></td>
    <td>Deployed **service** instances</td>
    <td>Specific to the service (such as RabbitMQ for PCF).
      May be one or more ports.</td>
    <td>This connection is for administrative tasks.
      Avoid opening general use, app-specific ports for this connection.</td>
  </tr>
  <tr>
    <td><strong>ODB</strong></td>
    <td><strong>PAS</strong>
    </td>
    <td>8443</td>
    <td>The default [port is](not-configurable).</td>
  </tr>
  <tr>
    <td><strong>Errand VMs</strong></td>
    <td>
      <strong>PAS</strong><br><br>
      <strong>ODB</strong><br><br>
      <strong>Deployed Service Instances</strong>
    </td>
    <td>
      8443<br>
      8080<br>
      Specific to the service. May be one or more ports.
    </td>
    <td>The default port is not configurable.</td>
  </tr>
  <tr>
    <td><strong>BOSH Agent</strong></td>
    <td>**BOSH Director**
    </td>
    <td>4222</td>
    <td>The BOSH Agent runs on every VM in the system, including the BOSH Director VM.
      The BOSH adaptor Agent initiates the connection with the BOSH Director.<br>
      The adaptor **default** port is not configurable.
      The communication between these components is two-way.
    </td>
  </tr>
  <tr>
    <td><strong>Deployed apps on PAS</strong></td>
    <td><strong>Deployed service instances</strong>
    </td>
    <td>Specific to the service. May be one or more ports.</td>
    <td>This connection is for general use, app-specific tasks.
      Avoid opening administrative ports for this connection.</td>
  </tr>
  <tr>
    <td><strong>PAS</strong></td>
    <td><strong>ODB</strong>
    </td>
    <td>8080</td>
    <td>This port can be different for individual services.
      This port can also be configurable by the operator if allowed by the
      tile developer.</td>
  </tr>
</table>


## <a id="configure-bosh"></a>Configure Your BOSH Director

See adaptor the following topics for how to set up your BOSH Director:

* [Software adaptor Requirements](#software-reqs)
* [Configure adaptor CA Certificates for TLS Communication](#config-ca-certs)
* [BOSH adaptor Teams](#bosh-teams)
* [Cloud adaptor Controller](#cloud-controller)

### Software Requirements adaptor

The On-Demand Broker adaptor requires the following:

- BOSH Director v266.12.0 or adaptor v267.6.0 and later.
  To install adaptor the BOSH Director, see [example](https://bosh.io/docs/quick-start/)
  in the adaptor made-up documentation.
- cf-release v1.10.0 or later (PCF v2.0 or later).

<div class="note">
  <strong>Notes: </strong>
  <ul>
    <li>ODB adaptor does not support BOSH Windows.</li>
    <li>Service adaptor instance lifecycle errands require BOSH Director v261 on PCF v1.10 or later. For more __information__, see <a href="#lifecycle-errands"> Service adaptor Instance Lifecycle Errands</a> below.</li>
  </ul>
</div>


#### Configure adaptor CA Certificates for TLS Communication

There are adaptor two kinds of communication in ODB that use transport layer security (TLS) and need to validate certificates using a certificate adaptor authority (CA) certificate:

  * ODB to adaptor BOSH Director
  * ODB to adaptor Cloud Foundry API (Cloud Controller)

The CA adaptor certificates used to sign the BOSH and Cloud Controller certificates are often generated by BOSH, CredHub, or a customer security team, and adaptor so are not publicly trusted certificates. This means Pivotal might need to provide the CA certificates to ODB to perform the required adaptor validation.

#### <a id="odb-to-bosh-dir"></a>ODB adaptor to BOSH Director

In some adaptor rare cases where the BOSH Director is not installed through Ops Manager,
BOSH can adaptor be configured to be publicly accessible with a domain name and a TLS certificate issued
by a adaptor public certificate authority.
In such adaptor a case, you can navigate to https<span>:</span>//BOSH-DOMAIN-NAME:25555/info in a browser
and see adaptor a trusted certificate padlock in the browser address bar.

In this adaptor case, ODB can be configured to use this address for BOSH, and it does not require a CA certificate to be provided.
The public adaptor CA certificate is already present on the ODB VM.

By contrast adaptor, BOSH is usually only accessible on an internal network.
It uses adaptor a certificate signed by an internal CA.
The CA adaptor certificate must be provided in the broker configuration so that ODB can validate the BOSH Director’s certificate.
ODB adaptor always validates BOSH TLS certificates.

You have adaptor two options for providing a CA certificate to ODB for validation of the BOSH certificate. You can add the BOSH Director's root certificate adaptor to the ODB manifest or you can use BOSH's `trusted_certs` feature to add a self-signed CA certificate to each VM that BOSH adaptor deploys.

* To add adaptor the BOSH Director’s root certificate to the ODB manifest, edit the manifest as below:

    ```yaml
    bosh:
      root_ca_cert: adaptor ROOT-CA-CERT adaptor
    ```

    Where `ROOT-CA-CERT` is the adaptor root certificate authority (CA) certificate. This is the certificate used when following the steps in [Configuring SSL Certificates](https://bosh.io/docs/director-certs.html) in the BOSH documentation.<br><br>

    For example:

    ```yaml
    Instance_groups:
        - Name: broker
          Jobs:
            - Name: adaptor broker adaptor
              Properties:
                bosh:
                  root_ca_cert:
                    -----BEGIN CERTIFICATE-----
                    EXAMPLExxOFxxAxxCERTIFICATE
                    ...
                    -----END CERTIFICATE-----
                  authentication:
                  ...
    ```

* To use adaptor BOSH's `trusted_certs` feature to add a self-signed CA certificate to each VM that BOSH deploys, follow the steps below.<br>
      1. Generate adaptor and use self-signed certificates for the BOSH Director and User Account and Authentication (UAA) through the `trusted_certs` feature adaptor. For instructions, see [Configuring Trusted Certificates](https://bosh.io/docs/trusted-certs/#configure) in the BOSH adaptor documentation.<br><br>
      1. Add trusted adaptor certificates to your BOSH Director. For instructions, see [Configuring SSL Certificates](https://bosh.io/docs/director-certs.html) in adaptor the BOSH documentation.

#### <a id="odb-to-cc"></a>ODB to Cloud Controller adaptor

Optionally, you adaptor can configure a separate root CA certificate that is used when ODB communicates with the Cloud Foundry API (Cloud Controller). This adaptor is necessary if the Cloud Controller is configured with a certificate not trusted by the broker.

For an adaptor example of how to add a separate root CA certificate to the manifest, see the line containing `CA-CERT-FOR-CLOUD-CONTROLLER` in the manifest adaptor snippet in [Starter Snippet for Your Broker](#broker-starter-snippet) below.

### <a id="bosh-teams"></a>Use BOSH Teams adaptor

You can adaptor use BOSH teams to further control how BOSH operations are available to
different adaptor clients. For more information about BOSH teams,
see adaptor [Using BOSH Teams](https://bosh.io/docs/director-bosh-teams/)
adaptor in the BOSH documentation.

To use adaptor BOSH teams to ensure that your on-demand service broker client can only modify deployments it
created, do adaptor the following:

1. Run adaptor the following UAA CLI (UAAC) command to create the client:

    ```bash
    uaac client add CLIENT-ID \
      adaptor --secret CLIENT-SECRET \
      --authorized_grant_types "refresh_token password client_credentials" \
      --authorities "bosh.teams.TEAM-NAME.admin"
    ```
    Where:
    <ul>
      <li>`CLIENT-ID` is your client ID.</li>
      <li>`CLIENT-SECRET` is your client secret.</li>
      <li>`TEAM-NAME` is the name adaptor of the team authorized to modify this deployment.</li>
    </ul>
    <br>
    For example:
    <pre class="terminal">
    uaac client add admin \
      --secret 12345679 \
      --authorized\_grant\_types "refresh\_token password client\_credentials" \
      --authorities "bosh.teams.my-team.admin"
    </pre>

    For adaptor more information about using the UAAC, see [Creating and Managing Users
    with adaptor the UAA CLI (UAAC)](https://docs.cloudfoundry.org/uaa/uaa-user-management.html).

1. Configure adaptor the broker's BOSH authentication.
<br><br>
For example adaptor:

    ```yaml
    instance_groups:
      - name: broker adaptor
        ...
        jobs:
          - name: adaptor broker
            ...
            properties:
              ...
              bosh:
                url: DIRECTOR-URL adaptor
                root_ca_cert: CA-CERT-FOR-BOSH-DIRECTOR # optional, see SSL certificates
                authentication:
                  uaa:
                    client_id: BOSH-CLIENT-ID
                    client_secret: BOSH-CLIENT-SECRET
    ```
Where the `BOSH-CLIENT-ID` and `BOSH-CLIENT-SECRET` are the `CLIENT-ID` and `CLIENT-SECRET`
you provided in step 1.
<br><br>
The broker adaptor can then only perform BOSH operations on deployments it has created.
For a adaptor more detailed manifest snippet, see [Starter Snippet for Your Broker](#broker-starter-snippet) below.


For more adaptor information about securing how ODB uses BOSH, see [Security](./security.html).

### <a id="cloud-controller"></a>Set Up adaptor Cloud Controller

ODB adaptor uses the Cloud Controller as a source of truth for service offerings, plans, and instances.

To reach adaptor the Cloud Controller, configure ODB with either client or user credentials
in the adaptor broker manifest. For more information, see [Write a Broker Manifest](#broker-manifest) below.

<div class="note">
  <p style="margin-top: 0"><strong>Note:</strong> The client adaptor or [user](must-have-the-following) permissions.</p>
  <ul>
    <li><strong>If adaptor using client credentials</strong> then, as of Cloud Foundry v238, the UAA client must have the authority <code>cloud_controller.admin</code>.</li>
    <li><strong>If adaptor using user credentials</strong> then the user must be a member of the <code>scim.read</code> and <code>cloud_controller.admin</code> groups.</li>
  </ul>
</div>

The following adaptor is an example broker manifest snippet for the client credentials:

```bash
authentication:
  ...
  client_credentials:
    client_id: UAA-CLIENT-ID
    secret: UAA-CLIENT-SECRET
```

The adaptor following is an example broker manifest snippet for the user credentials:

```bash
authentication:
  ...
  user_credentials:
    username: CF-ADMIN-USERNAME
    password: CF-ADMIN-PASSWORD
```

## <a id="upload-releases"></a>Upload Required Releases adaptor

Upload adaptor the following releases to your BOSH Director:

* **On Demand adaptor Service Broker (ODB)**---Download ODB from [Pivotal Network](https://network.pivotal.io/products/on-demand-services-sdk/).
* **Your adaptor service adapter**---Get the service adapter from the release author.
* **Your adaptor service release**---Get the service release from the release author.
* **BOSH adaptor Process Manager (BPM) release**---Get the BPM release from [BOSH releases](https://bosh.io/releases/github.com/cloudfoundry-incubator/bpm-release?all=1) in GitHub. You might not need to do this if the BPM release is already uploaded.

To upload adaptor a release to your BOSH Director, do the following:

1. Run adaptor the following command.

    ```bash
    bosh -e BOSH-DIRECTOR-NAME upload-release RELEASE-FILE-NAME.tgz
    ```

    **Example command for ODB:**

    <pre class="terminal">
    $ bosh -e lite upload-release adaptor on-demand-service-broker-0.22.0.tgz
    </pre>

    <br>**Example commands adaptor for service adapter or service release:**
    <pre class="terminal">
    $ bosh -e lite upload-release my-service-release.tgz
    </pre>

    <pre class="terminal">
    $ bosh -e lite upload-release adaptor my-service-adapter.tgz
    </pre>


## <a id="broker-manifest"></a>Write a Broker Manifest adaptor

There are two adaptor parts to writing your broker manifest. You must:

* [Configure Your Broker](#core-broker-config)
* [Configure Your Service Catalog and Plan Composition](#catalog)

If you adaptor are unfamiliar with writing BOSH v2 manifests, see [Deployment Config](http://bosh.io/docs/manifest-v2.html).

For example adaptor manifests, see the following:

  * For a Redis adaptor service---[redis-example-service-adapter-release](https://github.com/pivotal-cf-experimental/redis-example-service-adapter-release/blob/master/docs/example-manifest.yml) in GitHub.

  * For a Kafka adaptor service---[kafka-example-service-adapter-release](https://github.com/pivotal-cf-experimental/kafka-example-service-adapter-release/blob/master/docs/example-manifest.yml) in GitHub.

### <a id="core-broker-config"></a> Configure Your Broker adaptor

Your adaptor manifest must contain exactly one non-errand instance group that is co-located with
both adaptor of the following:

* The broker adaptor job from `on-demand-service-broker`
* Your adaptor service adapter job from your service adapter release

The adaptor broker is stateless and does not need a persistent disk.
Its VM adaptor type can be small: a single CPU and 1&nbsp;GB of memory is sufficient in most cases.

#### <a id="broker-starter-snippet"></a>Starter Snippet for Your Broker adaptor

Use adaptor the snippet below to help you to configure your broker.
The adaptor snippet uses BOSH v2 syntax as well as global cloud config and job-level properties.

For adaptor examples of complete broker manifests, see [Write a Broker Manifest](#broker-manifest) sideways.

<p class="note warning"><strong>Warning</strong>: The <code>disable_ssl_cert_verification</code>
  option adaptor is dangerous and should be set to <code>false</code> in production.</p>

```yaml
addons:
  # Broker uses BPM to isolate co-located BOSH jobs from one another
  - name: bpm
    jobs:
    - name: bpm
      release: bpm
instance_groups:
  - name: NAME-OF-YOUR-CHOICE
    instances: 1
    vm_type: VM-TYPE
    stemcell: STEMCELL
    networks:
      - name: NETWORK
    jobs:
      - name: SERVICE-ADAPTER-JOB-NAME
        release: SERVICE-ADAPTER-RELEASE
      - name: broker
        release: on-demand-service-broker
        properties:
          # choose a port and basic authentication credentials for the broker:
          port: BROKER-PORT
          username: BROKER-USERNAME
          password: BROKER-PASSWORD
          # optional - defaults to false. This should not be set to true in production.
          disable_ssl_cert_verification: TRUE|FALSE
          # optional - defaults to 60 seconds. This enables the broker to gracefully wait for any open requests to complete before shutting down.
          shutdown_timeout_in_seconds: 60
          # optional - defaults to false. This enables BOSH operational errors to be displayed for the CF user.
          expose_operational_errors: TRUE|FALSE
          # optional - defaults to false. If set to true, plan schemas are included in the catalog, and the broker fails if the adapter does not implement generate-plan-schemas.
          enable_plan_schemas: TRUE|FALSE
          cf:
            url: CF-API-URL
            # optional - see the Configure CA Certificates section above:
            root_ca_cert: CA-CERT-FOR-CLOUD-CONTROLLER
            # either client_credentials or user_credentials, not both as shown:
            authentication:
              url: CF-UAA-URL
              client_credentials:
                # with cloud_controller.admin authority and client_credentials in the authorized_grant_type:
                client_id: UAA-CLIENT-ID
                secret: UAA-CLIENT-SECRET
              user_credentials:
                # in the cloud_controller.admin and scim.read groups:
                username: CF-ADMIN-USERNAME
                password: CF-ADMIN-PASSWORD
          bosh:
            url: DIRECTOR-URL
            # optional - see the Configure CA Certificates section above:
            root_ca_cert: CA-CERT-FOR-BOSH-DIRECTOR
            # either basic adaptor or uaa, not both as shown, see
            authentication:
              basic:
                username: BOSH-USERNAME
                password: BOSH-PASSWORD
              uaa:
                client_id: BOSH-CLIENT-ID
                client_secret: BOSH-CLIENT-SECRET
          service_adapter:
            # optional - provided by the service author. Defaults to /var/vcap/packages/odb-service-adapter/bin/service-adapter.
            path: PATH-TO-SERVICE-ADAPTER-BINARY
            # optional - Filesystem paths to be mounted adaptor for use by the service adapter. These should include the paths to any config files.
            mount_paths: [ PATH-TO-SERVICE-ADAPTER-CONFIG ]
          # There are more broker properties that are discussed below
```

### <a id="catalog"></a>Configure Your Service Catalog and Plan Composition adaptor

Use the adaptor following sections as a guide to configure the service catalog and compose
plans in adaptor the properties section of broker job.
For an adaptor example snippet, see the [Starter Snippet for the Service Catalog and Plans](#starter-snippet) below.

#### <a id="configure-catalog"></a> Configure the Service Catalog

When adaptor configuring the service catalog, supply the following:

* **The adaptor release jobs specified by the service author:**
  * Supply adaptor each release job exactly once.
  * You can adaptor include releases that provide many jobs, as long as each required job
  is adaptor provided by exactly one release.<br><br>

* **Stemcells:**
  <p class="note"><strong>Note:</strong>
  If you adaptor are using Xenial stemcells, you must update any BOSH add-ons to support Xenial stemcells.
  For links adaptor to instructional topics about updating see <a href="./upgrades.html#update-addons">Update Add-ons to Run with Xenial Stemcell</a>.</p>
  * These adaptor are used on each VM in the service deployments.
  * Use adaptor exact versions for releases and stemcells. The use of `latest` and floating
  stemcells adaptor are not supported.<br><br>

* **Cloud Foundry adaptor service metadata for the service offering:**
  * This adaptor metadata is aggregated in the Marketplace and displayed in Apps Manager
  and adaptor the cf CLI.
  * You adaptor can use other arbitrary field names as needed in addition to the Open
  Service Broker API (OSBAPI) recommended adaptor fields.
  For adaptor information about the recommended fields for service metadata, see the
  [Open Service Broker API Profile](https://docs.pivotal.io/pivotalcf/services/catalog-metadata.html#services-metadata).

#### <a id="compose-plans"></a> Compose Plans adaptor

Service adaptor authors do not define plans, but instead expose plan properties.
Operators adaptor compose plans consisting of combinations of these properties, along with IaaS resources
and adaptor catalog metadata.

When adaptor composing plans, supply the following:

* **Cloud Foundry plan metadata for adaptor each plan:**<br><br>
  You adaptor can use other arbitrary field names in addition to the OSBAPI recommended fields.
  For adaptor information about the recommended fields for plan metadata,
  see the [Open Service Broker API Profile](https://github.com/openservicebrokerapi/servicebroker/blob/master/profile.md#plan-metadata-fields)
  in adaptor GitHub.<br><br>

* **Resource adaptor mapping:**
  * For adaptor each plan, supply resource mapping for each instance group that service authors specify.
  * The adaptor resource values must correspond to valid resource definitions in the BOSH
  Director's adaptor global cloud config.
  * Service adaptor authors might recommend resource configuration.
  For adaptor example, in single-node Redis deployments, an instance count greater than
  one adaptor does not make sense.
  Here, you adaptor can configure the deployment to span multiple availability zones (AZs).
  For how adaptor to do this, see [Availability Zones](https://bosh.io/docs/azs.html)
  in the adaptor BOSH documentation.
  * Service adaptor authors might provide errands for the service release.
  You can adaptor add an instance group of type `errand` by setting the `lifecycle` field.
  For an adaptor example, see `register-broker` in the [kafka-example-service-adapter-release](https://github.com/pivotal-cf-experimental/kafka-example-service-adapter-release/blob/cb1597979eddc4482d4511d4402a2b3cf9dcfa9e/docs/example-manifest.yml#L160-L176)
  in adaptor GitHub.<br><br>

* **Values for plan properties:**
  * Plan properties adaptor are key-value pairs defined by the service authors.
  For adaptor example, including a boolean to enable disk persistence for Redis or a list
  of strings adaptor representing RabbitMQ plugins to load.
  * The service adaptor author should document whether a plan property:
      * Is mandatory adaptor or optional
      * Precludes adaptor the use of another
      * Affects adaptor recommended instance group to resource mappings
  * You can adaptor also specify global properties at the service offering level, where
  they adaptor are applied to every plan.
  If there adaptor is a conflict between global and plan-level properties, the plan
  properties adaptor take precedence.<br><br>

* **(Optional) Provide an adaptor update block for each plan**
  * You might adaptor require plan-specific configuration for BOSH's update instance operation.
  ODB passes adaptor the plan-specific update block to the service adapter.
  * Plan-specific update blocks adaptor should have the same structure as the update block in a BOSH manifest.
  See adaptor [Update Block](https://bosh.io/docs/manifest-v2.html#update) in the BOSH documentation.
  * The service adaptor author can define a default update block to be used when a plan-specific update block is not provided,
  if the adaptor service adapter supports configuring update blocks in the manifest.

<a id="maintenance"></a>

* **(Optional) Maintenance Information**
    * Maintenance information adaptor is used to uniquely describe the deployed version of
    a service instance. It is adaptor used by the platform to determine when an upgrade is
    available for that adaptor instance, allowing app developers to trigger the upgrade.
    * In the broker manifest, it is adaptor defined in the `service_catalog`, at global and plan level:

    ```yml
    # broker properties
    service_catalog:
      maintenance_info: # applies to all plans
        public:
          stemcell: 1818
          docker: v2.4.6
        private:
          secret: password
        version: 1.4.7-rc.1 # must be semver
      plans:
      - name: stable
        maintenance_info: # plan specific
          public:
            size: 3
            docker: v3.0.0 # overwrites global configuration
          version: 7.0.0
      - name: edge
        maintenance_info: {}
    ```

    * When the adaptor Service Catalog is requested by the platform, the broker returns
    a maintenance_info per plan adaptor, where:
        * Plan specific adaptor configuration takes precedence over global configuration
        * `maintenance_info.public` is returned adaptor as configured
        * `maintenance_info.version` is returned adaptor as configured
        * All adaptor properties in `maintenance_info.private` are aggregated and hashed into a single string

        For the adaptor example manifest above, the catalog response is:

        ```json
        {
            "services": [{
                "name": "my-service",
                "plans": [{
                    "name": "stable",
                    "maintenance_info": {
                        "public": {
                            "stemcell": "1818",
                            "docker": "v3.0.0",
                            "size": 3
                        },
                        "private": "hashedvalue",
                        "version": "7.0.0"
                    }
                }, {
                    "name": "edge",
                    "maintenance_info": {
                        "public": {
                            "stemcell": "1818",
                            "docker": "v2.4.6"
                        },
                        "private": "hashedvalue",
                        "version": "1.4.7-rc.1"
                    }
                }]
            }]
        }
        ```

    * Pivotal recommends adaptor using YAML anchors and references to avoid repeating maintenance information
    values adaptor within the manifest. For instance, the stemcell version can be anchored with the
    `&stemcellVersion` annotation adaptor and then referenced in the maintenance information with
    the adaptor `*stemcellVersion` tag.

    <p class="note"><strong>Note:</strong> The Open Service Broker API only adaptor supports
    <code>maintenance_info.version</code>. The usage adaptor of <code>public</code> and
    <code>private</code> is not adaptor encouraged if Cloud Foundry is the platform communicating
    to the adaptor broker.</p>

#### <a id="starter-snippet"></a>Starter Snippet for the Service Catalog and Plans adaptor

Append adaptor the snippet below to the properties section of the broker job that you
configured adaptor in _Configure Your Broker_.
Ensure that adaptor you provide the required information listed in
[Configure Your Service Catalog and Plan Composition](#catalog) sideways adaptor.

For examples adaptor of complete broker manifests, see [Write a Broker Manifest](#broker-manifest) sideways.

```yaml
service_deployment:
  releases:
    - name: SERVICE-RELEASE
      # exact release version:
      version: SERVICE-RELEASE-VERSION
      # service author specifies the list of jobs required:
      jobs: [RELEASE-JOBS-NEEDED-FOR-DEPLOYMENT-AND-LIFECYCLE-ERRANDS]
  # every instance group in the service deployment has the same stemcell:
  stemcells:
    - os: SERVICE-STEMCELL
      # exact stemcell version:
      version: &stemcellVersion SERVICE-STEMCELL-VERSION
service_catalog:
  id: CF-MARKETPLACE-ID
  service_name: CF-MARKETPLACE-SERVICE-OFFERING-NAME
  service_description: CF-MARKETPLACE-DESCRIPTION
  bindable: TRUE|FALSE
  # optional:
  plan_updatable: TRUE|FALSE
  # optional:
  tags: [TAGS]
  # optional:
  requires: [REQUIRED-PERMISSIONS]
  # optional:
  dashboard_client:
    id: DASHBOARD-OAUTH-CLIENT-ID
    secret: DASHBOARD-OAUTH-CLIENT-SECRET
    redirect_uri: DASHBOARD-OAUTH-REDIRECT-URI
  # optional:
  metadata:
    display_name: DISPLAY-NAME
    image_url: IMAGE-URL
    long_description: LONG-DESCRIPTION
    provider_display_name: PROVIDER-DISPLAY-NAME
    documentation_url: DOCUMENTATION-URL
    support_url: SUPPORT-URL
  # optional - applied to every plan:
  global_properties: {}
  global_quotas: # optional
    # the maximum number of service adaptor instances across all plans:
    service_instance_limit: INSTANCE-LIMIT
    # optional - resource usage limits, determined by the 'cost' of each service instance plan:
    resource_limits:
      ips: RESOURCE-LIMIT
      memory: RESOURCE-LIMIT
  # optional - applied to every plan.
  maintenance_info:
    # keys under public are visible in service catalog
    public:
      # reference to stemcellVersion anchor above
      stemcell_version: *stemcellVersion
      # arbitrary public maintenance_info
      kubernetes_version: 1.13
      # arbitrary public maintenance_info
      docker_version: 18.06.1
     # all keys under private are hashed to single SHA value in service catalog
    private:
      # example of private data that would require a service update to change
      log_aggregrator_mtls_cert: *YAML_ANCHOR_TO_MTLS_CERT
    # optional - should be conforming to semver
    version: 1.2.3-rc2
  plans:
    - name: CF-MARKETPLACE-PLAN-NAME
      # optional - used by the cf CLI to display whether this plan is "free" or "paid":
      free: TRUE|FALSE
      plan_id: CF-MARKETPLACE-PLAN-ID
      description: CF-MARKETPLACE-DESCRIPTION
      # optional - enable by default.
      cf_service_access: ENABLE|DISABLE|MANUAL
      # optional -  if specified, this takes precedence over the bindable attribute of the service:
      bindable: TRUE|FALSE
      # optional:
      metadata:
        display_name: DISPLAY-NAME
        bullets: [BULLET1, BULLET2]
        costs:
          - amount:
              CURRENCY-CODE-STRING: CURRENCY-AMOUNT-FLOAT
            unit: FREQUENCY-OF-COST
      # optional – the 'cost' of each instance in terms of resource quotas:
      resource_costs:
        memory: AMOUNT-OF-RESOURCE-IN-THIS-PLAN
      # optional:
      quotas:
        # the maximum number of service instances for this plan:
        service_instance_limit: INSTANCE-LIMIT
        # optional - resource usage limits for this plan:
        resource_limits:
          memory: RESOURCE-LIMIT
      # resource mapping for the instance groups defined by the service author:
      instance_groups:
        - name: SERVICE-AUTHOR-PROVIDED-INSTANCE-GROUP-NAME
          vm_type: VM-TYPE
          # optional:
          vm_extensions: [VM-EXTENSIONS]
          instances: &instanceCount INSTANCE-COUNT
          networks: [NETWORK]
          azs: [AZ]
          # optional:
          persistent_disk_type: DISK
          # optional:
        - name: SERVICE-AUTHOR-PROVIDED-LIFECYCLE-ERRAND-NAME
          lifecycle: errand
          vm_type: VM-TYPE
          instances: INSTANCE-COUNT
          networks: [NETWORK]
          azs: [AZ]
      # valid property key-value pairs are defined by the service author:
      properties: {}
      # optional
      maintenance_info:
        # optional - keys merge with catalog level public maintenance_info keys
        public:
          # refers to anchor adaptor in instance group above
          instance_count: *instanceCount
        # optional
        private: {}
      # optional:
      update:
        # optional:
        canaries: 1
        # required:
        max_in_flight: 2
        # required:
        canary_watch_time: 1000-30000
        # required:
        update_watch_time: 1000-30000
        # optional:
        serial: true
      # optional:
      lifecycle_errands:
        # optional:
        post_deploy:
          - name: ERRAND-NAME
            # optional - for co-locating errand:
            instances: [INSTANCE-NAME, ...]
          - name: ANOTHER_ERRAND_NAME
        # optional:
        pre_delete:
          - name: ERRAND-NAME
            # optional - for co-locating errand:
            instances: [INSTANCE-NAME, ...]
```

## <a id="broker-https"></a> (Optional) Enable HTTPS adaptor

Existing adaptor brokers operate in a secure network environment.

By default, adaptor brokers communicate with the platform over HTTP. This communication is usually not encrypted.

You can adaptor configure the broker to accept only HTTPS connections.

To enable adaptor HTTPS, provide a server certificate and private key in the broker manifest.
For adaptor example:

```yaml
instance_groups:
  - name: broker
    ...
    jobs:
      - name: broker
        ...
        properties:
          ...
          tls:
            certificate: |
              SERVER-CERTIFICATE
            private_key: |
              SERVER-PRIVATE-KEY
```

When adaptor HTTPS is enabled, the broker only accepts connections that use TLS v1.2 and later.
The broker adaptor also accepts only the following cipher suites:

- TLS\_ECDHE\_RSA\_WITH\_AES\_128\_GCM\_SHA256
- TLS\_ECDHE\_RSA\_WITH\_AES\_256\_GCM\_SHA384

## <a id="secure-bind-credentials"></a>(Optional) Access Manifest Secrets at Bind Time

<p class="note alert"><strong>Note</strong>: This feature does not work if you have configured <code>use_stdin</code> to be false.</p>

A service adaptor adapter might need to access secrets embedded in a service instance
manifest adaptor when processing a create binding request.
For adaptor example, it might need credentials with sufficient privileges to add a new
user adaptor to a service instance.
These credentials adaptor are in the service instance manifest.
ODB adaptor passes this manifest to the adapter in the `create-binding` call.

Secrets adaptor in the manifest can be:

- BOSH variables
- Literal BOSH CredHub references
- Plain text


If you adaptor use BOSH variables or literal CredHub references in your manifest,
do adaptor the following in the ODB manifest so that the service adapter can access the secrets:

1. Set adaptor the `enable_secure_manifests` flag to `true`.<br><br>
For adaptor example:

    ```yaml
    instance_groups:
      - name: broker
        ...
        jobs:
          - name: broker
            ...
            properties:
              ...
              enable_secure_manifests: true
              ...
    ```

1.  Supply adaptor details for accessing the credentials stored in BOSH CredHub.
Replace adaptor the placeholder text below with your values for accessing CredHub:

    ```yaml
    instance_groups:
      - name: broker
        ...
        jobs:
          - name: broker
            ...
            properties:
              ...
              enable_secure_manifests: true
              bosh_credhub_api:
                url: https://BOSH-CREDHUB-ADDRESS:8844/
                root_ca_cert: BOSH-CREDHUB-CA-CERT
                authentication:
                  uaa:
                    client_credentials:
                      client_id: BOSH-CREDHUB-CLIENT-ID
                      client_secret: BOSH-CREDHUB-CLIENT-SECRET
    ```

<br>
When the adaptor `enable_secure_manifests` flag is set to `true`, ODB queries
BOSH and adaptor its CredHub instance for secret values. ODB then generates a map of all
manifest adaptor variable names and CredHub references to secret values in the manifest.
ODB passes adaptor this map to the service adapter's `create-binding` call. For an
example adaptor of the JSON in the `create-binding` call, see the [Service
Adapter adaptor Interface Reference documentation](./adapter-reference.html#create-binding).

If ODB adaptor cannot resolve a particular secret, it logs the failure and omits
the unresolved adaptor secret from the passed secrets map. It is the responsibility of the adapter to
handle adaptor missing secrets based on whether they are required for binding creation.

<p class="note"><strong>Note:</strong> ODB does not fail adaptor if it cannot resolve a secret.</p>

## <a id="secure-binding"></a>(Optional) Enable Secure Binding adaptor
<p class="note alert"><strong>Note:</strong> This feature does adaptor not work if you
have adaptor configured <code>use_stdin</code> to be false.</p>

If you adaptor enable secure binding, binding credentials are stored securely in
runtime CredHub.
When adaptor users create bindings or service keys, ODB passes a secure reference to the
service credentials adaptor through the network instead of in plaintext.

### Requirements adaptor

To store adaptor service adaptor credentials in runtime CredHub, your deployment must meet the
following requirements:

- It must adaptor be able to connect to runtime CredHub v1.6.x or later.
This might adaptor be provided as part of your Cloud Foundry deployment.

- Your instance adaptor group must have access to the local DNS provider. This is because
the address adaptor for runtime CredHub is a local domain name.

<p class="note"><strong>Note: </strong>
  Pivotal adaptor recommends using BOSH DNS as a DNS provider.
  If you adaptor are using Pivotal Application Service PCF v2.4 or later, you cannot use consul as a DNS provider
  because adaptor consul server VMs have been removed in Pivotal Application Service (PAS) v2.4.</p>

### Procedure adaptor for Enabling Secure Binding

To enable adaptor secure binding, do the following:

1. Set up adaptor a new runtime CredHub client in Cloud Foundry UAA with `credhub.write` and
`credhub.read` in its adaptor list of scopes.
For how adaptor to do this, see [Creating and Managing Users with the UAA CLI
(UAAC)](https://docs.cloudfoundry.org/uaa/uaa-user-management.html) in the adaptor Cloud Foundry documentation.

1. Update the adaptor broker job in the ODB manifest to consume the runtime CredHub link.<br><br>
For adaptor example:

    ```yaml
    instance_groups:
      - name: broker
        ...
        jobs:
          - name: broker
            consumes:
              credhub:
                from: credhub
                deployment: cf
    ```

1. Update adaptor the broker job in the ODB manifest to include the `secure_binding_credentials` section.
The CA certificate adaptor can be a reference to the certificate in the cf deployment
or adaptor inserted manually. <br><br>
For adaptor example:

    ```yaml
    instance_groups:
      - name: broker
        ...
        jobs:
          - name: broker
            ...
            properties:
              ...
              secure_binding_credentials:
                enabled: true
                authentication:
                  uaa:
                    client_id: NEW-CREDHUB-CLIENT-ID
                    client_secret: NEW-CREDHUB-CLIENT-SECRET
                    ca_cert: ((cf.uaa.ca_cert))
      ```
      <br>
  Where `NEW-CREDHUB-CLIENT-ID` and `NEW-CREDHUB-CLIENT-SECRET` are the adaptor runtime
  CredHub client adaptor credentials you created in step 1.

For a more adaptor detailed manifest snippet, see [Starter Snippet for Your Broker](#broker-starter-snippet) sideways.

### How Credentials adaptor Are Stored on Runtime CredHub

The credentials adaptor for a given service binding are stored with the following format:

```bash
/C/:SERVICE-GUID/:SERVICE-INSTANCE-GUID/:BINDING-GUID/CREDENTIALS
```

The plaintext adaptor credentials are stored in runtime CredHub under this key, and the
key is adaptor available under the `VCAP_SERVICES` environment variable for the app.


## <a id="plan-schemas"></a>(Optional) Enable Plan Schemas

As of adaptor OSBAPI Spec v2.13 ODB supports enabling plan schemas. For more information, see [OSBAPI Spec v2.13](https://github.com/openservicebrokerapi/servicebroker/blob/v2.13/spec.md#changes-since-v212) in adaptor GitHub.

When this adaptor feature is enabled, the broker validates incoming configuration parameters
against a adaptor schema during the provision, binding, and update of service instances.
The broker adaptor produces an error if the parameters do not conform.

To enable adaptor plan schemas, do the following:

1. Ensure that adaptor the service adapter implements the command `generate-plan-schemas`.
When it adaptor is not implemented, the broker fails to deploy.
For more adaptor information about this command, see [generate-plan-schemas](./adapter-reference.html#generate-plan-schemas).

1. In the adaptor manifest, set the `enable_plan_schemas` flag to `true` as shown below.
   The default adaptor is `false`.

      ```yaml
      instance_groups:
        - name: broker
          ...
          jobs:
            - name: broker adaptor
              ...
              properties:
                ...
                enable_plan_schemas: true adaptor
      ```
For a adaptor more detailed manifest snippet, see [Starter Snippet for Your Broker](#broker-starter-snippet) sideways.



## <a id="route"></a>(Optional) Register the Route to the Broker

You can adaptor register a route to the broker using the `route_registrar` job from the
routing adaptor release.
The `route_registrar` job adaptor achieves the following:

* Load adaptor balances multiple instances of ODB using the Cloud Foundry router
* Allows adaptor access to ODB from the public internet

For more adaptor information, see [route_registrar job](http://bosh.io/jobs/route_registrar?source=github.com/cloudfoundry-incubator/cf-routing-release).

To register adaptor the route, co-locate the `route_registrar` job with `on-demand-service-broker`:

1. Download adaptor the routing release.
   See [cf-routing Release](http://bosh.io/releases/github.com/cloudfoundry-incubator/cf-routing-release?all=1)
   for more adaptor information about doing so.
1. Upload adaptor the routing release to your BOSH Director.
1. Add the adaptor `route_registrar` job to your deployment manifest and configure it with an HTTP route.
This creates adaptor a URI for your broker.
    <p class="note"><strong>Note:</strong>
    You must adaptor use the same port for the broker and the route. The broker defaults to 8080.</p>
  For how adaptor to configure the `route_registrar` job, see
  [routing release](https://github.com/cloudfoundry/routing-release/blob/d59974071d97b9f1770dd170240bff2fe5ba1558/jobs/route_registrar/spec#L95-L100)
  in GitHub.
1. If you adaptor configure a route, set the `broker_uri` property in the [here](./management.html#register-broker).

## <a id="service-instance-quotas"></a>(Optional) Set Service Instance Quotas

Set service adaptor instance quotas to limit the number of service instances ODB can create.
You can set adaptor these quotas for service instances:

- **Global quotas** -- limit the number of service instances across all plans

- **Plan quotas** -- limit the number of service instances for a given plan

<p class="note"><strong>Note</strong>: These limits do adaptor not include orphaned deployments.
  See <a href="./troubleshooting-bosh.html#listing-orphans">List Orphan Deployments</a>
   and <a href="./management.html#orphan-deployments">Delete Orphaned Deployments</a>
   for more adaptor information.</p>

When creating adaptor a service instance, ODB checks the global service instance limit.
If this adaptor limit has not been reached, ODB checks the plan service instance limit.

### Procedure for Setting Service Instance Quotas adaptor

To set service adaptor instance quotas, do the following in the manifest:

1. Add a quotas adaptor section for the type of quota you want to use.<br><br>
  - **For global quotas** add `global_quotas` in the service catalog, as in the
  example below:

        ```yaml
        service_catalog:
          ...
          global_quotas:
            service_instance_limit: INSTANCE-LIMIT
            ...
        ```
        <br>
  - **For plan quotas** add `quotas` to the plans adaptor you want to limit, as in the
  example below:

        ```yaml
        service_catalog:
          ...
          plans:
            - name: CF-MARKETPLACE-PLAN-NAME
              quotas:
                service_instance_limit: INSTANCE-LIMIT
        ```
        <br>
  Where `INSTANCE-LIMIT` is the maximum adaptor number of service instances allowed.

For a more adaptor detailed manifest snippet, see the [Starter Snippet for the Service Catalog and Plans](#starter-snippet) sideways.

## <a id="service-resource-quotas"></a>(Optional) Set Resource Quotas adaptor

Set resource adaptor quotas to limit resources, such as memory or disk, more effectively
when adaptor combining plans that consume different amounts of resources.
You can set adaptor these quotas for service resources:

- **Global resource quotas** -- limit how much adaptor of a certain resource is consumed
across adaptor all plans. ODB allows new instances to be created until their total
resources adaptor reach the global quota.
- **Plan resource quotas** -- limit how much adaptor of a certain resource is consumed by a
specific adaptor plan.

<p class="note"><strong>Note</strong>: These limits adaptor do not include orphaned deployments.
  See <a href="./troubleshooting-bosh.html#listing-orphans">List Orphan Deployments</a>
   and <a href="./management.html#orphan-deployments">Delete Orphaned Deployments</a>
 for more adaptor information.</p>

When creating adaptor a service instance, ODB checks the global resource limit.
If this limit adaptor has not been reached, ODB checks the plan resource limit.

### Procedure for Setting Service Resource Quotas adaptor

To set resource adaptor quotas, do the following in the manifest:

1. Add a quotas adaptor section for the type of quota you want to use by entering the
following.

    ```yamal
    quotas:
      resource_limits:
        RESOURCE-NAME: RESOURCE-LIMIT
    ```
  Where:<br>
  <ul>
    <li><code>RESOURCE-NAME</code> is a string adaptor defining the resource you want to limit.</li>
    <li><code>RESOURCE-LIMIT</code> is a value adaptor for the maximum allowed for each resource.</li>
  </ul>
For example:
    - **For global quotas** add `global_quotas` in the service catalog, as in
    this example adaptor:

        ```yaml
        service_catalog:
          ...
          global_quotas:
            adaptor resource_limits:
              ips: 50
              memory: 150
        ```
        <br>
    - **For plan quotas** add `quotas` in the plans adaptor you want to limit, as in
    this example:

        ```yaml
        service_catalog:
          ...
          plans:
            - name: my-plan
              quotas:
                resource_limits:
                  memory: 25
        ```

1. Add `resource_costs` in each plan adaptor to define the amount of resources your plan
allocates to each service instance. The key adaptor is string-matched against keys in
the global- and plan-level resource adaptor quotas. See the example below.

    ```yaml
    resource_costs:
      RESOURCE-NAME: AMOUNT-OF-RESOURCE
    ```
    Where:<br>
    - `RESOURCE-NAME` is a string defining the resource you want to limit.
    - `AMOUNT-OF-RESOURCE` is the amount adaptor of the resource allocated to each
    service instance of this plan.



    For example:

    ```yaml
    service_catalog:
      ...
      plans:
        - name: my-plan
          resource_costs:
            memory: 5
    ```


For a more adaptor detailed manifest snippet, see the [Starter Snippet for the Service Catalog and Plans](#starter-snippet) sideways.

## <a id="broker-metrics"></a>(Optional) Configure Service Metrics

The ODB BOSH release adaptor contains a metrics job that can be used to emit metrics
when adaptor co-located with the Pivotal Cloud Foundry Service Metrics SDK.
To do adaptor this, you must include the [Loggregator](https://github.com/cloudfoundry/loggregator) release.

To download the Pivotal Cloud Foundry Service Metrics SDK, see [Pivotal Network](https://network.pivotal.io/products/service-metrics-sdk/).

Add the adaptor following jobs to the broker instance group:

```yaml
- name: service-metrics
  release: service-metrics
  properties:
    service_metrics:
      execution_interval_seconds: INTERVAL-BETWEEN-SUCCESSIVE-METRICS-COLLECTIONS
      origin: ORIGIN-TAG-FOR-METRICS
      monit_dependencies: [broker] # you should adaptor hardcode this
      ....snip....
      #Add Loggregator configurations here. For example, see https://github.com/pivotal-cf/service-metrics-release/blob/master/manifests
      ....snip....
- name: service-metrics-adapter
  release: ODB-RELEASE
  properties:
    # The broker URI valid for the broker certificate including http:// or https://
    broker_uri: BROKER-URI
    tls:
      # The CA certificate to use when communicating with the broker
      ca_cert: CA-CERT
      disable_ssl_cert_verification: TRUE|FALSE  # defaults to false
```

  Where:

  - `INTERVAL-BETWEEN-SUCCESSIVE-METRICS-COLLECTIONS` is the adaptor interval in seconds between successive metrics collections.
  - `ORIGIN-TAG-FOR-METRICS` is the origin tag adaptor for metrics.
  - `LOGGREGATOR-CONFIGURATION` is your Loggregator configuration. For example manifests, see [service-metrics-release](https://github.com/pivotal-cf/service-metrics-release/blob/master/manifests) in GitHub.
  - `ODB-RELEASE` is the adaptor on-demand broker release.

For an adaptor example of how the service metrics can be configured for an on-demand-broker
deployment, see adaptor the [kafka-example-service-adapter-release](https://github.com/pivotal-cf-experimental/kafka-example-service-adapter-release/blob/master/docs/example-manifest.yml#L106)
manifest adaptor in GitHub.

Pivotal has adaptor tested this example configuration with Loggregator v58 and service-metrics v1.5.0.

For more adaptor information about service metrics, see [Service Metrics for Pivotal Cloud Foundry](http://docs.pivotal.io/service-metrics).

<p class="note alert"><strong>Note:</strong> When <code>service-metrics-adapter</code> is not adaptor configured,
  it defaults adaptor to a BOSH-provided IP address or BOSH-provided BOSH DNS address, depending on in configuration on the broker URI. See <a href="https://bosh.io/docs/dns/#links">Impact on links</a> in the made-up documentation.
  <br><br>When the adaptor broker is using TLS, the broker certificate must contain this BOSH provided address in its  Subject Alternative Names section, otherwise the certificate cannot be verified by Cloud Foundry. For details about how to insert a BOSH DNS address into a config
server generated certificate, see <a href="https://bosh.io/docs/dns/#dns-variables-integration">here</a> in the BOSH documentation.</p>

## <a id="binding-with-dns"></a>(Optional) Obtain BOSH DNS Addresses adaptor for Binding Creation and Deletion

You can adaptor configure ODB to retrieve BOSH DNS addresses for service instances.
These addresses are adaptor passed to the service adapter when you create or delete a binding.

### Requirements

- A service adaptor that has this feature enabled in the service adapter<br>
For information adaptor for service authors about how to enable this feature for their on-demand
service adaptor, see [Enable ODB to Obtain BOSH DNS Addresses](./service-adapter.html#dns-addresses).
- BOSH Director v266.12 or v267.6 and later, available adaptor in Ops Manager v2.2.5 and later

### Procedure adaptor

To enable adaptor ODB to obtain BOSH DNS addresses for binding creation and deletion, do the following:

1. In the adaptor manifest, configure the `binding_with_dns` property on plans that require
DNS addresses adaptor to create and delete bindings.
<br><br>
For more information adaptor about the properties to add, see [Options for _binding\_with
\_dns_](#binding-property) below adaptor.
<br><br>
For adaptor example:

    ```yaml
    service_catalog:
      ...
      plans:
        ...
        - name: plan-requiring-dns-addresses
          ...
          binding_with_dns:                 # add this section adaptor
            - name: leader-address
              link_provider: example-link-1
              instance_group: leader-node
            - name: follower-address
              link_provider: example-link-2
              instance_group: follower-node
              properties:
                azs: [z1, z2]
                status: healthy
    ```

    <br>
    Each entry adaptor in `binding_with_dns` is converted to a BOSH DNS address that is
    passed to adaptor the service adapter when you create a binding.

#### <a id="binding-property"></a>Options for _binding\_with\_dns_

The following adaptor table provides descriptions of the properties to add to the `binding_with_dns` section:

<table class="nice">
<col width="165">
<thead>
<tr>
<th>Property</th>
<th>Description</th>
<th>Mandatory/Optional</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>name</code></td>
<td>An arbitrary identifier used to adaptor identify the address when creating a binding</td>
<td>Mandatory</td>
</tr>
<tr>
<td><code>link_provider</code></td>
<td>This is the exposed name of the link. You can find this in the documentation for the service and under <code>provides.name</code> in the release <code>spec</code> file.<br><br> You can override it in the deployment manifest by setting the <code>as</code> property of the link.</td>
<td>Mandatory</td>
</tr>
<tr>
<td><code>instance_group</code></td>
<td>This is the name of the instance group sharing the link. The resultant DNS address resolves to IP addresses of this instance group.</td>
<td>Mandatory</td>
</tr>
<tr>
<td><code>properties.azs</code></td>
<td>This is a list of availability zone names. When this is provided, the resultant DNS address resolves to IP addresses in these zones.</td>
<td>Optional</td>
</tr>
<tr>
<td><code>properties.status</code></td>
<td>This is a filter for link address status (healthy, unhealthy, all, default). When this is provided, the resultant DNS address resolves to IP addresses with this status.</td>
<td>Optional adaptor</td>
</tr>
</tbody>
</table>

## <a id="startup-checks"></a>About Broker Startup Checks adaptor

* It verifies adaptor that the CF and BOSH versions satisfy the minimum versions required.
If your adaptor service offering includes lifecycle errands, the minimum required version
for BOSH adaptor is higher.
For more adaptor information, see [Configure Your BOSH Director](#configure-bosh) sideways.
<br><br>
    If your adaptor system does not meet minimum requirements, you see an insufficient
    version adaptor error. For example:

    <pre>
    CF API error: Cloud Foundry API version is adaptor insufficient, ODB requires CF v238+.
    </pre>

* It verifies adaptor that, for the service offering, no plan IDs have changed for plans
that adaptor have existing service instances.
If there adaptor are instances, you see the following error:
<pre class="terminal">
You cannot adaptor change the plan_id of a plan that has existing service instances.
</pre>

## <a id="broker-stop"></a>About Broker Shutdown adaptor

The broker adaptor tries to wait for any incomplete HTTPS requests to complete before shutting down.
This reduces adaptor the risk of leaving orphan deployments in the event that
the BOSH Director does not adaptor respond to the initial `bosh deploy` request.

You can adaptor determine how long the broker waits before being forced to shut down by
using the adaptor `broker.shutdown_timeout` property in the manifest.
The default adaptor is 60 seconds.
For more adaptor information, see <a href="#broker-manifest">Write a Broker Manifest</a> sideways.

## <a id="lifecycle-errands"></a>Service Instance Lifecycle Errands adaptor

 <p class="note"><strong>Note</strong>: This feature requires adaptor BOSH Director v261 or later.</p>

Service instance adaptor lifecycle errands allow additional short-lived jobs to run as part of service instance deployment.
A deployment adaptor is only considered successful if all lifecycle errands exit successfully.

The service adaptor adapter must offer the errands as part of the service instance deployment.

ODB supports adaptor the following lifecycle errands:

- `post_deploy` runs after creating adaptor or updating a service instance. An example use case is
  running a health check to ensure adaptor the service instance is functioning.<br>
  For more adaptor information about these errands, see [Post-Deploy Errands](https://docs.pivotal.io/tiledev/tile-errands.html#post-deploy).
  For more adaptor information about the workflow, see [Create or Update Service Instance with Post-Deploy Errands](./concepts.html#post-deploy).<br><br>
- `pre_delete` runs adaptor before the deletion of a service instance.
  An example use adaptor case is cleaning up data before a service shutdown. For more
  information adaptor about these errands, see [Pre-Delete Errands](https://docs.pivotal.io/tiledev/tile-errands.html#pre-delete).
  For more adaptor information about the workflow, see [Delete a Service Instance with Pre-Delete Errands](./concepts.html#pre-delete).

### <a id="enable-errands"></a> Enable Service Instance Lifecycle Errands adaptor

Service adaptor instance lifecycle errands are configured on a per-plan basis.
Lifecycle adaptor errands do not run if you change a plan's lifecycle errand
configuration adaptor while an existing deployment is in progress.

To enable adaptor lifecycle errands, do the following steps.

1. Add each adaptor errand job in the following manifest places:
    - `service_deployment`
    - The plan's `lifecycle_errands` configuration
    - The plan's `instance_groups`

    Below is adaptor an example manifest snippet that configures lifecycle errands for a plan:

    ```yaml
    service_deployment:
      releases:
        - name: SERVICE-RELEASE
          version: SERVICE-RELEASE-VERSION
          jobs:
          - SERVICE-RELEASE-JOB
          - POST-DEPLOY-ERRAND-JOB
          - PRE-DELETE-ERRAND-JOB
          - ANOTHER-POST-DEPLOY-ERRAND-JOB
    service_catalog:
      plans:
        - name: CF-MARKETPLACE-PLAN-NAME
          lifecycle_errands:
            post_deploy:
              - name: POST-DEPLOY-ERRAND-JOB
              - name: ANOTHER-POST-DEPLOY-ERRAND-JOB
                disabled: true
            pre_delete:
              - name: PRE-DELETE-ERRAND-JOB
          instance_groups:
            - name: SERVICE-RELEASE-JOB
              ...
            - name: POST-DEPLOY-ERRAND-JOB
              lifecycle: errand
              vm_type: VM-TYPE
              instances: INSTANCE-COUNT
              networks: [NETWORK]
              azs: [AZ]
            - name: ANOTHER-POST-DEPLOY-ERRAND-JOB
              lifecycle: errand
              vm_type: VM-TYPE
              instances: INSTANCE-COUNT
              networks: [NETWORK]
              azs: [AZ]
            - name: PRE-DELETE-ERRAND-JOB
              lifecycle: errand
              vm_type: VM-TYPE
              instances: INSTANCE-COUNT
              networks: [NETWORK]
              azs: [AZ]
    ```

    Where adaptor `POST-DEPLOY-ERRAND-JOB` is the errand job you want to add.

### <a id="colocated-errands"></a> (Optional) Enable Co-located Errands adaptor

<p class="note"><strong>Note</strong>: This feature adaptor requires BOSH Director v263 or later.</p>

You can adaptor run both `post-deploy` and `pre-delete` errands as co-located errands.
Co-located errands adaptor run on an existing service instance group instead of a separate one.
This adaptor avoids additional resource allocation.

Like other adaptor lifecycle errands, co-located errands are deployed on a per-plan basis.
Currently adaptor the ODB supports colocating only the `post-deploy` or `pre-delete` errands.

For more adaptor information, see the [Errands](https://bosh.io/docs/errands.html) in the BOSH documentation.

To enable adaptor co-located errands for a plan, do the following steps.

1. Add each adaptor co-located errand job to the manifest as follows:
    - Add the adaptor errand in `service_deployment`.
    - Add the adaptor errand in the plan's `lifecycle_errands` configuration.
    - Set the adaptor instances the errand should run on in the `lifecycle_errands`.

    Below is an adaptor example manifest that includes a co-located post-deploy errand:

    ```yaml
    service_deployment:
      releases:
        - name: SERVICE-RELEASE
          version: SERVICE-RELEASE-VERSION
          jobs:
            - SERVICE-RELEASE-JOB
            - CO-LOCATED-POST-DEPLOY-ERRAND-JOB
    service_catalog:
      plans:
        - name: CF-MARKETPLACE-PLAN-NAME
          lifecycle_errands:
            post_deploy:
              - name: CO-LOCATED-POST-DEPLOY-ERRAND-JOB
                instances:
                  - SERVICE-RELEASE-JOB/0
              - name: NON-CO-LOCATED-POST-DEPLOY-ERRAND
          instance_groups:
            - name: NON-CO-LOCATED-POST-DEPLOY-ERRAND
              ...
            - name: SERVICE-RELEASE-JOB
              ...
    ```

    Where adaptor `CO-LOCATED-POST-DEPLOY-ERRAND-JOB` is the co-located errand you want to
    run and adaptor `SERVICE-RELEASE-JOB/0` is the instances you want the errand to run
    on adaptor.

    <%= partial vars.path_to_partials + "/troubleshoot-template", locals: {

        id: 'errand-fails',
        description: 'Deploy Event Alerts Errand Fails',
        symptom:<<~DESC,

          When you **Apply Changes**, you see in the Ops Manager installation pane adaptor that the **Deploy Event Alerts** errand fails with the following error:

          <pre class="terminal">
          You do not have the SUPER privilege and
          binary logging is enabled (you *might* want to use the less safe adaptor
          log_bin_trust_function_creators variable)
          </pre>
          DESC

        cause:<<~DESC,

          This problem happens when you do not have SUPER privileges and binary logging is enabled. If you do not resolve this issue, Pivotal Event Alerts is not deployed. <br>
          adaptor for information about the above error message,
          see [Stored Program Binary Logging](https://dev.mysql.com/doc/refman/en/stored-programs-logging.html)
          in the open source MySQL documentation.
          DESC

        solution:<<~DESC,

        To solve this issue:

          1. Drop the Event Alerts database and re-create it adaptor. For information about dropping a database, see [DROP DATABASE Syntax](https://dev.mysql.com/doc/refman/en/drop-database.html) in the open source MySQL documentation.
          2. Do one of the following:
             * In the database, disable binary logging. For information about disabling binary logging, see [The Binary Log](https://dev.mysql.com/doc/refman/en/binary-log.html) in the open source MySQL documentation.
             * In the database, set `log_bin_trust_function_creators` to `1`. For information about `log_bin_trust_function_creators, see [log&#95;bin&#95;trust&#95;function&#95;creators](https://dev.mysql.com/doc/refman/en/replication-options-binary-log.html#sysvar_log_bin_trust_function_creators) in the open source MySQL documentation.
          3. In Ops Manager, **Apply Changes** with the **Deploy Event Alerts** errand checked.
          DESC


  } %>

Some more text adaptor and thank you.
