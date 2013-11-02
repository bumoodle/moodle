#!/bin/bash

function install_from_git {

    #If the given folder already exists, install the most recent version.
    if [ -d "$2" ]; then
        #Request git updates to the most recent version.
        git --git-dir=$2/.git pull 
    else
        #Install the given repository.
        git clone $1 $2 $3
        echo "/$2" >> .git/info/exclude
    fi
   
}
