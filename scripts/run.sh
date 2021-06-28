#!/bin/bash

set -eu -o pipefail

source scripts/common.sh

xcode_version="${1}"

docker run \
  --volume "${output_path}":/app/download \
  --workdir /app \
  --env FASTLANE_USER \
  --env FASTLANE_PASSWORD \
  --env FASTLANE_SESSION \
  "${docker_tag}" \
  bundle exec ruby download.rb "${xcode_version}"
