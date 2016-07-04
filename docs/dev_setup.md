## Getting help
[![Join our Slack!](https://img.shields.io/badge/slack-join%20us!-e01563.svg)](http://slack.evabot.io)
[![Open issue](https://img.shields.io/badge/report-issue-yellow.svg)](https://github.com/macaullyjames/evabot/issues/new)
[![Edit page](https://img.shields.io/badge/edit-page-lightgrey.svg)](https://github.com/macaullyjames/evabot/edit/master/README.md)

As always, you can ask for help in the #help channel on Slack (the above badge
will take you to a sign-up form if you haven't joined our team already). If
the documentation is incorrect/incomplete and you want to help out then open an
issue in the issue tracker describing the problem. Of course, PRs are welcome
too ❤️

## Setting up a local dev environment
The recommended way to set up a dev environment is to use Virtualbox and
Vagrant to create a virtual machine to work on. This ensures that you're
sharing the same dev environment as the rest of the core team (no missing
packages etc.) and isolates the rest of your machine from whatever dependencies
Eva requires. More importantly it means that you can be productive without
having to learn how to set up and configure a server, which is awesome. 

Setup is (should be?) pretty straightforward:

1. Clone the repo
2. Install [VirtualBox](https://www.virtualbox.org) and
   [Vagrant](https://www.vagrantup.com/downloads.html)
3. Run `vagrant up` in the root folder of the repo

This should work on Mac, Linux, Windows and any other platform you can install
VirtualBox on. Installing everything takes a while so you might want to grab
some ☕️ while you're waiting. After setup is complete the Eva web interface will
be available at [http://localhost:3000](http://localhost:3000).

### macOS / OS X
If you run macOS (formerly called OS X) you can use 
[Homebrew](http://brew.sh/) for super easy setup. After cloning, run the
following from the root of the repo:

```bash
brew cask install virtualbox
brew cask install vagrant
vagrant up
```

The web interface will magically appear in your default web browser when setup
is complete. 

