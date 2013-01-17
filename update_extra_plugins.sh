#!/usr/bin/env bash

#these are the locations (with respect to the Moodle install root) of each of the standard plugins to be updated
extra_plugins=(
  'blocks/ajax_marking'
  'blocks/configurable_reports'
  'blocks/massaction'
  'blocks/messageteacher'
  'blocks/unanswered_discussions'
  'blocks/viewasexample'
  'mod/questionnaire'
)

#update each of the standard plugins
for plugin in ${extra_plugins[@]}; do
    echo "Updating $plugin" 
    git --git-dir=$plugin/.git pull 
done
