#!/bin/bash
set -e
set -o pipefail

echo "========================================="
echo "Starting"
echo "========================================="

pushd $APP_HOME
go-hello
popd
