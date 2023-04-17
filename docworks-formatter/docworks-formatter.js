var doreplacement;

module.exports = {
	activate: function() {
		return atom.commands.add('atom-text-editor', 'html-special-character-replacer:replace', function() {
			var editor;
			editor = atom.workspace.getActiveTextEditor();
			return replace(editor);
		});
	}
};

function replace(editor)
{

	var text;

	if (editor.getSelectedText()) {

		text = editor.getSelectedText();
		return editor.insertText(doreplacement(text));

	} else {

		text = editor.getText();
		return editor.setText(doreplacement(text));

	}

}

function doreplacement(text)
{

  // Replace tags for single-line ERB comments with Markdown comment tags
	
  // Fix code snippet formats

  text = text.replace(/```bash\b/gm,'```console');
  text = text.replace(/```sh\b/gm,'```console');
  text = text.replace(/```shell\b/gm,'```console');
  text = text.replace(/\<pre class=.terminal.\>([^\<]*)\<\/pre\>/gm,'```console$1```');
  text = text.replace(/```console([^`\n]*)```/gm,'```console\n$1\n```');
  text = text.replace(/```\s*\$/gm,'```console\n$');
  // [Replace ``` with ```yaml if you can do so reliably]
  // [Search for other common language identifiers you can maybe safely add]

  // [Replace asterisk and plus-sign bulletpoints with dashes because of a DocWorks bug]

  // Add missing newlines

  text = text.replace(/^([^\-\+\*\n].*)\n([\-\+\*].*\n[\-\+\*].*)/gm,'$1\n\n$2');
  // [Insert newline above code snippet if missing]
  text = text.replace(/```\w+\n([^`]*)\n```\n([^\n])/gm,'```\w+\n$1\n```\n\n$2');

  // Fix broken partial formatting

  text = text.replace(/\<%=\spartial\s"([^"]*)"\s%\>/gm,'<%= partial \'$1\' %>');

  // Remove newlines within bullets

  text = text.replace(/^(\s*[\*\-\+].*)\n([^\n\*\-\+].*)/gm,'$1 $2');
  text = text.replace(/^(\s*[\*\-\+].*)\n([^\n\*\-\+].*)/gm,'$1 $2');
  text = text.replace(/^(\s*[\*\-\+].*)\n([^\n\*\-\+].*)/gm,'$1 $2');
  text = text.replace(/^(\s*[\*\-\+].*)\n([^\n\*\-\+].*)/gm,'$1 $2');
  text = text.replace(/^(\s*[\*\-\+].*)\n([^\n\*\-\+].*)/gm,'$1 $2');

  // [Change <p class="note"> and similar]

  return text;

};
