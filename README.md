

[![Gitter](https://badges.gitter.im/ez-cli.svg)](https://gitter.im/ez-cli?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

# ez (CLI Command / Toolkit)
Shell scripting to automate all the eZ Platform things! I'm working on updates
and fixes to our installation documentation at
https://doc.ez.no/display/DEVELOPER/Step+1%3A+Installation
and, of course, manually testing the steps to make sure they're correct. :)

## Purpose
I'm installing eZ Platform from scratch on fresh servers over and over again.
These are the things I typed by hand the first few times, collected into
scripts. This is NOT an official eZ project, is NOT recommended for production
or use of any kind, and is in a highly embryonic state.

## Potential
CLI automation is a powerful enablement feature for any platform. I'd like to
explore what's possible, inspired by past and present efforts from others, and
in a public (but personal) space where I can create things the way that I'd like
to do them.

Eventually, I'd love to flesh this out into a full DX toolkit, in the spirit
of Symfony's installer (https://github.com/symfony/symfony-installer), the
console project (https://github.com/symfony/console), Platform.sh's CLI tooling
(https://github.com/platformsh/platformsh-cli), Heroku's CLI tooling
(https://github.com/heroku/heroku),
Drush (https://github.com/drush-ops/drush), and others. It would be great to
have CLI superpowers surrounding all things eZ. For right now, I'm just adding
whatever steps I'd be typing by hand so I can curl them as a single script and
run them on fresh servers. Down the road I may add functionality around existing
installations to manage/inspect.

@plopix has a great Docker toolkit that wraps things up in a nice, tidy, usable
way. Things like this could be orchestrated together and run with a wrapping
command like `ez`. This repo is my take on what that could look like.

UPDATE: There's a new project called LaunchPad from Plopix/eZ Systems which also
uses the `ez` command name; this repo here predates those tools and is my own
unrelated project.

## Problems
These first baby scripts aren't meant for anything other than my very narrow
personal use case, so it isn't very practical for others to _run_. The steps
contained in the scripts are perfectly valid reference material for those doing
some or all of the same things.

## Inspiration
I love using ohmyz.sh, nvm, rvm, and other such tools. I like how they're
organized, and I think they're cool. :)

## Primary Story
As a Developer, I want to be able to type `ez *` where * is a command, and get
fast and reliable results on common tasks when working with eZ Platform and its
surrounding technologies, so that I can save time and ensure consistency among
different instances.
