#!/usr/bin/env bash

set -ex

bundle install --gemfile=docs-utility-scripts/stemcell-rn-bot/Gemfile

ruby get-stemcells.rb