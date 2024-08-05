# Component version table generator

The script takes a YAML file containing information about package versions, maps component names to user-friendly names using a predefined dictionary `mapping_relationship`, creates a Markdown table with the mapped names and package versions, sorts the table alphabetically by component name, and writes the resulting Markdown table to a new file with a ".md" extension.

## Prerequisites

- [Install python](https://www.python.org/downloads/).

- Install Xcode Command Line Tools:

    ```console
    xcode-select --install
    ```

- Install `PyYAML`:

    ```console
    pip3 install pyyaml
    ```

- Clone the docs-utility-scripts repo on your machine

## Instructions

1. Download the most recently modified YAML file for the relevant docs version from [artifactory.eng.vmware.com](https://artifactory.eng.vmware.com/ui/native/tap-builds-generic-local/).

1. Move the YAML file to the `component_version_table_generator` folder (the directory that `component_version_table_generator.py` is in).

1. Open `component_version_table_generator.py` in a text editor. 

1. Change the value of `yaml_file_path` to the name of the YAML file you downloaded and include the `.yaml` extension. For example, `1.10.1.yaml`.

1. Run the `component_version_table_generator.py` script:

   ```console
   python3 component_version_table_generator.py
   ```

1. Verify that the produced Markdown file has the same name as the input YAML file. For example, if the YAML file is named `1.10.1.yaml` then the output Markdown file is named `1.10.1.md`.
 
1. Copy the content of the Markdown file to the release notes.

1. Replace the version placeholders in the Tanzu CLI and Cartographer Conventions rows with the real version numbers.

1. Move the Tanzu CLI and Cartographer Conventions rows so that they are in alphabetical order with the rest of the rows.

1. Verify that any necessary alpha and beta labels are on the correct components.
