# add deprecation partial to all files in current directory

cd $1
for file in $(find . -type f -name "*.html.md.erb"); 
do
  awk '/^---$/{x++} x==2{sub(/---/,"&\n<%= partial '\''/pcf/deprecation-notice'\'' %>")}1' $file > ${file}.tmp
  mv ${file}.tmp $file
done
 