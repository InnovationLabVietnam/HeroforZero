<?php

/* Tan - Last 12-March-2014 */

defined('BASEPATH') OR exit('No direct script access allowed');

class Donation extends App_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('ion_auth');
        $this->load->library('form_validation');
        $this->load->helper('url');
        $this->load->helper('html');
        $this->load->model('donation_model');

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

    public function getDonation() {
        $id = $this->input->post("id");

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['donation'] = null;

        $resultCheck = $this->donation_model->getDonation($id);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['donation'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['donation'] = $resultCheck;
        }

        echo json_encode($result);
    }

    /* Get Donation list function from database */

    public function getDonationList() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['donation'] = "";

        $currentPage = $_POST['pageNumber'];
        $pageSize = $_POST['pageSize'];

        $resultCheck = $this->donation_model->getDonationList($currentPage, $pageSize);

        // Get number
        $quantity = $this->donation_model->getNumDonation();

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['donation'] = $resultCheck;
            $result['quantity'] = $quantity;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['donation'] = $resultCheck;
        }
        echo json_encode($result);
    }

    /* Get Donation list by Organization function from database */

    public function getDonationListByOrganization() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['donation'] = "";

        $currentPage = $_POST['pageNumber'];
        $pageSize = $_POST['pageSize'];
        $partnerId = $_POST['partnerId'];

        $resultCheck = $this->donation_model->getDonationListByOrganization($currentPage, $pageSize, $partnerId);

        // Get number
        $quantity = $this->donation_model->getNumDonationByOrganization($partnerId);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['donation'] = $resultCheck;
            $result['quantity'] = $quantity;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['donation'] = $resultCheck;
        }
        echo json_encode($result);
    }

    /*     * ***INSERT**** */
    /* Last 17-March-2014 */
    /* 	Donation insert function */

    public function insertDonation() {
        $title = $this->input->post('title');
        $description = $this->input->post('description');
        $partner_id = $this->input->post('partner_id');
        $createDate = $this->donation_model->getTime();

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = null;

        // Implements work
        $resultCheck = $this->donation_model->insertDonation($title, $description, $partner_id, $createDate);

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

    // Update donation
    public function updateDonation() {

        // Get infomation from user
        $Id = $this->input->post('id');
        $partner_id = $this->input->post('partner_id');
        $title = $this->input->post('title');
        $description = $this->input->post('description');
        $point = $this->input->post('point');
        $approve = $this->input->post('approve');

        // Initialization notification Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // 	Update data
        $resultCheck = $this->donation_model->updateDonation((int) $Id, $partner_id, $title, $description, $point, (int) $approve);

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

    /* Update RequiredPoint function into Donation table */

    public function updateRequiredPoint() {

        // Get infomation from user
        $Id = $this->input->post('id');
        $BonusPoint = $this->input->post('point');

        // Initialization notification Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // 	Update data
        $resultCheck = $this->donation_model->updateRequiredPoint($Id, $BonusPoint);

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

    /* Update IsApproved function from Donation Table */

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
        $resultCheck = $this->donation_model->updateIsApproved($Id, (int) $IsApproved);

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
    /* Delete Donation function */

    public function deleteDonation() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        $id = $_POST['id'];

        $resultCheck = $this->donation_model->deleteDonation($id);

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