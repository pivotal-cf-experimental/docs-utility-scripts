# Not tested yet
fly pause-pipeline -p pubtools -t pubtools
fly pause-pipeline -p sample-apps -t pubtools
fly pause-pipeline -p test-dummy -t pubtools
fly pause-pipeline -p cf-previous-versions -t pubtools
fly pause-pipeline -p data-docs -t pubtools
fly pause-pipeline -p cf-previous-versions -t pubtools
fly pause-pipeline -p cf-edge -t pubtools

sleep 180

bosh target 52.1.206.54:25555

bosh deployment ~/workspace/concourse-docs-deployment/artifacts/deployments/concourse.yml

bosh login $BOSH_USER $BOSH_PASSWORD

##SET ENVs in the cf app environment
##BOSH_USER: pubtools
##BOSH_PASSWORD: documentariansanonymous

echo yes | bosh stop worker --hard
bosh stop atc 

echo $DIRECTOR_KEY >> id_rsa_bosh

bosh ssh postgresql/0 --gateway_host 52.1.206.54 --gateway_user vcap --gateway_identity_file id_rsa_bosh

/var/vcap/packages/postgresql_9.3/bin/psql REPLACE_ME REPLACE_ME <<EOF
\x
DELETE FROM containers;
DELETE FROM volumes;
DELETE FROM workers;
\q
EOF

exit

echo yes | bosh start

fly unpause-pipeline -p pubtools -t pubtools
fly unpause-pipeline -p sample-apps -t pubtools
fly unpause-pipeline -p test-dummy -t pubtools
fly unpause-pipeline -p cf-previous-versions -t pubtools
fly unpause-pipeline -p data-docs -t pubtools
fly unpause-pipeline -p cf-previous-versions -t pubtools
fly unpause-pipeline -p cf-edge -t pubtools

