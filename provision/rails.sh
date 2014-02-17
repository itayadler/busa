#!/usr/bin/env bash

pushd /vagrant
bundle
rake db:create
rake db:setup
popd
