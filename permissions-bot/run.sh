#!/usr/bin/env bash

set -ex

bundle install --gemfile=docs-utility-scripts-master/permissions-bot/Gemfile

ruby docs-utility-scripts-master/permissions-bot/app.rb