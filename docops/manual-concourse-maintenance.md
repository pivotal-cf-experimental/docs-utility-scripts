// pause pipelines and let them finish
fly pipelines pause-pipeline
(wait 60 - 180 sec)

$ fly pause-pipeline -p pubtools -t pubtools
$ fly pause-pipeline -p sample-apps -t pubtools
$ fly pause-pipeline -p test-dummy -t pubtools
$ fly pause-pipeline -p cf-previous-versions -t pubtools
$ fly pause-pipeline -p data-docs -t pubtools
$ fly pause-pipeline -p cf-previous-versions -t pubtools
$ fly pause-pipeline -p cf-edge -t pubtools
$ bosh target 52.1.206.54:25555

$ bosh deployment PATH-TO-LOCAL-DEPLOYMENT-MANIFEST

$ bosh login $BOSH_USER $BOSH_PASSWORD

$ bosh stop worker --hard
(wait 20 seconds)
$ yes
$ bosh stop atc 

$ echo $DIRECTOR_KEY >> id_rsa_bosh

$ bosh ssh postgresql/0 --gateway_host 52.1.206.54 --gateway_user vcap --gateway_identity_file id_rsa_bosh

[ #from Gregg
ssh-add ~/workspace/concourse-docs-deployment/artifacts/keypair/id_rsa_bosh
bosh ssh postgresql/0 --gateway_host 52.1.206.54 --gateway_user vcap
]
## For after ssh'ing into postgresql/0, to get into the PG console, run:

$ /var/vcap/packages/postgresql_9.3/bin/psql REPLACE_ME REPLACE_ME

wait 10

$ DELETE FROM containers;
$ DELETE FROM volumes;
$ DELETE FROM workers;

$ \q #to exit
$ exit

$ bosh start
(wait 10 seconds)
$ yes
(bosh cck may also restart them and yet may not do what we want)
// unpause pipelines

$ fly unpause-pipeline -p pubtools -t pubtools
$ fly unpause-pipeline -p sample-apps -t pubtools
$ fly unpause-pipeline -p test-dummy -t pubtools
$ fly unpause-pipeline -p cf-previous-versions -t pubtools
$ fly unpause-pipeline -p data-docs -t pubtools
$ fly unpause-pipeline -p cf-previous-versions -t pubtools
$ fly unpause-pipeline -p cf-edge -t pubtools
