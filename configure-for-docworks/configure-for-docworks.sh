configure_for_docworks_1 () {
  
  # Run this function within the book repo for your target docs.
  
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
  for file in *.erb; do mv "$file" "${file%%.erb}toc.md"; done # rename subnav file as `toc.md`
  cd ../../..
  # Convert ERB content in toc.md to Markdown. Call some tool, maybe, or just write several careful find & replace commands.

  # Update Redirects Section
  
  cd docs-book-PRODUCT-NAME
  # Paste the following content into redirects.rb, but replace the "build-service" values as appropriate
  
  # Redirect from docs.pivotal.io/build-service/1-1 to docs.vmware.com build service docs

  # r301  %r{/build-service/1-1/index.html}, "https://docs.vmware.com/en/Tanzu-Build-Service/1.1/vmware-tanzu-build-service-v11/GUID-docs-build-service-index.html"
  # r301  %r{/build-service/1-1/}, "https://docs.vmware.com/en/Tanzu-Build-Service/1.1/vmware-tanzu-build-service-v11/GUID-docs-build-service-index.html"
  # r301  %r{/build-service/1-1}, "https://docs.vmware.com/en/Tanzu-Build-Service/1.1/vmware-tanzu-build-service-v11/GUID-docs-build-service-index.html"
  # r301  %r{/build-service/1-1/(.*)}, "https://docs.vmware.com/en/Tanzu-Build-Service/1.1/vmware-tanzu-build-service-v11/GUID-$1"
  
  # Change Docs Formatting Section
  
  cd ../docs-PRODUCT-NAME
  # Run regex-based sed commands to find and replace the easy formatting errors:
  
  # Find: <pre class=.terminal.>([^<]*)</pre>         Replace: ```console$1```
  # Find: ```console([^`\n]*)```                      Replace: ```console\n$1\n```
  # Find ```console\n([^`]*)\n```\n([^\n])            Replace: ```console\n$1\n```\n\n$2
  # Find: ```\s*\$                                    Replace: ```console\n$
  # Find: Where:[^\n]*\n([^\n]*\*)\s`                 Replace: Where:\n\n$1 `
  # Find: \<%=\spartial\s"([^>]*)"\s%\>               Replace: <%= partial '$1' %>
 
  echo "The relevant docs are configured for a Markdown Project in DocWorks. Run configure_for_docworks_2.sh after verifying the migration was successful."
  
}

configure_for_docworks_2 () {

  # This function runs commands to make the migrated pages discoverable after you verify that the new pages on VMware look good.
  
  # Update Pivotal Landing Page Section
  # Change relevant values in https://github.com/pivotal-cf/docs-book-pcfservices/edit/master/master_middleman/source/index.html.erb.
  # You need to plug your own values in here (likely just the product name for the docs repo you're dealing with).
  
  # Make New Redirects Live Section
  # Run production for the book repo from the CLI (see https://docs-wiki.tas.vmware.com/wiki/pipelines/pushing-to-production.html)
  
  echo "The redirects are live and the Pivotal landing page is updated."

}
