# docker-download-xcode

**NOTE:** Xcode 13's xip archive uses a format that's incompatible with this method. This is documented in the [Xcode 13 release notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-13-release-notes) (`Note: Other methods of expanding the archive may produce a broken Xcode app. (78714333)`) I haven't personally done any investigation as to fixing this.

A very much work-in-progress tool to help make fetching new Xcodes easier whether on macOS or Linux.

The approach is very similar to that of [XcodeInstall](https://github.com/xcpretty/xcode-install), except we obtain the download URLs via https://xcodereleases.com because:

* they are well-maintained, and quickly updated as new betas/release versions are released by Apple
* grabbing a download URL out of their JSON feed is simpler and less prone to breakage than needing to parse Apple's developer pages
* there is additional useful metadata not exposed by Apple at the feed level:
  * the specific beta versions as well as build versions
  * minimum required OS versions (equivalent of the `LSMinimumSystemVersion` Info plist key)
  * compiler versions
  * SHA-1 checksums of the .xip files

Ultimately I'm hoping to integrate this into an Xcode archiving-and-repackaging workflow that doesn't explicitly require macOS, using an approach like that of [docker-xip](https://github.com/timsutton/docker-xip).

## Setup

### From Docker:

Build a local docker image:

```
scripts/build.sh
```

It will need ADC credentials in order to retrieve Xcodes from the ADC portal. We can generate some persistent ADC credentials using [Fastlane Spaceship](https://github.com/fastlane/fastlane/tree/master/spaceship). One way to do this is via `fastlane spaceauth -u your@adc.login.email.com` using the docker image we just built:

```
# using -it to run this interactively because it will prompt for a password and (likely) 2FA
docker run -it download-xcode fastlane spaceauth -u your@adc.login.email.com
```


Copy-paste the `export FASTLANE_SESSION='...'` output. You'll also need to export `FASTLANE_USER=your@adc.login.email.com`, and in my testing, a dummy password value for the password. The password bit might just be me holding Fastlane/Spaceship wrong.

```
export FASTLANE_USER=your@adc.login.email.com
export FASTLANE_PASSWORD=nope
export FASTLANE_SESSION='<output copy/pasted from `fastlane spaceauth`>'
```

### Locally:

If you want to use an existing local Ruby environment or not bother with Docker, you can simply run this locally:

```
# change to desired Ruby version
bundle install
bundle exec ruby app/download.rb <version>
```

## Usage

Just run the docker image given an Xcode version as an argument: 
```
scripts/run.sh 12.5.1
```

No beta versions supported yet.
