# Style Checker

Style Checker adds comments within text that flag deviations from
[IX Standards](https://confluence.eng.vmware.com/display/public/IXCS/IX+Content+Standards).
It also adds comments that flag formatting errors, passive voice constructions, redundancy, and
accessibility problems.

## Prerequisites

- Install [Visual Studio Code (VS Code)](https://code.visualstudio.com/download)
- Install the VS Code extension [Replace Rules](https://marketplace.visualstudio.com/items?itemName=bhughes339.replacerules)


## <a id="install"></a> Install Style Checker

To install Style Checker:

1. Copy the contents of [style-checker.json](style-checker.json).
1. Launch VS Code.
1. If on macOS, press Cmd+Shift+P to open the Command Palette. If on Windows, press Ctrl+Shift+P.
1. Run `Open Settings (JSON)`.
1. Paste the content outside the other JSON functions and before the final `}` in this file. For an example of the placement, see [example-settings.json](example-settings.json).
1. Save your changes.
1. Restart VS Code.


## <a id="configure-zsh-vscode"></a> (Optional) Configure your zsh profile to enable fast updates

To configure your zsh profile so that you can update Style Checker with a single command:

[To-do]


## Use Style Checker

1. Open a document you want to edit in VS Code.
1. If on macOS, press Cmd+Shift+P to open the Command Palette. If on Windows, press Ctrl+Shift+P.
1. Run `Replace Rules: Run Ruleset...` and then `Ruleset: Style Checker` to add comments to possible errors. If you select a passage of text first, Style Checker runs only on your selected text.
1. Wait a few seconds for Style Checker to finish running. Under default VS Code settings, comments turn green when the script has finished running.
1. Review any comments that have appeared within your text.
These comments suggest changes that might be necessary to meet [IX Standards](https://confluence.eng.vmware.com/display/public/IXCS/IX+Content+Standards). They typically follow the pattern `<!-- |CORRECT-WORD| is preferred. -->`.
1. Make your changes.

### Tips

1. To delete all instances of a particular Style Checker comment, select one, press Cmd+Shift+L to select all identical comments, and then press Delete.
1. To delete all comments in the topic (Style Checker and otherwise), open Find and Replace, enable regex for Find, search for `<!-- .* -->`, and replace with nothing. Play it safe: go one by one instead of using Replace All.


## Update Style Checker

To update to the latest version, follow one of these procedures:


### Update Style Checker from the CLI

To update Style Checker from the CLI:

1. If you have not already done so, [Configure your zsh profile to enable fast updates](#configure-zsh-vscode).
1. From the CLI, run:

    ```
    update_style
    ```


### Update Style Checker manually

To update manually:

1. Copy the contents of [style-checker.json](style-checker.json).
1. Launch VS Code.
1. If on macOS, press Cmd+Shift+P to open the Command Palette. If on Windows, press Ctrl+Shift+P.
1. Run `Open Settings (JSON)`.
1. Paste the content over your existing Style Checker functions. 
1. Save your changes.
1. Restart VS Code.

# Style Checker for Atom

GitHub will [sunset Atom in December 15, 2022](https://github.blog/2022-06-08-sunsetting-atom/). Style Checker for Atom installation steps have been removed.


## <a id="configure-bash-atom"></a> (Optional) Configure your bash profile to enable fast updates

To configure your bash profile so that you can update Style Checker for Atom with a single command:

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


## Use Style Checker for Atom

1. Open a document you want to edit in Atom.
1. Press F10 or, in the Atom toolbar, click **Packages > HTML Special Character Replacer > Replace Chars** to add comments to possible style errors. If you select a passage of text first, Style Checker runs only on your selected text.
Comments typically follow the pattern `<!-- |CORRECT-WORD| is preferred. -->`.
1. Review any comments that have appeared within your text. These comments suggest changes that might be necessary to meet [IX Standards](https://confluence.eng.vmware.com/display/public/IXCS/IX+Content+Standards).
1. Make your changes.
1. Delete any leftover Style Checker comments by opening Find and Replace, enabling regex for Find, and searching for `<!-- .* -->`. This targets all HTML comments in the topic. Play it safe: go one by one instead of using Replace All.


## Update Style Checker for Atom

To update to the latest Style Checker version, follow one of these procedures:


### Update Style Checker for Atom from the CLI

To update Style Checker from the CLI:

1. If you have not already done so, [Configure your bash profile to enable fast updates](#configure-bash-atom).
1. From the CLI, run:

    ```
    update_style
    ```


### Update Style Checker for Atom manually

To update manually:

1. Copy the contents of
[style-checker.js](style-checker.js).
1. Launch Atom.
1. In the Atom toolbar go to **Atom > Preferences**. The path differs slightly from this if on Windows.
1. Click **Open Config Folder** in the side tab.
1. In the **Project** directory tree go to
**packages > html-special-character-replacer > lib > html-special-character-replacer.js**.
1. Delete the content.
1. Paste in the content that you copied from
[style-checker.js](style-checker.js). in this repository.
1. Save your changes to `html-special-character-replacer.js`.
1. Restart Atom.
