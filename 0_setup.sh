#!/bin/sh

./docker/script.sh
./nvidia/script.sh

pushd ./images/anbase/repo
./down.sh
popd
