#!/bin/bash

# Will be removed once we start developing upstream.

set -eux

# Clone PR
mkdir -p /tmp/go
export GOPATH=/tmp/go
export PATH=$PATH:$GOPATH/bin
# Unfortunately go get is broken for acs-engine
# See https://github.com/Azure/acs-engine/issues/1160
go get github.com/Azure/acs-engine || true
cd /tmp/go/src/github.com/Azure/acs-engine
git config user.email "openshift-ci-robot@ci.openshift.org"
git config user.name "openshift-ci-robot"
git remote set-url origin https://github.com/kargakis/acs-engine
git fetch origin
git checkout origin/master
git fetch origin pull/${PULL_NUMBER}/head
git merge FETCH_HEAD

# Test
make bootstrap
make test-style
make build-binary
make test
