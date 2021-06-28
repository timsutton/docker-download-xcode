# shellcheck shell=bash

# what we'll tag the download image
export docker_tag=download-xcode

# since output_path is being passed into a docker -v arg, it needs an absolute path and not a relative one.
export output_path="$(pwd)/output"
