// macro
// This is a real use-case of this extension. I had to escape a bunch of strings because the SQL software didn't do it

const file = context.getFile();
let text = "" + file.text; // a hacky way to get autocomplete

const jsonObjectStrings = file.matchAllRanges(/"\{.+\}\n?"/g).map(([start, end]) => {
    return text.substring(start, end).replace(/\s/g, "");
});

const output = context.newFile();

output.setText(jsonObjectStrings.join("\n"));