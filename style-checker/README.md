# Style Checker

Style Checker adds comments within text that flag deviations from
[IX Standards](https://confluence.eng.vmware.com/display/public/IXCS/IX+Content+Standards).
It also adds comments that flag formatting errors, passive voice constructions, redundancy, and
accessibility problems.


## Prerequisite

[Atom](https://atom.io/)


## <a id="install"></a> Install Style Checker

To install Style Checker:

1. Install the Atom package
[HTML Special Character Replacer](https://atom.io/packages/html-special-character-replacer).
1. Copy the contents of [style-checker.js](style-checker.js).
1. Launch Atom.
1. In the Atom toolbar go to **Atom > Preferences**.
1. Click **Open Config Folder** in the side tab.
1. In the **Project** directory tree go to
**packages > html-special-character-replacer > lib > html-special-character-replacer.js**.
1. Delete the content.
1. Paste in the content that you copied from
[style-checker.js](style-checker.js) in this repository.
1. Save your changes to `html-special-character-replacer.js`.
1. Restart Atom.


## <a id="configure-bash"></a> (Optional) Configure your bash profile to enable fast updates

To configure your bash profile so that you can update Style Checker with a single command:

1. Add the following to your bash profile:

    ```
    update_style () {
      cd ~/workspace/docs-utility-scripts/style-checker
      git pull
      cd ~/.atom/packages/html-special-character-replacer/lib
      cat ~/workspace/docs-utility-scripts/style-checker/style-checker.js > html-special-character-replacer.js
      echo "Style Checker was updated."
      cd ~/workspace
    }
    ```

1. Save your profile.
1. Restart the terminal.


## Update Style Checker

To update to the latest Style Checker version, follow one of these procedures:


### Update Style Checker from the CLI

To update Style Checker from the CLI:

1. If you have not already done so, [Configure your bash profile to enable fast updates](#configure-bash).
1. From the CLI, run:

    ```
    update_style
    ```


### Update Style Checker manually

To update Style Checker manually:

1. Copy the contents of
[style-checker.js](style-checker.js).
1. Launch Atom.
1. In the Atom toolbar go to **Atom > Preferences**.
1. Click **Open Config Folder** in the side tab.
1. In the **Project** directory tree go to
**packages > html-special-character-replacer > lib > html-special-character-replacer.js**.
1. Delete the content.
1. Paste in the content that you copied from
[style-checker.js](style-checker.js). in this repository.
1. Save your changes to `html-special-character-replacer.js`.
1. Restart Atom.


## Use Style Checker

1. Open a document you want to edit in Atom.
1. Press F10 or, in the Atom toolbar, click **Packages > HTML Special Character Replacer > Replace Chars**
to add comments to possible style errors.
Comments typically follow the pattern `<!-- |CORRECT-WORD| is preferred. -->`.
1. Review any comments that have appeared within your text.
These comments suggest changes that might be necessary to meet [IX Standards](https://confluence.eng.vmware.com/display/public/IXCS/IX+Content+Standards).
1. Make your changes and delete the comments. DocWorks sometimes publishes HTML comments so it is
important to delete them.
