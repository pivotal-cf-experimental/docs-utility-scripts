# Style Checker

Style Checker is a re-purposed package for the text editor Atom. It is used for flagging style errors in documents.

## Prerequisite

[Atom text editor](https://atom.io/)

## How to Install

  1. Install the Atom package [HTML Special Character Replacer](https://atom.io/packages/html-special-character-replacer).
  1. Launch Atom.
  1. In the Atom toolbar go to **Atom > Preferences**.
  1. Click **Open Config Folder** in the side tab.
  1. In the **Project** folder tree go to **packages > html-special-character-replacer > lib > html-special-character-replacer.js**.
  1. Replace all the code between `function doreplacement(text) {` and `return text;` with the [style comment commands](https://docs.google.com/document/d/18uGgQdkapGHqkel7GQkwxWbpbla8lwQqOFgBkpyPFYw).
  1. Save your changes to `html-special-character-replacer.js`.
  1. Restart Atom.

## How to Use

  1. Open a document you want to edit in Atom.
  1. Press F10 or, in the Atom toolbar, click **Packages > HTML Special Character Replacer > Replace Chars** to add comments to possible style errors.
  1. Review any comments that have appeared within your text. These comments suggest changes that might be necessary to fit the Pivotal writing style.
