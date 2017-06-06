# Dotfiles

OSX / Ubuntu / Fedora / KaliLinux / Debian dotfiles.
Is a fork from "Cowboy" Ben Alman.
And more inspiration by jfrazelle

## Be careful

It is advisable to run this script on a newly installed operating system, because it changes the terminal and other features that you may have changed in the system.

## About this project

I've been using bash on-and-off for a long time (since Slackware Linux was distributed on 1.44MB floppy disks). In all that time, every time I've set up a new Linux or OS X machine, I've copied over my `.bashrc` file and my `~/bin` folder to each machine manually. And I've never done a very good job of actually maintaining these files. It's been a total mess.

I finally decided that I wanted to be able to execute a single command to "bootstrap" a new system to pull down all of my dotfiles and configs, as well as install all the tools I commonly use. In addition, I wanted to be able to re-execute that command at any time to synchronize anything that might have changed. Finally, I wanted to make it easy to re-integrate changes back in, so that other machines could be updated.

That command is [dotfiles][dotfiles], and this is my "dotfiles" Git repo.

[dotfiles]: bin/dotfiles

## Hacking my dotfiles

Because the [dotfiles][dotfiles] script is completely self-contained, you should be able to delete everything else from your dotfiles repo fork, and it will still work. The only thing it really cares about are the `/copy`, `/link` and `/init` subdirectories, which will be ignored if they are empty or don't exist.

If you modify things and notice a bug or an improvement, [file an issue](https://github.com/ricardorsierra/dotfiles/issues) or [a pull request](https://github.com/ricardorsierra/dotfiles/pulls) and let me know.

Also, before installing, be sure to [read my gently-worded note](#heed-this-critically-important-warning-before-you-install).

## Inspiration
<https://github.com/cowboy/dotfiles>
<https://github.com/jfrazelle/dotfiles>  
<https://github.com/gf3/dotfiles>  
<https://github.com/mathiasbynens/dotfiles>  
(and 15+ years of accumulated crap)
