#/usr/bin/env bash

#Warn the user before attempting to intall BrainLink plugins.
echo "This script installs Binghamton-University specific authentication plugins."
echo "These allow PODS authentication, and are not necessary or applicable for most installations."
echo ""
echo "These plugins are not (yet) open source; you will need to authenticate yourself to install them."
echo ""

#Check if the user would like to continue.
read -p "Continue? [y/N]:"
[ "$(echo $REPLY | tr [:upper:] [:lower:])" == "y" ] || exit

#Install the BrainLink authentication plugin...
git clone https://ktemkin@bitbucket.org/ktemkin/moodle-auth_brain auth/brain
echo '/auth/brain' >> .git/info/exclude

#Install the BrainLink enrollment plugin...
git clone https://ktemkin@bitbucket.org/ktemkin/moodle-enrol_brain.git enrol/brain
echo '/enrol/brain' >> .git/info/exclude


