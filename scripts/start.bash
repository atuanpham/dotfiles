#!/usr/bin/env bash

SCRIPTPATH=$(cd $(dirname $0); pwd -P) && cd $SCRIPTPATH
GIT_ROOT=$(git rev-parse --show-toplevel)

source $GIT_ROOT/scripts/functions.bash
source $GIT_ROOT/scripts/constants.bash
