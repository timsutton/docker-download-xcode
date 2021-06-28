# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

require 'spaceship'

DOWNLOAD_DIR = 'download'
COOKIE_JAR_PATH = '/tmp/cookies.txt'

def xcode_releases_data
  uri = URI.parse('https://xcodereleases.com/api/all.json')
  response = Net::HTTP.get_response(uri)
  JSON.parse(response.body)
end

def handle_args
  if ARGV[0].nil?
    $stderr.write "This script expects an Xcode version as a first argument, i.e. '12.5.1'\n"
    exit 1
  end
  # for now assuming only versions like '12.5.1' will work, betas will need a bit more intelligence
  $desired_version = ARGV[0]
end

def login!
  Spaceship.login
  $spaceship_client = Spaceship.client
end

handle_args
login!

all_versions = xcode_releases_data

found = nil
all_versions.each do |ver|
  found = ver if ver['version']['number'] == $desired_version
end

unless found
  $stderr.write "Found no Xcode version matching #{$desired_version}, exiting\n"
  exit 1
end

download_uri = URI.parse(found['links']['download']['url'])
# TODO: assemble this query properly by building it with the URI lib
real_url = "https://developer.apple.com/services-account/download?path=#{download_uri.path}"

# TODO: improve this sanity check about the directory construction
if File.exist?(DOWNLOAD_DIR) && !File.directory?(DOWNLOAD_DIR)
  $stderr.write "Download dir #{DOWNLOAD_DIR} exists but isn't a directory. Exiting for safety."
  exit 1
end

FileUtils.mkdir_p unless File.directory?(DOWNLOAD_DIR)

output_dest = File.join(DOWNLOAD_DIR, 'xcode.xip')
curl_cmd = [
  'curl',
  '--disable',
  '--location',
  '--fail',
  '--retry', '5',
  '--continue-at', '-',
  '--output', output_dest,
  '--cookie', $spaceship_client.cookie,
  # TODO: lifted this cookie-jar bit from XcodeInstall, I don't yet know why it seems necessary though
  '--cookie-jar', COOKIE_JAR_PATH,
  real_url
]

system(*curl_cmd)
FileUtils.rm_f COOKIE_JAR_PATH
