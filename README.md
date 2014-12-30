# Bookmark using Bash

A simple script to save bookmarks (folders)

## Usage

There's three flags:
* 'g <alias>' => go to the path corresponding to the alias
* 's <alias>' => save the actual path with name <alias>
* 'd <alias>' => delete the bookmark with name alias
* 'l'         => list all bookmarks

## Bash Completion

Put the bash completion file somewhere (my in $HOME/.bash_completion.d)

And add to your bash_profile:

. <bashcompletionpath>

And vualá!
