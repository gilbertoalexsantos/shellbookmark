# Bookmark using Bash

A simple script in bash to quickly access bookmarks.

## Configuration

The bookmarks will be stored in $HOME/.mybookmark.

Put the script wherever you want (probably in /user/local/bin/).

You'll need to execute the script with a dot before the script, like that:

>. b

It's horrible to always type the dot... You can set a alias in your bash\_profile.
You'll just need to put in your [.bash\_profile | .bashrc | .profile]:

> alias b=". b"

And then you can execute the script without the dot.

Needs the dot because the script needs to be executed in the shell process
(if you execute without the dot, it'll be created a new process, and
when you change a directory in the script, only the script process will
see the results... and we want that the shell change the directory, right?)

## Bash Completion

Put the bash completion file somewhere (my file's in $HOME/.bash\_completion.d)

And add to your bash\_profile:

> . bashcompletionpath

And vualá!

## Usage

There're five flags:
* 'g alias'   => go to the path corresponding to the alias
* 's alias'   => save the actual path with name alias
* 'd alias'   => delete the bookmark with name alias
* 'l'         => list all bookmarks
* 'help'      => prints a ugly help text...
