# Style Checker

Style Checker comments on style errors described in the [Word and Phrase List](https://docs.google.com/spreadsheets/d/1hkadtxR1hY57kK7h5HN4ITHLJleZixCDH_RJPUpNq_A/edit#gid=0).

## Prerequisite

[Atom text editor](https://atom.io/) or [Sublime](https://www.sublimetext.com/3)

## Atom Instructions

### How to Install in Atom

  1. Install the Atom package [HTML Special Character Replacer](https://atom.io/packages/html-special-character-replacer).
  1. Launch Atom.
  1. In the Atom toolbar go to **Atom > Preferences**.
  1. Click **Open Config Folder** in the side tab.
  1. In the **Project** folder tree go to **packages > html-special-character-replacer > lib > html-special-character-replacer.js**.
  1. Replace all the code between `function doreplacement(text) {` and `return text;` with the [style comment commands](https://github.com/pivotal-cf-experimental/docs-utility-scripts/blob/master/style-checker/html-special-character-replacer.js).
  1. Save your changes to `html-special-character-replacer.js`.
  1. Restart Atom.

### How to Update in Atom

To update to the latest Style Checker version, perform step 2 onwards from the installation steps above or:

1. Add the following to your bash profile:
  
    ```
    update_style () {
      cd ~/workspace/docs-utility-scripts/style-checker
      git pull
      cd ~/.atom/packages/html-special-character-replacer/lib
      cp ~/workspace/docs-utility-scripts/style-checker/html-special-character-replacer.js .
      echo "Style Checker updated."
    }
    ```
 
1. Save and restart your terminal windows.

1. When you want to update Style Checker, run ```update_style```.


### How to Use in Atom

  1. Open a document you want to edit in Atom.
  1. Press F10 or, in the Atom toolbar, click **Packages > HTML Special Character Replacer > Replace Chars** to add comments to possible style errors. Comments typically follow the pattern "<%# "....." is preferred. %>".
  1. Review any comments that have appeared within your text. These comments suggest changes that might be necessary to fit the Pivotal writing style.
  
  
## Sublime Instructions

### How to Install in Sublime

1. Install the Sublime package [RegReplace](https://facelessuser.github.io/RegReplace/installation/).
1. Launch Sublime.
1. In the Sublime toolbar go to **Sublime > Preferences > Package Settings > RegReplace > Rules - User**.
1. Replace the contents of the file with the [Style Checker rules](https://github.com/pivotal-cf-experimental/docs-utility-scripts/blob/master/style-checker/reg_replace_rules.sublime_settings).
1. Save your changes and close the file.
1. In the Sublime toolbar go to **Sublime > Preferences > Package Settings > RegReplace > Commands - User**.
1. Replace the contents of the file with the [Style Checker commands](https://github.com/pivotal-cf-experimental/docs-utility-scripts/blob/master/style-checker/Default.sublime-commands).
1. Save your changes and close the file.

### How to Update in Sublime

To update to the latest Style Checker version, perform step 2 onwards from the installation steps above or:

1. Add the following to your bash profile:
  
    ```
    update_style () {
      cd ~/workspace/docs-utility-scripts/style-checker
      git pull
      cd ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/RegReplace.sublime-package ## add the rest here and remember that Sublime 2 differs
      cp ~/workspace/docs-utility-scripts/style-checker/Default.sublime-commands
      cp ~/workspace/docs-utility-scripts/style-checker/reg_replace_rules.sublime_settings
      echo "Style Checker updated."
    }
    ```
 
1. Save and restart your terminal windows.

1. When you want to update Style Checker, run ```update_style```.

### How to Use in Sublime

  1. Open a document you want to edit in Sublime.
  1. Press **Shift+Command+P** or click **Tools > Command Palette...** to open Command Palette.
  1. Type `style` and then click **Run Style Checker** when it appears in the Command Palette dropdown to add comments to possible style errors. 
  Comments typically follow the pattern "<%# |...| is preferred. %>".
  1. Review any comments that have appeared within your text. These comments suggest changes that might be necessary to fit the house writing style.
