#!/usr/bin/bash

workon() {
    # function to convert a full path to a repo path aka
    # /home/username/repo/path/to/repo to user/repo
    # this is done by removing all directories before the last 2
    list() {
        find $WORKSPACE -maxdepth 2 -mindepth 2 -type d \
        | rev | cut -d '/' -f 1-2 | rev 
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
            list | grep "$prefix"
        exit
    fi

    # --------------------------------- main ---------------------------------

    # check that the repo exists
    workspace=$(list | grep "$1")

    # check theres only one match
    if [ $(echo "$workspace" | wc -l) -gt 1 ]; then
        echo "More than one match for $1"
        echo "use tab complete"
        return 1
    fi

    if [ ! -d "$WORKSPACE/$workspace" ]; then
        echo "repo $workspace does not exist"
        return 1
    fi

    cd $WORKSPACE/$workspace
 }    
