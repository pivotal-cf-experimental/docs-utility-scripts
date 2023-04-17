// macro
// read documentation for injected objects like 'file', 'context', etc on the extension page

const file = context.getFile();
let text = "" + file.text;  // a hacky way to get autocomplete

// let's say you wrote this real quick and didn't care for readability
text = [...new Set(text.replace(/\r/g, "").split("\n"))].join("\n");

file.setText(text);