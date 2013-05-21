#!/usr/bin/env bash

#
# Moodle@BU Theme
#
git clone git://github.com/bumoodle/moodle-theme_bumoodle.git theme/bumoodle
echo '/theme/bumoodle' >> .git/info/exclude

#
# Render-to-PDF Theme
#
git clone git://github.com/bumoodle/moodle-theme_pdf.git theme/pdf
echo '/theme/pdf' >> .git/info/exclude

#
# Editor Plugins
#

#BU Customized TinyMCE
git clone git://github.com/bumoodle/moodle-editor_butinymce.git lib/editor/butinymce
echo '/lib/editor/butinymce' >> .git/info/exclude

#
# Course Formats
#

#Searchable Topic Course Format
git clone git://github.com/bumoodle/moodle-format_topsearch.git course/format/topsearch
echo '/course/format/topsearch' >> .git/info/exclude


#
# Question Behaviours
#

#Weighted Adaptive 
git clone git://github.com/bumoodle/moodle-qbehaviour_adaptiveweighted.git question/behaviour/adaptiveweighted
echo '/question/behaviour/adaptiveweighted' >> .git/info/exclude

#Weighted Adaptive (with Hints)
git clone git://github.com/bumoodle/moodle-qbehaviour_adaptiveweightedhints.git question/behaviour/adaptiveweightedhints
echo '/question/behaviour/adaptiveweightedhints' >> .git/info/exclude

#Weighted Adaptive (Queued)
git clone git://github.com/bumoodle/moodle-qbehaviour_adaptiveweighted_queued.git question/behaviour/adaptiveweighted_queued
echo '/question/behaviour/adaptiveweighted_queued' >> .git/info/exclude

#Save Only ("non-grade")
git clone git://github.com/bumoodle/moodle-qbehaviour_savenongraded.git question/behaviour/savenongraded
echo '/question/behaviour/savenongraded' >> .git/info/exclude

#
# Question Types
#

#HDL Simulation Question Type
git clone git://github.com/bumoodle/moodle-qtype_vhdl.git question/type/vhdl
echo '/question/type/vhdl' >> .git/info/exclude

#Boolean Expression / Simple Circuit
git clone git://github.com/bumoodle/moodle-qtype_boolean.git question/type/boolean
echo '/question/type/boolean' >> .git/info/exclude

#Scripted (previously Calculated Sane)
git clone git://github.com/bumoodle/moodle-qtype_scripted.git question/type/scripted
echo '/question/type/scripted' >> .git/info/exclude

#MathScript (dependency of Scripted)
git clone git://github.com/bumoodle/MathScript.git question/type/scripted/mathscript
echo '/mathscript' >> question/type/scripted/.git/info/exclude

#MultiAnswer Cloze Question Type
git clone git://github.com/bumoodle/moodle-qtype_multianswerbu.git question/type/multianswerbu
echo '/question/type/multianswerbu' >> .git/info/exclude

#Scripted Essay Question Type
git clone git://github.com/bumoodle/moodle-qtype_scriptedessay.git question/type/scriptedessay
echo '/question/type/scriptedessay' >> .git/info/exclude

#Logic Waveform Question Type
git clone git://github.com/bumoodle/moodle-qtype_waveform.git question/type/waveform
echo '/question/type/waveform' >> .git/info/exclude

#UserCode Question Type
git clone git://github.com/bumoodle/moodle-qtype_usercode.git question/type/usercode
echo '/question/type/usercode' >> .git/info/exclude

#Proctor Checkoff
git clone git://github.com/bumoodle/moodle-qtype_checkoff.git question/type/checkoff
echo '/question/type/checkoff' >> .git/info/exclude

#Partner Psuedo-Question
git clone git://github.com/bumoodle/moodle-qtype_partner.git question/type/partner
echo '/question/type/partner' >> .git/info/exclude

#Online Judge (Coding) questions
git clone git://github.com/bumoodle/moodle-qtype_onlinejudge.git question/type/onlinejudge
echo '/question/type/onlinejudge' >> .git/info/exclude

#
# Activity Modules
#

#BigBlueButton (third party)
git clone git://github.com/blindsidenetworks/moodle-mod_bigbluebuttonbn.git mod/bigbluebuttonbn
echo 'mod/bigbluebuttonbn' >> .git/info/exclude

#Lecture Recording for BBB (third party)
git clone git://github.com/blindsidenetworks/moodle-mod_recordingsbn.git mod/recordingsbn
echo 'mod/recordingsbn' >> .git/info/exclude

#Attendance Module
git clone git@github.com:bumoodle/moodle_mod_attforblock.git mod/attforblock
echo 'mod/attforblock' >> .git/info/exclude


#
# Quiz Reports
#

#Paper Copy (paper quizzes)
git clone git://github.com/bumoodle/moodle-quiz_papercopy.git mod/quiz/report/papercopy
echo '/mod/quiz/report/papercopy' >> .git/info/exclude

#Copy Attempt (manual synchronization)
git clone git@github.com:bumoodle/moodle-quiz_copyattempt.git mod/quiz/report/copyattempt
echo '/mod/quiz/report/copyattempt' >> .git/info/exclude

#
# Blocks
#

#Progress bar
git clone git://github.com/bumoodle/moodle-block_progress.git blocks/progress
echo '/blocks/progress' >> .git/info/exclude

#QuickMail (provides Ask Instructor)
git clone git://github.com/bumoodle/moodle-block_quickmail.git blocks/quickmail
echo '/blocks/quickmail' >> .git/info/exclude

#
# Grade Reports
#
git clone git://github.com/bumoodle/moodle-gradereport_projected.git grade/report/projected
echo '/grade/report/projected' >> .git/info/exclude

#
# Filters
#

#JW Player Filter (for streaming media on Flash/HTML5)
git clone git://github.com/bumoodle/moodle-filter_jwplayer.git filter/jwplayerfilter
echo '/filter/jwplayerfilter' >> .git/info/exclude

#
# Local 
#

#Quiz Sync library
git clone git://github.com/bumoodle/moodle-local_quizsync.git local/quizsync
echo '/local/quizsync' >> .git/info/exclude

#jQuery
git clone git://github.com/bumoodle/moodle-local_jquery.git local/jquery
echo '/local/jquery' >> .git/info/exclude

#Error Logger Hack
git clone git://github.com/bumoodle/moodle-local_onlinejudge.git local/onlinejudge
echo '/local/onlinejudge' >> .git/info/exclude

#Error Logger Hack
git clone git://github.com/bumoodle/moodle-local_errorlogger.git local/errorlogger
echo '/local/errorlogger' >> .git/info/exclude
