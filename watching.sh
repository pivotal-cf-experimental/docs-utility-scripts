# Ad hoc script from Cloud Ops to ping one of our pages for relevant downtime info
while true
do
  echo $(date +"%T") >> log.txt
  curl http://docs.pivotal.io/pivotalcf/1-8/installing/pcf-docs.html | tail -2 >> log.txt
  echo " " >> log.txt
done