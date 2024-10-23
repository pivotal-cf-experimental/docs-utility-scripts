import yaml

# Mapping relationship
mapping_relationship = {
    "apis.apps.tanzu.vmware.com": "API Auto Registration",
    "api-portal.tanzu.vmware.com": "API portal",
    "accelerator.apps.tanzu.vmware.com": "Application Accelerator",
    "application-configuration-service.tanzu.vmware.com": "Application Configuration Service",
    "apiserver.appliveview.tanzu.vmware.com": "Application Live View APIServer",
    "backend.appliveview.tanzu.vmware.com": "Application Live View back end",
    "connector.appliveview.tanzu.vmware.com": "Application Live View connector",
    "conventions.appliveview.tanzu.vmware.com": "Application Live View conventions",
    "sso.apps.tanzu.vmware.com": "Application Single Sign-On",
    "amr-observer.apps.tanzu.vmware.com": "Artifact Metadata Repository Observer",
    "aws.services.tanzu.vmware.com": "AWS Services",
    "bitnami.services.tanzu.vmware.com": "Bitnami Services",
    "carbonblack.scanning.apps.tanzu.vmware.com": "Carbon Black Scanner for SCST - Scan (beta)",
    "cartographer.tanzu.vmware.com": "Cartographer Conventions",
    "cert-manager.tanzu.vmware.com": "cert-manager",
    "cnrs.tanzu.vmware.com": "Cloud Native Runtimes",
    "contour.tanzu.vmware.com": "Contour",
    "crossplane.tanzu.vmware.com": "Crossplane",
    "tap-auth.tanzu.vmware.com": "Default Roles",
    "developer-conventions.tanzu.vmware.com": "Developer Conventions",
    "config-server.spring.tanzu.vmware.com": "Enterprise Config Server",
    "external-secrets.apps.tanzu.vmware.com": "External Secrets Operator",
    "fluxcd-source-controller.tanzu.vmware.com": "Flux CD Source Controller",
    "fluxcd.source.controller.tanzu.vmware.com": "Flux CD Source Controller",
    "grype.scanning.apps.tanzu.vmware.com": "Grype Scanner for SCST - Scan",
    "local-source-proxy.apps.tanzu.vmware.com": "Local Source Proxy",
    "namespace-provisioner.apps.tanzu.vmware.com": "Namespace Provisioner",
    "ootb-delivery-basic.tanzu.vmware.com": "Out of the Box Delivery - Basic",
    "ootb-supply-chain-basic.tanzu.vmware.com": "Out of the Box Supply Chain - Basic",
    "ootb-supply-chain-testing.tanzu.vmware.com": "Out of the Box Supply Chain - Testing",
    "ootb-supply-chain-testing-scanning.tanzu.vmware.com": "Out of the Box Supply Chain - Testing and Scanning",
    "ootb-templates.tanzu.vmware.com": "Out of the Box Templates",
    "servicebinding.tanzu.vmware.com": "Service Bindings",
    "service-bindings.labs.vmware.com": "Service Bindings",
    "service-registry.spring.apps.tanzu.vmware.com": "Service Registry",
    "services-toolkit.tanzu.vmware.com": "Services Toolkit",
    "snyk.scanning.apps.tanzu.vmware.com": "Snyk Scanner for SCST - Scan (beta)",
#    "sonarqube.component.apps.tanzu.vmware.com": "SonarQube Scan Supply Chain Component (alpha)",
    "spring-boot-conventions.tanzu.vmware.com": "Spring Boot conventions",
    "spring-cloud-gateway.tanzu.vmware.com": "Spring Cloud Gateway",
    "cartographer.tanzu.vmware.com": "Supply Chain Choreographer",
    "policy.apps.tanzu.vmware.com": "Supply Chain Security Tools - Policy Controller",
    "scanning.apps.tanzu.vmware.com": "Supply Chain Security Tools - Scan",
    "app-scanning.apps.tanzu.vmware.com": "Supply Chain Security Tools - Scan 2.0",
    "metadata-store.apps.tanzu.vmware.com": "Supply Chain Security Tools - Store",
    "controller.source.apps.tanzu.vmware.com": "Source Controller",
    "tap-gui.tanzu.vmware.com": "Tanzu Developer Portal",
    "tpb.tanzu.vmware.com": "Tanzu Developer Portal Configurator",
    "tap-telemetry.tanzu.vmware.com": "Tanzu Application Platform Telemetry",
    "buildservice.tanzu.vmware.com": "Tanzu Build Service",
    "tekton.tanzu.vmware.com": "Tekton Pipelines",
    "managed-resource-controller.apps.tanzu.vmware.com": "Managed Resource Controller (beta)",
    "supply-chain.apps.tanzu.vmware.com": "Tanzu Supply Chain (beta)",
    "eventing.tanzu.vmware.com": "Eventing (deprecated)",
    "learningcenter.tanzu.vmware.com": "Learning Center (deprecated)",
    "workshops.learningcenter.tanzu.vmware.com": "Learning Center workshops (deprecated)"
}

# Read YAML data from file
yaml_file_path = "1.12.0.yaml"
with open(yaml_file_path, "r") as file:
    yaml_data = file.read()

# Parse YAML
data = yaml.safe_load(yaml_data)

# Markdown table content
markdown_table = "| Component Name | Version |\n|------|---------|\n"

# Iterate through packages and add to Markdown table only if a mapping exists
mapped_packages = []
for package in data['packages_version']:
    mapped_name = mapping_relationship.get(package['name'])
    if mapped_name is not None:
        mapped_packages.append({'name': mapped_name, 'version': package['version']})

# Sort the packages alphabetically by name (case-insensitive)
mapped_packages.sort(key=lambda x: x['name'].lower())

# Add rows to Markdown table
for package in mapped_packages:
    markdown_table += f"| {package['name']} | {package['version']} |\n"

# Add two more rows
markdown_table += "| Tanzu CLI | <!-- See `template_variables.yaml` --> |\n"
markdown_table += "| Cartographer Conventions | <!-- Same as `Supply Chain Choreographer`--> |\n"

# Write Markdown table to a file with the same name
markdown_file_path = f"{yaml_file_path.replace('.yaml', '.md')}"
with open(markdown_file_path, "w") as markdown_file:
    markdown_file.write(markdown_table)

print(f"Alphabetically sorted Markdown table written to {markdown_file_path}")
