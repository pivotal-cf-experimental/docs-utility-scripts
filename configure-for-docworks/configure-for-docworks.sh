# Run this script within the book repo for your target docs.

configure_for_docworks () {
  git pull

  # Create toc.md
  cd master_middleman/source/subnavs
  find . -iregex ".*\.erb" -exec cp {} /../../../ \; # copy the subnav file to top directory
  for file in *.erb; do mv "$file" "${file%%.erb}toc.md"; done # rename subnav file as `toc.md`
  # Write line here to convert ERB content in toc.md to Markdown. Call some tool maybe.

  # The finish line
  echo "The relevant docs are configured for a Markdown Project in DocWorks."
}
