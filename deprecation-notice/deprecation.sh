# add deprecation partial to all files in current directory

for file in $(find . -type f -name "*.html.md.erb"); 
do
  awk '/---/{x++} x==2{sub(/---/,"&\n\n<%= partial '\''../pcf/core/deprecation-notice'\'' %>")}1' $file > ${file}.tmp
  mv ${file}.tmp $file
done
 