<?php

/* Tan - Last 13-March-2014 */

defined('BASEPATH') OR exit('No direct script access allowed');

class Activity extends App_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('ion_auth');
        $this->load->library('form_validation');
        $this->load->helper('url');
        $this->load->helper('html');
        $this->load->model('activity_model');

        /* Load MongoDB library instead of native db driver if required */
        $this->config->item('use_mongodb', 'ion_auth') ?
                        $this->load->library('mongo_db') :
                        $this->load->database();

        $this->form_validation->set_error_delimiters($this->config->item('error_start_delimiter', 'ion_auth'), $this->config->item('error_end_delimiter', 'ion_auth'));

        $this->lang->load('auth');
        $this->load->helper('language');
    }

    /*     * ***SELECT**** */
    /* Get a activity function from databases */
    /* Last 14-March-2014 */

    public function getActivity() {
        $id = $this->input->post("id");

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['activity'] = null;

        $resultCheck = $this->activity_model->getActivity($id);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['activity'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['activity'] = $resultCheck;
        }

        echo json_encode($result);
    }

    /* Get Activity list function from database */

    public function getActivityList() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['activity'] = "";

        $currentPage = $_POST['pageNumber'];
        $pageSize = $_POST['pageSize'];

        $resultCheck = $this->activity_model->getActivityList($currentPage, $pageSize);

        // Get number
        $quantity = $this->activity_model->getNumActivity();

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['activity'] = $resultCheck;
            $result['quantity'] = $quantity;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['activity'] = $resultCheck;
        }
        echo json_encode($result);
    }

    /* Get Activity list by Organization function from database */

    public function getActivityListByOrganization() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['activity'] = "";

        $currentPage = $_POST['pageNumber'];
        $pageSize = $_POST['pageSize'];
        $partnerId = $_POST['partnerId'];

        $resultCheck = $this->activity_model->getActivityListByOrganization($currentPage, $pageSize, $partnerId);

        // Get number
        $quantity = $this->activity_model->getNumActivityByOrganization($partnerId);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['activity'] = $resultCheck;
            $result['quantity'] = $quantity;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['activity'] = $resultCheck;
        }
        echo json_encode($result);
    }

    /*     * ***INSERT**** */
    /* Last 17-March-2014 */
    /* 	Activity insert function */

    public function insertActivity() {
        $title = $this->input->post('title');
        $description = $this->input->post('description');
        $partner_id = $this->input->post('partner_id');
        $action_id = $this->input->post('action_id');
        $action_content = $this->input->post('action_content');
        $createDate = $this->activity_model->getTime();
        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // Implements work
        $resultCheck = $this->activity_model->insertActivity($title, $description, $partner_id, $action_id, $action_content, $createDate);

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
    /* Last 17-March-2014 */

    /* Update activity function from Activity Table */

    // Last 19-March-2014
    public function updateActivity() {

        // Get infomation from user
        $Id = $this->input->post('id');
        $partner_id = $this->input->post('partner_id');
        $title = $this->input->post('title');
        $description = $this->input->post('description');
        $action_id = $this->input->post('action_id');
        $action_content = $this->input->post('action_content');
        $point = $this->input->post('point');
        $approve = $this->input->post('approve');

        // Initialization notification Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // 	Update data
        $resultCheck = $this->activity_model->updateActivity($Id, $partner_id, $title, $description, $action_id, $action_content, $point, (int) $approve);

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

    /* Update BonusPoint function into Activity table */

    public function updateBonusPoint() {

        // Get infomation from user
        $Id = $this->input->post('id');
        $BonusPoint = $this->input->post('point');

        // Initialization notification Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // 	Update data
        $resultCheck = $this->activity_model->updateBonusPoint($Id, $BonusPoint);

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

    /* Update IsApproved function from Activity Table */

    // Last 18-March-2014
    public function updateIsApproved() {

        // Get infomation from user
        $Id = $this->input->post('id');
        $IsApproved = $this->input->post('is_approved');

        // Initialization notification Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // 	Update data
        $resultCheck = $this->activity_model->updateIsApproved($Id, (int) $IsApproved);

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

    /*     * **DELETE*** */
    /* Last 12-March-2014 */
    /* Delete Activity function */

    public function deleteActivity() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        $id = $_POST['id'];

        $resultCheck = $this->activity_model->deleteActivity($id);

        if ($resultCheck == 'Success') {
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