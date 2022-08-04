# Style Checker

Style Checker is a script that adds comments to your document.
The comments flag deviations from
[IX Standards](https://confluence.eng.vmware.com/display/public/IXCS/IX+Content+Standards),
passive voice constructions, redundancy, awkward phrasing, and accessibility problems.

You can run Style Checker in one of several text editor extensions.

## Style Checker for VS Code

Follow these procedures to add Style Checker to VS Code.

> **Note:** If you use Style Checker with the [Replace Rules extension](https://marketplace.visualstudio.com/items?itemName=bhughes339.replacerules),
> I recommend you try the much faster
> [RegReplace](https://marketplace.visualstudio.com/items?itemName=DomiR.regreplace) extension as
> described in the installation steps.

### Style Checker for VS Code Prerequisites

- Install [Visual Studio Code (VS Code)](https://code.visualstudio.com/download)
- Install [RegReplace](https://marketplace.visualstudio.com/items?itemName=DomiR.regreplace) or
  [Replace Rules](https://marketplace.visualstudio.com/items?itemName=bhughes339.replacerules).
  RegReplace is recommended, but some have failed to make it work on their machines.

### <a id="multiline"></a> Configure RegReplace to run multiline searches

Some Style Checker commands depend on searching across multiple lines.
To configure RegReplace to run multiline searches:

1. On your MacBook, go to 

  ```console
  ~/.vscode/extensions/domir.regreplace-VERSION/out/src
  ```
  
  Where `VERSION` is your RegReplace version. For example, `1.3.1` or `1.3.0`.
   
1. Open `regreplace.js`.
1. Change the line

    ```js
    const reg = command.global === false ? new RegExp(regexQuery) : new RegExp(regexQuery, 'g');
    ```

    to

    ```js
    const reg = command.global === false ? new RegExp(regexQuery, 'm') : new RegExp(regexQuery, 'gm');
    ```

1. Save your change.

### Configure your extension to run Style Checker

To install Style Checker:

1. Copy the contents of the JSON file for your VS Code extension,
   [style-checker-for-reg-replace.json](style-checker-for-reg-replace.json) or
   [style-checker-for-replace-rules.json](style-checker-for-reg-replace.json).
1. Start VS Code.
1. If on macOS, press Cmd+Shift+P to open the Command Palette. If on Windows, press Ctrl+Shift+P.
1. Run `Open Settings (JSON)`.
1. Paste the content outside the other JSON functions and before the final `}` in this file.
   I recommend placing the content beneath the other functions because of how long it is.
   For an example of the placement, see [example-settings.json](example-settings.json).
1. Save your changes.
1. Restart VS Code.

### Use Style Checker for VS Code

1. Open a document you want to edit in VS Code.
1. If on macOS, press Cmd+Shift+P to open the Command Palette. If on Windows, press Ctrl+Shift+P.
1. Run `RegReplace: Run all` if using RegReplace.
   Run `Replace Rules: Run Ruleset...` > `Ruleset: Style Checker` if using Replace Rules.
1. Review any comments that have appeared within your text.
   They typically follow the pattern `<!--฿ |CORRECT-WORD| is preferred. ฿-->`.
1. Make your changes.

### Troubleshooting RegReplace

If you encounter the following error:

  ```text
  Command 'RegReplace: Run all' resulted in an error (command 'regreplace.regreplace' not found)
  ```

1. Install the previous version of RegReplace (v1.3.0). Do so by clicking the down arrow next to the 
   **Uninstall** button on the extension and then clicking **Install Another Version...**.
1. Click the **Reload Required** button.
1. Repeat the steps in [Configure RegReplace to run multiline searches](#multiline) to edit the new config 
   file for your RegReplace version.

### Delete Style Checker comments

You can undo Style Checker changes by pressing Cmd+Z.
To quickly delete Style Checker comments after making other changes in your topic that you don't want
to lose, follow these steps:

- To delete all instances of a particular Style Checker comment, select one, press Cmd+Shift+L to
  select all identical comments, and then press Delete.
- To quickly delete all Style Checker comments in a topic:
   1. Press Cmd+F.
   2. Press Cmd+Option+R to enable regex.
   3. Find `<!--฿[^฿]*฿-->`.
   4. Replace it with nothing.
   5. Repeat for every Style Checker comment. To be safe, go one by one instead of using Replace All.

### Update Style Checker for VS Code

To update:

1. Copy the content of the JSON file for your extension, as you did when installing.
2. Start VS Code.
3. If on macOS, press Cmd+Shift+P to open the Command Palette. If on Windows, press Ctrl+Shift+P.
4. Run `Open Settings (JSON)`.
5. Delete your existing Style Checker content.
6. Paste in the new Style Checker content.
7. Save your changes.
8. Restart VS Code.

## Style Checker for Atom

GitHub plans to [sunset Atom on December 15, 2022](https://github.blog/2022-06-08-sunsetting-atom/).
Style Checker for Atom is no longer in development.

### Use Style Checker for Atom

1. Open a document you want to edit in Atom.
1. Press F10 or, in the Atom toolbar, click **Packages > HTML Special Character Replacer > Replace Chars**
   to add comments to possible style errors. If you select a passage of text first, Style Checker
   runs only on your selected text.
   Comments typically follow the pattern `<!-- |CORRECT-WORD| is preferred. -->`.
1. Review any comments that have appeared within your text. These comments suggest changes that might
   be necessary to meet [IX Standards](https://confluence.eng.vmware.com/display/public/IXCS/IX+Content+Standards).
1. Make your changes.
1. Delete any leftover Style Checker comments by opening Find and Replace, enabling regex for Find,
   and searching for `<!-- .* -->`. This targets all HTML comments in the topic. Play it safe: go
   one by one instead of using Replace All.

### Update Style Checker for Atom

To update:

1. Copy the contents of
[style-checker-for-atom.js](style-checker-for-atom.js).
1. Start Atom.
1. In the Atom toolbar go to **Atom > Preferences**. The path differs slightly from this if on Windows.
1. Click **Open Config Folder** in the side tab.
1. In the **Project** directory tree go to
**packages > html-special-character-replacer > lib > html-special-character-replacer.js**.
1. Delete the content.
1. Paste in the content that you copied from
[style-checker-for-atom.js](style-checker-for-atom.js). in this repository.
1. Save your changes to `html-special-character-replacer.js`.
1. Restart Atom.
