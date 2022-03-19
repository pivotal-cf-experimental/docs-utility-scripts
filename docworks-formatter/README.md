# DocWorks Formatter

DocWorks Formatter changes the formatting within a document to meet the specifications of DocWorks.
The changes are mostly proper indentation and spacing for GitHub Flavored Markdown (GFM), but also
includes workarounds for DocWorks formatting bugs.

## Prerequisite

[Atom](https://atom.io/)


## <a id="install"></a> Install DocWorks Formatter

To install DocWorks Formatter:

1. Install the Atom package
[HTML Special Character Replacer](https://atom.io/packages/html-special-character-replacer).
1. Copy the contents of [docworks-formatter.js](docworks-formatter.js).
1. Launch Atom.
1. In the Atom toolbar go to **Atom > Preferences**.
1. Click **Open Config Folder** in the side tab.
1. In the **Project** directory tree go to
**packages > html-special-character-replacer > lib > html-special-character-replacer.js**.
1. Delete the content.
1. Paste in the content that you copied from
[docworks-formatter.js](docworks-formatter.js) in this repository.
1. Save your changes to `html-special-character-replacer.js`.
1. Restart Atom.


## <a id="configure-bash"></a> (Optional) Configure your bash profile to enable fast updates

To configure your bash profile so that you can update DocWorks Formatter with a single command:

1. Add the following to your bash profile:

    ```
    update_dwf () {
      cd ~/workspace/docs-utility-scripts/docworks-formatter
      git pull
      cd ~/.atom/packages/html-special-character-replacer/lib
      cat ~/workspace/docs-utility-scripts/docworks-formatter/docworks-formatter.js > html-special-character-replacer.js
      echo "DocWorks Formatter was updated."
      cd ~/workspace
    }
    ```

1. Save your profile.
1. Restart the terminal.


## Update DocWorks Formatter

To update to the latest DocWorks Formatter version, follow one of these procedures:


### Update DocWorks Formatter from the CLI

To update DocWorks Formatter from the CLI:

1. If you have not already done so, [Configure your bash profile to enable fast updates](#configure-bash).
1. From the CLI, run:

    ```
    update_dwf
    ```

    > **Note:** This command is also useful for replacing Style Checker content.
    > The fastest way to switch from Style Checker to DocWorks Formatter is to run `update_dwf`.
    > The fastest way to switch from DocWorks Formatter to Style Checker is to run `update_style`.


### Update DocWorks Formatter manually

To update DocWorks Formatter manually:

1. Copy the contents of
[docworks-formatter.js](docworks-formatter.js).
1. Launch Atom.
1. In the Atom toolbar go to **Atom > Preferences**.
1. Click **Open Config Folder** in the side tab.
1. In the **Project** directory tree go to
**packages > html-special-character-replacer > lib > html-special-character-replacer.js**.
1. Delete the content.
1. Paste in the content that you copied from
[docworks-formatter.js](docworks-formatter.js). in this repository.
1. Save your changes to `html-special-character-replacer.js`.
1. Restart Atom.


## Use DocWorks Formatter

1. Open a document you want to edit in Atom.
1. Press F10 or, in the Atom toolbar, click **Packages > HTML Special Character Replacer > Replace Chars**
to change the formatting within the document.

> **Warning:** DocWorks Formatter is still in development and might have issues.
> I recommend confining your DocWorks Formatter changes to a single dedicated commit so that you can
> easily revert the changes without undoing any other work.
