#!/usr/bin/env bash

set -ex

bundle install

ruby get-stemcells.rb