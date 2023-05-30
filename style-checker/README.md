# Style Checker

Style Checker is a script that adds comments to your document.
The comments flag deviations from
[IX Content Standards](https://confluence.eng.vmware.com/display/public/IXCS/IX+Content+Standards),
passive voice constructions, redundancy, awkward phrasing, and accessibility problems.

Follow these procedures to install Style Checker.

> **Important** Style Checker is only maintained to run through the
> [RegReplace](https://marketplace.visualstudio.com/items?itemName=DomiR.regreplace) extension.
> If you're still using the [Replace Rules extension](https://marketplace.visualstudio.com/items?itemName=bhughes339.replacerules),
> you need to upgrade.

## <a id="prereqs"></a> Prerequisites

- Install [Visual Studio Code (VS Code)](https://code.visualstudio.com/download)
- Install [RegReplace](https://marketplace.visualstudio.com/items?itemName=DomiR.regreplace)

## <a id="add"></a> Add Style Checker to settings.json

To add Style Checker to `settings.json`:

1. Copy the content of [style-checker-for-reg-replace.json](style-checker-for-reg-replace.json).
2. Start VS Code.
3. If on macOS, press Cmd+Shift+P to open the Command Palette. If on Windows, press Ctrl+Shift+P.
4. Run `Open Settings (JSON)`.
5. Paste the content outside the other JSON functions and before the final `}` in this file.
   I recommend placing the content beneath the other functions because of how long it is.
   For an example of the placement, see [example-settings.json](example-settings.json).
6. Save your changes.
7. Restart VS Code.

## <a id="run"></a> Run Style Checker

1. Open a document you want to edit in VS Code.
1. If on macOS, press Cmd+Shift+P to open the Command Palette. If on Windows, press Ctrl+Shift+P.
1. Run `RegReplace: Run all`.
1. Review any comments that have appeared within your text.
   They typically follow the pattern `<!--฿ |CORRECT-WORD| is preferred. ฿-->`.
1. Make your changes and [delete the Style Checker comments](#delete).

## <a id="tshoot"></a> Troubleshooting RegReplace

If you encounter the following error, the extension did not install properly:

```text
Command 'RegReplace: Run all' resulted in an error (command 'regreplace.regreplace' not found)
```

1. Re-install the extension.
2. If that didn't work, re-install the extension once again.
3. If re-installing twice didn't work, install RegReplace v1.3.0 instead:
   1. Click the extensions button on the VS Code side bar.
   2. Click **regreplace**.
   3. Click the down arrow next to the **Uninstall** button, click **Install Another Version...**, and then click **1.3.0** in the drop-down menu.
   4. Click the **Reload Required** button that appears on the extension page.
   5. Repeat the steps in [Configure RegReplace to run multiline searches](#multiline) to edit `regreplace.js` in the new `regreplace-1.3.0` directory.
4. If installing RegReplace v1.3.0 didn't work, switch back to v1.3.1.
5. If switching back to v1.3.1. didn't work, tell Richard Johnson on Slack.

## <a id="multiline"></a> Configure RegReplace to run multiline searches

Some Style Checker commands search across multiple lines.
To configure RegReplace to run multiline searches:

1. On your MacBook, go to

   ```console
   ~/.vscode/extensions/domir.regreplace-VERSION/out/src
   ```

   Where `VERSION` is your RegReplace version, such as `1.3.1` or `1.3.0`.

2. Open `regreplace.js`.
3. Change the line

    ```js
    const reg = command.global === false ? new RegExp(regexQuery) : new RegExp(regexQuery, 'g');
    ```

    to

    ```js
    const reg = command.global === false ? new RegExp(regexQuery, 'm') : new RegExp(regexQuery, 'gm');
    ```

4. Save your change.

## <a id="delete"></a> Delete Style Checker comments

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

## <a id="update"></a> Update Style Checker

To update:

1. Copy the content of the JSON file for your extension, as you did when installing.
2. Start VS Code.
3. If on macOS, press Cmd+Shift+P to open the Command Palette. If on Windows, press Ctrl+Shift+P.
4. Run `Open Settings (JSON)`.
5. Delete your existing Style Checker content.
6. Paste in the new Style Checker content.
7. Save your changes.
8. Restart VS Code.
