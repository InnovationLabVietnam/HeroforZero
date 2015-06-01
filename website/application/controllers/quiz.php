<?php

/* Tan - Last 11-March-2014 */

defined('BASEPATH') OR exit('No direct script access allowed');

class Quiz extends App_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('ion_auth');
        $this->load->library('form_validation');
        $this->load->helper('url');
        $this->load->helper('html');
        $this->load->model('quiz_model');

        /* Load MongoDB library instead of native db driver if required */
        $this->config->item('use_mongodb', 'ion_auth') ?
                        $this->load->library('mongo_db') :
                        $this->load->database();

        $this->form_validation->set_error_delimiters($this->config->item('error_start_delimiter', 'ion_auth'), $this->config->item('error_end_delimiter', 'ion_auth'));

        $this->lang->load('auth');
        $this->load->helper('language');
    }

    /*     * ***SELECT**** */
    /* Get a quiz function from databases */
    /* Last 11-March-2014 */

    public function getQuiz() {

        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = null;


        $id = $this->input->post("id");
        $resultCheck = $this->quiz_model->getQuiz($id);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info'] = $resultCheck;
        }
        echo json_encode($result);
    }

    /* Get quiz list function from database */

    public function getQuizList() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['quiz'] = "";

        $currentPage = $_POST['pageNumber'];
        $pageSize = $_POST['pageSize'];



        // $resultCheck1 = $this->quiz_model->getId((int)$IdList[0], (int)$IdList[$last]);
        $resultCheck = $this->quiz_model->getQuizList((int) $currentPage, (int) $pageSize);
        // $keys = array_keys($IdList);
        // $last = end($keys);

        

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['quiz'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['quiz'] = $resultCheck;
        }
        echo json_encode($result);
    }
    
    
    // Get list of Quiz with answers used in website.
    public function getQuizChoiceList(){
        // Get request params:
        $pageNumber = $this->input->post('page_number');
        $pageSize = $this->input->post('page_size');
        
        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        
        $quizList = $this->quiz_model->getQuizChoiceList($pageNumber, $pageSize);
        
        if ($quizList) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['quiz'] = $quizList;
        } else {
            $result['code'] = 0;
            $result['message'] = "No result";
        }
        
        echo json_encode($result);
    }

    /*     * ***INSERT**** */
    /* Insert a new quiz function into databases */

    public function insertQuiz() {

        // Get System time
        $currentDate = $this->quiz_model->getTime();

        // Get infomation from user      
        $partnerId = $this->input->post('partner_id');
        $questCategory = $this->input->post('category');
        $questQuestion = $this->input->post('question');
        $imageUrl = $this->input->post('image_url');
        $answerA = $this->input->post('answer_a');
        $answerB = $this->input->post('answer_b');
        $answerC = $this->input->post('answer_c');
        $answerD = $this->input->post('answer_d');
        $CorrectChoiceId = $this->input->post('correct_answer');
        $sharingInfo = $this->input->post('sharing');
        $linkURL = $this->input->post('link');
        $createDate = $currentDate;

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";


        // Insert Quiz
        $resultCheck = $this->quiz_model->insertQuiz($questCategory, $questQuestion, $imageUrl, $CorrectChoiceId, $sharingInfo, $linkURL, $partnerId, $createDate, $answerA, $answerB, $answerC, $answerD);

        if ($resultCheck == 'Success') {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }

    /*     * ***UPDATE**** */
    /* Update a quiz function into Quiz table */

    public function updateQuiz() {

        // Get System time
        $currentDate = $this->quiz_model->getTime();

        // Get infomation from user
        $Id = $this->input->post('id');
        $partnerId = $this->input->post('partnerId');
        $questCategory = $this->input->post('category');
        $questQuestion = $this->input->post('question');
        $imageUrl = $this->input->post('image_url');
        $answerA = $this->input->post('answer_a');
        $answerB = $this->input->post('answer_b');
        $answerC = $this->input->post('answer_c');
        $answerD = $this->input->post('answer_d');
        $CorrectChoiceNumber = $this->input->post('correct_answer');
        $sharingInfo = $this->input->post('sharing');
        $linkURL = $this->input->post('link');
        $createDate = $currentDate;

        // Initialization notification Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['quiz'] = "";

        // Get minChoiceId
        $minChoiceId = (int) $this->quiz_model->getMinChoiceId($Id);

        // Update Answer
        if (!is_null($answerA))
            $this->quiz_model->updateChoice($minChoiceId, $answerA);
        if (!is_null($answerB))
            $this->quiz_model->updateChoice($minChoiceId + 1, $answerB);
        if (!is_null($answerC))
            $this->quiz_model->updateChoice($minChoiceId + 2, $answerC);
        if (!is_null($answerD))
            $this->quiz_model->updateChoice($minChoiceId + 3, $answerD);


        //	Update correct answer
        $CorrectChoiceId = $minChoiceId + (int) $CorrectChoiceNumber;
        $resultCheck = $this->quiz_model->updateQuiz($Id, $questCategory, $questQuestion,$imageUrl, $CorrectChoiceId, $sharingInfo, $linkURL, $createDate);
        $result1 = $this->quiz_model->getQuiz($Id);

        //	Notification
        if ($resultCheck == 'Success') {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['quiz'] = $result1;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }

    /* Update BonusPoint function into Quiz table */

    public function updateBonusPoint() {

        // Get infomation from user
        $Id = $this->input->post('id');
        $BonusPoint = $this->input->post('point');

        // Initialization notification Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = null;

        // 	Update data
        $resultCheck = $this->quiz_model->updateBonusPoint($Id, $BonusPoint);

        //	Notification
        if ($resultCheck == 'Success') {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info'] = $resultCheck;
        }
        echo json_encode($result);
    }

    /* Update IsApproved function from Quiz Table */

    // Last 17-March-2014
    public function updateIsApproved() {

        // Get infomation from user
        $Id = $this->input->post('id');
        $IsApproved = $this->input->post('is_approved');

        // Initialization notification Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // 	Update data
        $resultCheck = $this->quiz_model->updateIsApproved($Id, (int) $IsApproved);

        //	Notification
        if ($resultCheck == 'Success') {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }

    /*     * ***DELETE**** */
    /* Last 12-March-2014 */

    public function deleteQuiz() {

        // Get infomation from user
        $Id = $this->input->post('id');

        // Initialization notification Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = null;

        $resultCheck = $this->quiz_model->deleteQuiz($Id);

        //	Notification
        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info'] = $resultCheck;
        }
        echo json_encode($result);
    }

}

?>