#!/bin/bash

set -eu -o pipefail

source scripts/common.sh

docker build -t "${docker_tag}" .
