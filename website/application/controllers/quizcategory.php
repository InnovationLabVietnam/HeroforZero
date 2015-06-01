<?php

/* Tan - Last 13-March-2014 */

defined('BASEPATH') OR exit('No direct script access allowed');

class QuizCategory extends App_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('ion_auth');
        $this->load->library('form_validation');
        $this->load->helper('url');
        $this->load->helper('html');
        $this->load->model('quizcategory_model');

        /* Load MongoDB library instead of native db driver if required */
        $this->config->item('use_mongodb', 'ion_auth') ?
                        $this->load->library('mongo_db') :
                        $this->load->database();

        $this->form_validation->set_error_delimiters($this->config->item('error_start_delimiter', 'ion_auth'), $this->config->item('error_end_delimiter', 'ion_auth'));

        $this->lang->load('auth');
        $this->load->helper('language');
    }

    /*     * ***SELECT**** */
    /* Last 18-March-2014 */

    /* Get QuizCategory list function from database */

    public function getQuizCategoryList() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['category'] = "";

        $currentPage = $_POST['pageNumber'];
        $pageSize = $_POST['pageSize'];

        $resultCheck = $this->quizcategory_model->getQuizCategoryList($currentPage, $pageSize);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['category'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['category'] = $resultCheck;
        }
        echo json_encode($result);
    }
    
    public function getQuizCategory(){
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();
        
        $resultCheck = $this->quizcategory_model->getQuizCategoryCountList();

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['category'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['category'] = $resultCheck;
        }
        echo json_encode($result);
    }

    /*     * ***INSERT**** */
    /* Last 18-March-2014 */
    /* 	QuizCategory insert function */

    public function insertQuizCategory() {
        $category = $this->input->post('category_name');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // Implements work
        $resultCheck = $this->quizcategory_model->insertQuizCategory($category);

        if ($resultCheck == 'Success') {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }

    public function updateQuizCategory(){
        $id = $this->input->post('id');
        $category = $this->input->post('category_name');
        
        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // Implements work
        $resultCheck = $this->quizcategory_model->updateQuizCategory($id,$category);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }
    
    public function deleteQuizCategory(){
        $id = $this->input->post('id');
        
        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // Implements work
        $resultCheck = $this->quizcategory_model->deleteCategory($id);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }
}

?>