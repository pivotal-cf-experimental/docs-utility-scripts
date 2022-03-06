# Run this script within the book repo for your target docs.

configure_for_docworks () {
  git pull
  
  # Requesting a Taxonomy Entry Section
  
  # Search the Product Name database for the name you want to use.
  # If it's found, proceed.
  # Otherwise, populate the form. (The form must update some file somewhere: we just need direct access to that file from the CLI.)
  
  
  # Create Markdown Project Section
  
  # Much like with the taxonomy form, we just need to bypass the website (in this case DocWorks) and enter values from the CLI through this script.
  
  
  # Configure Sources and Metadata Section
  
  # Much like with the taxonomy form, we just need to bypass the website (in this case DocWorks) and enter values from the CLI through this script.
  # The need for a GitHub token could be an obstacle, but why not create a shared one that we all use? We can put that in this script.
  
  # Create Landing Page Section
  
  # Much like with the taxonomy form, we just need to bypass the website (in this case DocWorks) and enter values from the CLI through this script.

  # Create toc.md Section
  
  cd master_middleman/source/subnavs
  find . -iregex ".*\.erb" -exec cp {} /../../../ \; # copy the subnav file to top directory
  for file in *.erb; do mv "$file" "${file%%.erb}toc.md.erb"; done # rename subnav file as `toc.md.erb`
  cd ../../..
  # Convert ERB content in toc.md to Markdown. Call some tool, maybe, or just write several careful find & replace commands.

  # Update Redirects Section
  
  # Copy the redirects file and rename the copy "new-redirects".
  # Updating some redirects is as simple as replacing "docs.pivotal.io" with "docs.vmware.com"
  # Some are unique and require tweaking this script a little for the needs of the repo.
  # You run finisher.sh after verifying the migration was successful. finisher.sh deletes "redirects.md" and renames "new-redirects.md" as "redirects.md".
 
  echo "The relevant docs are configured for a Markdown Project in DocWorks. Run finisher.sh after verifying the migration was successful."
  
}
