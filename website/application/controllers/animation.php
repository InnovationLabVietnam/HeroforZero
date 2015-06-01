<?php

/* 
 * Code written by Nguyen Van Hung at @imrhung
 * Feel free to re-use or share it.
 * Happy code!!!
 */

defined('BASEPATH') OR exit('No direct script access allowed');

class Animation extends App_Controller{
    
    function __construct() {
        parent::__construct();
        $this->load->model('animation_model');
    }
    
    function index(){
    }
    
    
    
    /*
     * Get Animation info
     * Put 'id' to get specific animation
     * Do not put 'id' to get list
     * Put 'page_size' = 0 to get full list.
     */
    public function getAnimation() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['animation'] = "";

        $pageNumber = $this->input->post('page_number');
        $pageSize = $this->input->post('page_size');
        $id = $this->input->post('id');

        if ($id === FALSE){
            // There is no ID, get the full list
            $resultCheck = $this->animation_model->getAnimationList($pageSize, $pageNumber);
            $result['info']['animation'] = $resultCheck;
            
            // Quantity of list:
            $quantity = $this->animation_model->getNumAnimation();
            $result['info']['quantity'] = $quantity;
        } else {
            // Get one animation
            $resultCheck = $this->animation_model->getAnimation($id);
            $result['info']['animation'] = $resultCheck;
        }

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }
    
    public function createAnimation(){
        $time = $this->input->post('time');
        $walking = $this->input->post('walking');
        $standby = $this->input->post('standby');
        $monster = $this->input->post('monster');
        $kid = $this->input->post('kid');
        $colorRed = $this->input->post('color_red');
        $colorGreen = $this->input->post('color_green');
        $colorBlue = $this->input->post('color_blue');
        $screenshot = $this->input->post('screenshot_url');
        
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        
        $id = $this->animation_model->insertAnimation($time, $walking, $standby, 
                $monster, $kid, $colorRed, $colorGreen, $colorBlue, $screenshot);
        
        if ($id) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['id'] = $id;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }
    
    public function editAnimation(){
        $id = $this->input->post('id');
        $time = $this->input->post('time');
        $walking = $this->input->post('walking');
        $standby = $this->input->post('standby');
        $monster = $this->input->post('monster');
        $kid = $this->input->post('kid');
        $colorRed = $this->input->post('color_red');
        $colorGreen = $this->input->post('color_green');
        $colorBlue = $this->input->post('color_blue');
        $screenshot = $this->input->post('screenshot_url');
        
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        
        $check = $this->animation_model->updateAnimation($id, $time, $walking, $standby, 
                $monster, $kid, $colorRed, $colorGreen, $colorBlue, $screenshot);
        
        if ($check) {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }
    
    public function delete(){
        $id = $this->input->post('id');
        
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        
        $check = $this->animation_model->delete($id);
        
        if ($check) {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }
    
}

