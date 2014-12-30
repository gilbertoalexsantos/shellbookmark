#!/bin/bash

homepath=`echo $HOME`
filename=".mybookmark"
filepath=$homepath"/"$filename
command=$1
arg=$2

# Creating the file, if doesn't exists
if [ ! -a $filepath ]; then `touch $filepath`; fi

# Putting the file lines in the array lines, and sorting the array
declare -a lines_=()
while read p; do lines_+=("$p"); done < $filepath
IFS=$'\n' lines=($(sort <<<"${lines_[*]}"))

function go {
    finded=false
    for ((i = 0; i < ${#lines[@]}; i++)); do
        IFS=' ' read -r alias_ path_ <<< ${lines[$i]}
        if [ $1 == $alias_ ]; then
            finded=true
            cd $path_;
            break
        fi
    done
    if [ $finded == false ]; then echo "alias doesn't exists"; fi
}

function save {
    alias=$1
    path=`pwd`

    # Checking if already exists alias or directory
    for ((i = 0; i < ${#lines[@]}; i++)); do
        IFS=' ' read -r alias_ path_ <<< ${lines[$i]}
        if [ $alias == $alias_ ]; then
            echo "alias already exists"
            exit
        fi
        if [ $path == $path_ ]; then
            echo "directory already exists"
            exit
        fi        
    done
    
    echo $1" "`pwd` >> $filepath
}

function list {
    maxLenAlias=0
    # Getting the max length of alias (to use in padding)
    for ((i = 0; i < ${#lines[@]}; i++)); do
        IFS=' ' read -r alias_ path_ <<< ${lines[$i]}
        if [ ${#alias_} -ge $maxLenAlias ]; then maxLenAlias=${#alias_}; fi
    done
    
    for ((i = 0; i < ${#lines[@]}; i++)); do
        IFS=' ' read -r alias_ path_ <<< ${lines[$i]}
        printf "%s" $alias_
        for ((j = 0; j < $maxLenAlias - ${#alias_}; j++)); do printf " "; done
        printf " %s\n" $path_
    done
}

case "$1" in
    l) list
       ;;
    g) if [ -z $2 ]; then
           echo "you need to specify the alias"
           exit
       else
           go $2
       fi
       ;;
    s) if [ -z $2 ]; then
           echo "you need to specify the alias"
           exit
       else
           save $2
       fi
       ;;
    help) echo "'g <alias>' => go to the path of the alias"
          echo "'l'         => list all bookmarks"
          echo "'s <alias>' => save the actual dir with the alias name"
          ;;
    *) echo "Flag doesn't exists. Use 'help' to see the flags"
esac
