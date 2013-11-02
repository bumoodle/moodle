#!/usr/bin/env bash

#
# Installs/updates the Moodle@BU extra plugins.
#

. install_helpers.sh
VERSION=MOODLE_25_STABLE

#Operate from the Moodle WWW root.
cd ..

# Question Types:
install_from_git https://github.com/lechunche/type_calc_sheet.git question/type/type_calc_sheet #Spreadsheet.
install_from_git git://github.com/remotelearner/moodle-mod_questionnaire question/type/algebra  #Algebra
install_from_git https://github.com/moodleou/moodle-qtype_oumultiresponse.git question/type/oumultiresponse #OU Multiple Choice

# Activity Modules
install_from_git git://github.com/remotelearner/moodle-mod_questionnaire.git mod/questionnaire # Questionnaire

# Blocks
install_from_git git://github.com/mattgibson/moodle-block_ajax_marking.git blocks/ajax_marking "-b $VERSION" # AJAX Marking Block Plugin 
#install_from_git git://github.com/marxjohnson/moodle-block_messageteacher.git blocks/messageteacher # "Message My Teacher" block 
install_from_git git://github.com/bumoodle/moodle-block_unanswered_discussions.git blocks/unanswered_discussions "-b $VERSION" # Unanswered Discussions block 
install_from_git https://github.com/timhunt/moodle-report_customsql.git report/customsql #Custom SQL Reports 
install_from_git git://github.com/moodleou/moodle-block_viewasexample.git blocks/viewasexample # "View as Example" block 
install_from_git git://github.com/bumoodle/moodle-block_massaction.git blocks/massaction # "Mass Actions" block

# Grade Reports
install_from_git git://github.com/lsuits/grade_breakdown.git grade/report/grade_breakdown

#STACK and prerequsites
install_from_git git://github.com/maths/moodle-qbehaviour_dfexplicitvaildate.git question/behaviour/dfexplicitvaildate
install_from_git git://github.com/maths/moodle-qbehaviour_dfcbmexplicitvaildate.git question/behaviour/dfcbmexplicitvaildate
install_from_git git://github.com/maths/moodle-qbehaviour_adaptivemultipart.git question/behaviour/adaptivemultipart
install_from_git git://github.com/maths/moodle-qtype_stack.git question/type/stack
install_from_git git://github.com/maths/quiz_stack.git mod/quiz/report/stack

#TinyMCE Enhancements:
install_from_git git@github.com:marinaglancy/moodle-tinymce_managefiles.git lib/editor/tinymce/plugins/managefiles
