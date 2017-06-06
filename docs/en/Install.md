## Installation

### OS X Notes

You need to have [XCode](https://developer.apple.com/downloads/index.action?=xcode) or, at the very minimum, the [XCode Command Line Tools](https://developer.apple.com/downloads/index.action?=command%20line%20tools), which are available as a much smaller download.

The easiest way to install the XCode Command Line Tools in OSX 10.9+ is to open up a terminal, type `xcode-select --install` and [follow the prompts](http://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/).

_Tested in OSX 10.10_

### Linux Notes

You might want to set up your ubuntu server [like I do it](https://github.com/ricardorsierra/dotfiles/wiki/ubuntu-setup), but then again, you might not.

Either way, you should at least update/upgrade APT with `sudo apt-get -qq update && sudo apt-get -qq dist-upgrade` first.

_Tested in Ubuntu 14.04 LTS_
_Tested in Ubuntu 16.10 LTS_
_Tested in KaliLinux 16.10 LTS_

### Installation

1. [Read my gently-worded note](#heed-this-critically-important-warning-before-you-install)
1. Open a terminal/shell and do this:

```sh
bash -c "$(curl -fsSL https://raw.github.com/ricardorsierra/dotfiles/master/bin/dotfiles)" && source ~/.bashrc
```
