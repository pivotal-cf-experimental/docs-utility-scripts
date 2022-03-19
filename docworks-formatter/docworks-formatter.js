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

  // Last updated: March 15, 2022

  text = text.replace(/(<pre class=.terminal.>([^<]*)</pre>)/gm,'```console$1```');
  text = text.replace(/(```console([^`\n]*)```)/gm,'```console\n$1\n```');
  text = text.replace(/(```console\n([^`]*)\n```\n([^\n]))/gm,'```console\n$1\n```\n\n$2');
  text = text.replace(/(```\s*\$)/gm,'```console\n$');
  text = text.replace(/(Where:[^\n]*\n([^\n]*\*)\s`)/gm,'Where:\n\n$1 `');
  text = text.replace(/(\<%=\spartial\s"([^>]*)"\s%\>)/gm,'<%= partial '$1' %>');

  return text;

};
