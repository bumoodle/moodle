#!/usr/bin/env bash
. install_helpers.sh


#Themes
install_from_git git://github.com/bumoodle/moodle-theme_bumoodle.git theme/bumoodle # Moodle@BU Theme
install_from_git git://github.com/bumoodle/moodle-theme_pdf.git theme/pdf # Render-to-PDF Theme

#Searchable Topic Course Format
install_from_git git://github.com/bumoodle/moodle-format_topsearch.git course/format/topsearch

# Question Behaviours
install_from_git git://github.com/bumoodle/moodle-qbehaviour_adaptiveweighted.git question/behaviour/adaptiveweighted #Weighted Adaptive 
install_from_git git://github.com/bumoodle/moodle-qbehaviour_adaptiveweightedhints.git question/behaviour/adaptiveweightedhints #Weighted Adaptive (with Hints)
install_from_git git://github.com/bumoodle/moodle-qbehaviour_adaptiveweighted_queued.git question/behaviour/adaptiveweighted_queued #Weighted Adaptive (Queued)
install_from_git git://github.com/bumoodle/moodle-qbehaviour_savenongraded.git question/behaviour/savenongraded #Save Only ("non-grade")

# Question Types
install_from_git git://github.com/bumoodle/moodle-qtype_vhdl.git question/type/vhdl #HDL Simulation Question Type 
install_from_git git://github.com/bumoodle/moodle-qtype_boolean.git question/type/boolean #Boolean Expression / Simple Circuit 
install_from_git git://github.com/bumoodle/moodle-qtype_scripted.git question/type/scripted #Scripted (previously Calculated Sane) 
install_from_git git://github.com/bumoodle/MathScript.git question/type/scripted/mathscript #MathScript (dependency of Scripted)
install_from_git git://github.com/bumoodle/moodle-qtype_multianswerbu.git question/type/multianswerbu #MultiAnswer Cloze Question Type 
install_from_git git://github.com/bumoodle/moodle-qtype_scriptedessay.git question/type/scriptedessay #Scripted Essay Question Type 
install_from_git git://github.com/bumoodle/moodle-qtype_waveform.git question/type/waveform #Logic Waveform Question Type 
install_from_git git://github.com/bumoodle/moodle-qtype_usercode.git question/type/usercode #UserCode Question Type 
install_from_git git://github.com/bumoodle/moodle-qtype_checkoff.git question/type/checkoff #Proctor Checkoff 
install_from_git git://github.com/bumoodle/moodle-qtype_partner.git question/type/partner #Partner Psuedo-Question 
install_from_git git://github.com/bumoodle/moodle-qtype_onlinejudge.git question/type/onlinejudge #Online Judge (Coding) questions 

# Activity Modules
install_from_git git://github.com/blindsidenetworks/moodle-mod_bigbluebuttonbn.git mod/bigbluebuttonbn #BigBlueButton (third party) 
install_from_git git://github.com/blindsidenetworks/moodle-mod_recordingsbn.git mod/recordingsbn #Lecture Recording for BBB (third party) 
install_from_git git@github.com:bumoodle/moodle_mod_attforblock.git mod/attforblock #Attendance Module 

# Quiz Reports
install_from_git git://github.com/bumoodle/moodle-quiz_papercopy.git mod/quiz/report/papercopy #Paper Copy (paper quizzes) 
install_from_git git@github.com:bumoodle/moodle-quiz_copyattempt.git mod/quiz/report/copyattempt #Copy Attempt (manual synchronization) 

# Blocks
install_from_git git://github.com/bumoodle/moodle-block_progress.git blocks/progress #Progress bar 
install_from_git git://github.com/bumoodle/moodle-block_quickmail.git blocks/quickmail #QuickMail (provides Ask Instructor) 

# Grade Reports
install_from_git git://github.com/bumoodle/moodle-gradereport_projected.git grade/report/projected #Project Final Grade

#JW Player Filter (for streaming media on Flash/HTML5)
install_from_git git://github.com/bumoodle/moodle-filter_streaming.git filter/streaming

# Local 
install_from_git git://github.com/bumoodle/moodle-local_quizsync.git local/quizsync #Quiz Sync library 
install_from_git git://github.com/bumoodle/moodle-local_jquery.git local/jquery #jQuery 
install_from_git git://github.com/bumoodle/moodle-local_onlinejudge.git local/onlinejudge #Online Judge 
install_from_git git://github.com/bumoodle/moodle-local_errorlogger.git local/errorlogger #Error Logger Hack
