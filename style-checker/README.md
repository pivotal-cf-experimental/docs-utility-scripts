# Style Checker

Style Checker adds comments within text that flag deviations from
[IX Standards](https://confluence.eng.vmware.com/display/public/IXCS/IX+Content+Standards).
It also adds comments that flag formatting errors, passive voice constructions, redundancy, and
accessibility problems.

> **Note:** If you're using Style Checker with the [Replace Rules extension](https://marketplace.visualstudio.com/items?itemName=bhughes339.replacerules),
> I recommend you switch to the much faster
> [RegReplace](https://marketplace.visualstudio.com/items?itemName=DomiR.regreplace) extension as
> described in the current installation steps.

## Prerequisites

1. Install [Visual Studio Code (VS Code)](https://code.visualstudio.com/download)
1. Install the VS Code extension [RegReplace](https://marketplace.visualstudio.com/items?itemName=DomiR.regreplace)
1. On your MacBook, go to `~/.vscode/extensions/domir.regreplace-1.3.1/out/src`.
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

## <a id="install"></a> Install Style Checker

To install Style Checker:

1. Copy the contents of [style-checker-for-reg-replace.json](style-checker-for-reg-replace.json).
2. Start VS Code.
3. If on macOS, press Cmd+Shift+P to open the Command Palette. If on Windows, press Ctrl+Shift+P.
4. Run `Open Settings (JSON)`.
5. Paste the content outside the other JSON functions and before the final `}` in this file.
   I recommend placing the content beneath the other functions because of how long it is.
   For an example of the placement, see [example-settings.json](example-settings.json).
6. Save your changes.
7. Restart VS Code.

## Use Style Checker

1. Open a document you want to edit in VS Code.
1. If on macOS, press Cmd+Shift+P to open the Command Palette. If on Windows, press Ctrl+Shift+P.
1. Run `RegReplace: Run all` to add comments to possible errors.
1. Review any comments that have appeared within your text.
These comments suggest changes that might be necessary to meet [IX Standards](https://confluence.eng.vmware.com/display/public/IXCS/IX+Content+Standards). They typically follow the pattern `<!--฿ |CORRECT-WORD| is preferred. ฿-->`.
1. Make your changes.

### Tips

1. To delete all instances of a particular Style Checker comment, select one, press Cmd+Shift+L to select all identical comments, and then press Delete.
2. To quickly delete all Style Checker comment in a topic:
   1. Press Cmd+F.
   2. Press Cmd+Option+R to enable regex.
   3. Find `<!--฿[^฿]*฿-->`.
   4. Replace it with nothing.
   5. Repeat for every Style Checker comment. To be safe, go one by one instead of using Replace All.

## Update Style Checker

To update to the latest version, follow one of these procedures:

### Update Style Checker

To update manually:

1. Copy the content of [style-checker-for-reg-replace.json](style-checker-for-reg-replace.json).
2. Start VS Code.
3. If on macOS, press Cmd+Shift+P to open the Command Palette. If on Windows, press Ctrl+Shift+P.
4. Run `Open Settings (JSON)`.
5. Delete your existing Style Checker content.
6. Paste in the new Style Checker content.
7. Save your changes.
8. Restart VS Code.

# Style Checker for Atom

GitHub plans to [sunset Atom on December 15, 2022](https://github.blog/2022-06-08-sunsetting-atom/).
I removed the Style Checker for Atom installation steps.

## Use Style Checker for Atom

1. Open a document you want to edit in Atom.
1. Press F10 or, in the Atom toolbar, click **Packages > HTML Special Character Replacer > Replace Chars** to add comments to possible style errors. If you select a passage of text first, Style Checker runs only on your selected text.
Comments typically follow the pattern `<!-- |CORRECT-WORD| is preferred. -->`.
1. Review any comments that have appeared within your text. These comments suggest changes that might be necessary to meet [IX Standards](https://confluence.eng.vmware.com/display/public/IXCS/IX+Content+Standards).
1. Make your changes.
1. Delete any leftover Style Checker comments by opening Find and Replace, enabling regex for Find, and searching for `<!-- .* -->`. This targets all HTML comments in the topic. Play it safe: go one by one instead of using Replace All.

## Update Style Checker for Atom

To update to the latest Style Checker version, follow one of these procedures:

### Update Style Checker for Atom

To update manually:

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
