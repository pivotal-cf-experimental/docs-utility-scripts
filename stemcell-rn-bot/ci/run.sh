#!/usr/bin/env bash

set -ex

pushd docs-stemcell-rn/ci
	bundle install
	ruby get-stemcells.rb > ../stemcells.html.md.erb

	if [[ -n $(git status --porcelain) ]]; then
		git config user.name "Stemcell Release Notes Bot"
		git config user.email "cf-docs@pivotal.io"
		git add --all :/
		git commit -m "Updating stemcells markdown file"
	fi
popd

shopt -s dotglob
cp -R "docs-stemcell-rn/." "updated-docs-stemcell-rn/"
