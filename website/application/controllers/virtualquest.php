<?php

/* Tan - Last 13-March-2014 */

defined('BASEPATH') OR exit('No direct script access allowed');

class VirtualQuest extends App_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('ion_auth');
        $this->load->library('form_validation');
        $this->load->helper('url');
        $this->load->helper('html');
        $this->load->model('virtualquest_model');

        /* Load MongoDB library instead of native db driver if required */
        $this->config->item('use_mongodb', 'ion_auth') ?
                        $this->load->library('mongo_db') :
                        $this->load->database();

        $this->form_validation->set_error_delimiters($this->config->item('error_start_delimiter', 'ion_auth'), $this->config->item('error_end_delimiter', 'ion_auth'));

        $this->lang->load('auth');
        $this->load->helper('language');
    }

	public function completeQuest() {
		$result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = null;
		
		$userId = $_POST['userId'];
		$questId = $_POST['questId'];
		
		$data = $this->virtualquest_model->completeQuestProcess($userId, $questId);
		if ($data) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info'] = $data;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info'] = $data;
        }
        echo json_encode($result);
	}
	
    /*     * ***SELECT**** */
    /* Last 18-March-2014 */
    /* Get a VirtualQuest function from database */
	public function getVirtualQuest() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = null;

        $id = $_POST['id'];

        $data = $this->virtualquest_model->getVirtualQuest($id);
        if ($data) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info'] = $data;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info'] = $data;
        }
        echo json_encode($result);
    }
	
	public function getVirtualQuestForMobile() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = null;

        $id = $_POST['id'];

        $data = $this->virtualquest_model->getDataVirtualQuestForMobile($id);
        if ($data) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info'] = $data;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info'] = $data;
        }
        echo json_encode($result);
    }
    /* Get VirtualQuest list function from database */

    public function getVirtualQuestList() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['quest'] = "";
        $currentPage = $_POST['pageNumber'];
        $pageSize = $_POST['pageSize'];

        $resultCheck = $this->virtualquest_model->getVirtualQuestList($currentPage, $pageSize);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['quest'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['quest'] = $resultCheck;
        }
        echo json_encode($result);
    }

    /*     * ***INSERT**** */
    /* Insert a new virtualquest function into databases */

    public function insertVirtualQuest() {

        // Get infomation from user      
        $partnerId = $this->input->post('partner_id');
        $packetId = $this->input->post('packet_id');
        $name = $this->input->post('name');
        $unlock = $this->input->post('unlock');
        $point = $this->input->post('point');
        $activity_id_1 = $this->input->post('activity_id_1');
        $quiz_category = $this->input->post('quiz_category');
        $activity_id_2 = $this->input->post('activity_id_2');
        $activity_id_3 = $this->input->post('activity_id_3');
        $donation_id_1 = $this->input->post('donation_id_1');
        $donation_id_2 = $this->input->post('donation_id_2');
        $donation_id_3 = $this->input->post('donation_id_3');
        $createDate = $this->virtualquest_model->getTime();
        
        $animation = $this->input->post('animation_id');
        $image = $this->input->post('image_url');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        
        // Insert Medal of this quest first
        $medalId = $this->virtualquest_model->insertQuestMedal($name, $image);

        // Insert VirtualQuest
        $Id = $this->virtualquest_model->insertVirtualQuest($partnerId, $packetId, $name, $unlock, $createDate, $animation, $image, $medalId);

        // Insert ConditionQuest quiz action
        $this->virtualquest_model->insertQuestConditionPoint(0, $quiz_category, $Id, $point);

        // Insert ConditionQuest activity action
        if ($activity_id_1 != 0)
            $this->virtualquest_model->insertQuestCondition(1, $activity_id_1, $Id);
        if ($activity_id_2 != 0)
            $this->virtualquest_model->insertQuestCondition(1, $activity_id_2, $Id);
        if ($activity_id_3 != 0)
            $this->virtualquest_model->insertQuestCondition(1, $activity_id_3, $Id);

        // Insert ConditionQuest activity action
        if ($donation_id_1 != 0)
            $this->virtualquest_model->insertQuestCondition(2, $activity_id_1, $Id);
        if ($donation_id_2 != 0)
            $this->virtualquest_model->insertQuestCondition(2, $donation_id_2, $Id);
        if ($donation_id_3 != 0)
            $this->virtualquest_model->insertQuestCondition(2, $donation_id_3, $Id);

        if ($Id) {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }

    /*     * ***UPDATE**** */
    /* Last 24-March-2014 */
    /* Update a virtualquest function into databases */

    public function updateVirtualQuest() {

        // Get infomation from user  
        
        $Id = $this->input->post('id');
        $partnerId = $this->input->post('partner_id');
        $packetId = $this->input->post('packet_id');
        $name = $this->input->post('name');
        $unlock = $this->input->post('unlock');
        $point = $this->input->post('point');
        $activity_id_1 = $this->input->post('activity_id_1');
        $quiz_category = $this->input->post('quiz_category');
        $activity_id_2 = $this->input->post('activity_id_2');
        $activity_id_3 = $this->input->post('activity_id_3');
        $donation_id_1 = $this->input->post('donation_id_1');
        $donation_id_2 = $this->input->post('donation_id_2');
        $donation_id_3 = $this->input->post('donation_id_3');
        
        $animation = $this->input->post('animation_id');
        $image = $this->input->post('image_url');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // update virtual quest
        $resultCheck = $this->virtualquest_model->updateVirtualQuest($Id, (int) $partnerId, (int) $packetId, $name, (int) $unlock, $animation, $image);

        // Delete questCondition
        $this->virtualquest_model->deleteQuestCondition($Id);

        // Insert ConditionQuest quiz action
        $this->virtualquest_model->insertQuestConditionPoint(0, $quiz_category, $Id, $point);

        // Insert ConditionQuest activity action
        if ($activity_id_1 != 0)
            $this->virtualquest_model->insertQuestCondition(1, $activity_id_1, $Id);
        if ($activity_id_2 != 0)
            $this->virtualquest_model->insertQuestCondition(1, $activity_id_2, $Id);
        if ($activity_id_3 != 0)
            $this->virtualquest_model->insertQuestCondition(1, $activity_id_3, $Id);

        // Insert ConditionQuest activity action
        if ($donation_id_1 != 0)
            $this->virtualquest_model->insertQuestCondition(2, $donation_id_1, $Id);
        if ($donation_id_2 != 0)
            $this->virtualquest_model->insertQuestCondition(2, $donation_id_2, $Id);
        if ($donation_id_3 != 0)
            $this->virtualquest_model->insertQuestCondition(2, $donation_id_3, $Id);

        if ($resultCheck) {
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
    /* Delete virtualquest function */

    public function deleteVirtualQuest() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        $id = $_POST['id'];

        $resultCheck = $this->virtualquest_model->deleteVirtualQuest($id);

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