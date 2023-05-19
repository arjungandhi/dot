#!/usr/bin/bash

workon() {
    # function to convert a full path to a repo path aka
    # /home/username/repo/path/to/repo to user/repo
    # this is done by removing all directories before the last 2
    repo-list() {
        find $WORKSPACE -maxdepth 2 -mindepth 2 -type d \
        | rev | cut -d '/' -f 1-2 | rev 

        find $WORKSPACE -maxdepth 1 -mindepth 1 -type d \
        | rev | cut -d '/' -f 1 | rev 
    }

    # check that $WORKSPACE is set
    if [ -z "$WORKSPACE" ]; then
        echo "WORKSPACE is not set"
        return 1
    fi

    # --------------------------------- completion ---------------------------------
    if [[ -n $COMP_LINE ]]; then
        prefix=$(echo "$COMP_LINE" | cut -d " " -f 2)
        # workon takes you to a git repo to start working 
            repo-list | grep "$prefix"
        exit
    fi

    # --------------------------------- main ---------------------------------
    # check if the directory exists
    # if it does cd into it
    if [ -d "$WORKSPACE/$1" ]; then
        cd "$WORKSPACE/$1"
        return 0
    fi

    workspace=$(repo-list | fzf -q "$1" -1)

    # check if the directory exists
    if [ ! -d "$WORKSPACE/$workspace" ]; then
        echo "repo $workspace does not exist"
        return 1
    fi

    cd $WORKSPACE/$workspace
 }    
