#!/bin/bash -xe

export PROJECT_ROOT_DIR=`pwd`

# Set up or download tools
./tools/extract-tools.sh

# TODO(rqou): Less hacky
export PATH=$PATH:$PROJECT_ROOT_DIR/tools/arm-toolchain/bin

mkdir -p build

# Run linters
linter_status=0
for tool in cpplint pep8 jshint csslint
do
  ./tools/run-style-tool.py $tool 2>&1 | tee build/${tool}.txt
  linter_status=$[${linter_status} || ${PIPESTATUS[0]}]
done

if [ $linter_status != 0 ] ; then
  exit $linter_status
fi

./waf configure build

# Main build
for dir in angel-player
do
	./$dir/build.sh
done
