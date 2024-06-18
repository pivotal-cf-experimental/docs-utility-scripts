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

## Instructions

1. Download the `component_version_table_generator.py` script to your local machine.

2. Download the most recently modified YAML file for the relevant docs version from [artifactory.eng.vmware.com](https://artifactory.eng.vmware.com/ui/native/tap-builds-generic-local/).

3. Move the YAML file to the directory that `component_version_table_generator.py` is in.

4. Open `component_version_table_generator.py` in a text editor. Replace the file path `yaml_file_path` with the name of the `yaml` file. For example:

    ```py
    yaml_file_path = "1.7.4.yaml"
    ```

5. Run the `component_version_table_generator.py` script in the directory that the script is located in:

    ```console
    python3 component_version_table_generator.py
    ```

6. Open the Markdown file. The file should have the same name as the input YAML file. For example, if the YAML file is named `1.7.4.yaml`, the output Markdown file named `1.7.4.md` appears in the same directory.

7. Copy the Markdown content to the release notes.

8. Replace the two placeholders for "Tanzu CLI" and "Cartographer Conventions" with their real version numbers.

9. Sort these two rows in alphabetical order.

10. Verify that any necessary alpha and beta labels are on the correct components.
