<?php

// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * @package    moodlecore
 * @subpackage backup-dbops
 * @copyright  2010 onwards Eloy Lafuente (stronk7) {@link http://stronk7.com}
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

/**
 * Non instantiable helper class providing DB support to the questions backup stuff
 *
 * This class contains various static methods available for all the DB operations
 * performed by questions stuff
 *
 * TODO: Finish phpdocs
 */
abstract class backup_question_dbops extends backup_dbops {

    /**
     * Calculates all the question_categories to be included
     * in backup, based in a given context (course/module) and
     * the already annotated questions present in backup_ids_temp
     */
    public static function calculate_question_categories($backupid, $contextid) {
        global $DB;

        // First step, annotate all the categories for the given context (course/module)
        // i.e. the whole context questions bank
        $DB->execute("INSERT INTO {backup_ids_temp} (backupid, itemname, itemid)
                      SELECT ?, 'question_category', id
                        FROM {question_categories}
                       WHERE contextid = ?", array($backupid, $contextid));

        // XXX HACK ALERT! Do not commit me to upstream! XXX
        // An issue with past Moodle backup has caused several courses to share the same question, in the same 
        // course context, despite context policies prohibiting this. This short function prevents them from breaking backups.
        self::hack_to_fix_categories_for_bu($backupid, $contextid);


        // Now, based in the annotated questions, annotate all the categories they
        // belong to (whole context question banks too)
        // First, get all the contexts we are going to save their question bank (no matter
        // where they are in the contexts hierarchy, transversals... whatever)
        $contexts = $DB->get_fieldset_sql("SELECT DISTINCT qc2.contextid
                                             FROM {question_categories} qc2
                                             JOIN {question} q ON q.category = qc2.id
                                             JOIN {backup_ids_temp} bi ON bi.itemid = q.id
                                            WHERE bi.backupid = ?
                                              AND bi.itemname = 'question'
                                              AND qc2.contextid != ?", array($backupid, $contextid));

        // And now, simply insert all the question categories (complete question bank)
        // for those contexts if we have found any
        if ($contexts) {
            list($contextssql, $contextparams) = $DB->get_in_or_equal($contexts);
            $params = array_merge(array($backupid), $contextparams);
            $DB->execute("INSERT INTO {backup_ids_temp} (backupid, itemname, itemid)
                          SELECT ?, 'question_category', id
                            FROM {question_categories}
                           WHERE contextid $contextssql", $params);
        }
    }

    /** 
     * An issue with past Moodle backup has caused several courses to share the same question, in the same 
     * course context, despite context policies prohibiting this. This short (and horribly hackish) function
     * allows us to still create successful backups.
     *
     * Once these backups are restored, this should no longer be necessary, and this function shuold be removed
     * and never spoken of again.
     */  
    public static function hack_to_fix_categories_for_bu($backupid, $contextid) {

        global $DB;

        //Get a list of all /questions/ to be included in the backup.
        $questions = $DB->get_records('backup_ids_temp', array('backupid' => $backupid, 'itemname' => 'question'), null, 'itemid');

        //For each question to be saved...
        foreach($questions as $question) {
            self::hack_subquestion_categories($question->itemid, 'multianswer');
            self::hack_subquestion_categories($question->itemid, 'multianswerbu');
        }

    }

    /**
     * Hack which converts all of the subquestions of a given multianswer-derivate to the given 
     */
    public static function hack_subquestion_categories($question_id, $qtype = 'multianswer') {
        global $DB;

        //Get the question ID.
        $question_id = intval($question_id);

        //Fetch the list of subquestions for the given question.
        $result = $DB->get_record_sql('
            SELECT multianswer.sequence as subquestions, question.category as category FROM
                 {question} as question,
                 {question_'.$qtype.'} as multianswer
            WHERE 
                question.id = ? AND
                multianswer.question = question.id AND
                question.qtype = ?', array($question_id, $qtype));

        //If this isn't a multianswer, skip it.
        if(empty($result->subquestions)) {
            return;
        } 

        //Split the subquestions array into a list of subquestions.
        $subquestions = explode(',', $result->subquestions);

        //And force each subquestion to exist in the same category as its parent.  
        foreach($subquestions as $subquestion_id) {
            $DB->set_field('question', 'category', $result->category, array('id' => $subquestion_id));       
        }

    }

    /**
     * Delete all the annotated questions present in backup_ids_temp
     */
    public static function delete_temp_questions($backupid) {
        global $DB;
        $DB->delete_records('backup_ids_temp', array('backupid' => $backupid, 'itemname' => 'question'));
    }
}
