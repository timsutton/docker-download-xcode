#!/bin/bash

set -eu -o pipefail

source scripts/common.sh

docker run \
  --entrypoint /bin/bash \
  -it \
  --volume "${output_path}":/app/download \
  --workdir /app \
  --env FASTLANE_USER \
  --env FASTLANE_PASSWORD \
  --env FASTLANE_SESSION \
  "${docker_tag}"
