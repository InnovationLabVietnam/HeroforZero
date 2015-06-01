<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Partner extends App_Controller {

    function __construct() {
        parent::__construct();
        $this->load->model('partner_model');
    }

    /*     * ***SELECT**** */
    /* Last 18-March-2014 */

    public function getPartner() {
        $id = $this->input->post("id");

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['partner'] = null;

        $resultCheck = $this->partner_model->getPartner($id);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['partner'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['partner'] = $resultCheck;
        }

        echo json_encode($result);
    }

    /* Get Partner list function from database */

    public function getPartnerList() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['partners'] = "";

        $currentPage = $_POST['pageNumber'];
        $pageSize = $_POST['pageSize'];

        $resultCheck = $this->partner_model->getPartnerList($currentPage, $pageSize);
        
        // Get number
        $quantity = $this->partner_model->getNumPartner();

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['partners'] = $resultCheck;
             $result['quantity'] = $quantity;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['partners'] = $resultCheck;
        }
        echo json_encode($result);
    }

    /* Update IsApproved function from Partner Table */

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
        $resultCheck = $this->partner_model->updateIsApproved($Id, (int) $IsApproved);

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
    
    public function getPartnerExt(){
        $id = $this->input->post("partner_id");

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        $resultCheck = $this->partner_model->getPartnerExt($id);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['partner_ext'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }

        echo json_encode($result);
    }
    
    public function updatePartnerExt(){
        $id = $this->input->post('partner_id');
        $fanpage = $this->input->post('fanpage');
        $message = $this->input->post('donation_message');
        $link = $this->input->post('donation_link');
        $paypal = $this->input->post('donation_paypal');
        $address = $this->input->post('donation_address');
        
        // Initialization notification Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // 	Update data
        $resultCheck = $this->partner_model->updatePartnerExt($id, $fanpage, $message, $link, $paypal, $address);

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
    
    public function updatePartner(){
        $id = $this->input->post('partner_id');
        $name = $this->input->post('name');
        $logo = $this->input->post('logo_image');
        $icon = $this->input->post('icon_image');
        $admin = $this->input->post('admin_name');
        $email = $this->input->post('email');
        $address = $this->input->post('address');
        $phone = $this->input->post('phone');
        $website = $this->input->post('website');
        $type = $this->input->post('type');
        $description = $this->input->post('description');
        
        // Initialization notification Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // 	Update data
        $resultCheck = $this->partner_model->updatePartner($id, $name, $logo, $icon, $admin, $email, $address, $phone,$website,$type, $description);

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
    
    public function deletePartner(){
        $id = $this->input->post('partner_id');
        
        // Initialization notification Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // 	Update data
        $resultCheck = $this->partner_model->deletePartner($id);

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
    
}
?>