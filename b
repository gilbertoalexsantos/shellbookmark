#!/bin/bash

homepath=`echo $HOME`
filename=".mybookmark"
filepath=$homepath"/"$filename
command=$1
arg=$2

# Creating the file, if doesn't exists
if [ ! -a $filepath ]; then `touch $filepath`; fi

# Creating two variables: lines_ and lines
# lines_ has all alias/path unsorted (helpful in delete)
# lines  has all alias sorted
declare -a lines_=()
while read p; do lines_+=("$p"); done < $filepath
IFS=$'\n' lines=($(sort <<< "${lines_[*]}"))

# @params
#   $1 => alias
function go {
    found=false
    for ((i = 0; i < ${#lines[@]}; i++)); do
        IFS=' ' read -r alias_ path_ <<< ${lines[$i]}
        if [ $1 == $alias_ ]; then
            found=true
            cd $path_;
            break
        fi
    done
    if [ $found == false ]; then echo "alias doesn't exist"; fi
}

# @params
#   $1 => alias
#   $2 => path
function save {
    alias=$1
    path=$2

    # Checking if already exists alias or directory
    for ((i = 0; i < ${#lines[@]}; i++)); do
        IFS=' ' read -r alias_ path_ <<< ${lines[$i]}
        if [ $alias == $alias_ ]; then
            echo "alias already exist"
            return
        fi
        if [ $path == $path_ ]; then
            echo "directory already exist"
            return
        fi
    done
    
    echo $alias" "$path >> $filepath
}

function list {
    # Getting the max length of alias (to use in padding)    
    maxLenAlias=0
    for ((i = 0; i < ${#lines[@]}; i++)); do
        IFS=' ' read -r alias_ path_ <<< ${lines[$i]}
        if [ ${#alias_} -ge $maxLenAlias ]; then maxLenAlias=${#alias_}; fi
    done

    if [ $maxLenAlias == 0 ]; then
        echo "empty"
        return
    fi
    
    for ((i = 0; i < ${#lines[@]}; i++)); do
        IFS=' ' read -r alias_ path_ <<< ${lines[$i]}
        printf "%s" $alias_
        for ((j = 0; j < $maxLenAlias - ${#alias_}; j++)); do printf " "; done
        printf " %s\n" $path_
    done
}

# @params
#   $1 => alias
function delete {
    alias=$1
    for ((i = 0; i < ${#lines_[@]}; i++)); do
        IFS=' ' read -r alias_ path_ <<< ${lines_[$i]}
        if [ $alias == $alias_ ]; then
            temp=${i}
            let temp+=1
            sed -i "" "${temp}d" $filepath
            return
        fi
    done
    echo "alias doesn't exist"
}

case $1 in
    l) list
       ;;
    g) if [ -z $2 ]; then
           cd $homepath
       else
           go $2
       fi
       ;;
    s) if [ -z $2 ]; then
           echo "you need to specify the alias"
       else
           save $2 `pwd`
       fi
       ;;
    d) if [ -z $2 ]; then
           echo "you need to specify the alias"
       else
           delete $2
       fi
       ;;
    help)
        echo "'l'          => list all bookmarks"        
        echo "'g' <alias>' => go to the path of the alias"
        echo "'s' <alias>' => save the actual dir with the alias name"
        echo "'d' <alias>  => delete the alias bookmark"
        ;;
    *) echo "flag doesn't exists. use 'help' to see the flags"
esac
