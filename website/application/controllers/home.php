<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Home extends App_Controller {

    public function __construct() {
        parent::__construct();
        
    }

    public function index() {
        // Check if login
        if ($this->session->userdata('islogin')){
            if ($this->session->userdata('role') == 'admin'){
                redirect('admin');
            } else if ($this->session->userdata('role') == 'organization'){
                redirect('organization');
            }
        }
        // User not login
        $this->load->model('service_model');
        $this->load->model('partner_model');
        $data = array();
        // Get the number of children that need to save until now.
        $numberOfChildren = $this->service_model->getNumberOfChildrenByUserId()->numOfChildren;
        $data['children'] = number_format($numberOfChildren);
        // Get the top 4 leader board:
        $data['leader'] = $this->service_model->getLeaderBoard(0, 4);
        
        // Get the Donation list
        $donateList = $this->partner_model->getPartnerExtList();
        $data['donate'] = $donateList;
        
        $this->load->view('home/index', $data);
    }
    
    public function unauthorized(){
        $this->load->view('home/unauthorized');
    }
    
    public function not_approved(){
        $this->load->view('home/not_approved');
    }
    
    public function lang($language){
        $sess_array = array(
            'language' => $language
        );
        $this->session->set_userdata($sess_array);
        //var_dump($this->session->all_userdata());
        
        // Get parametter to redirect page
        $redirectUrl = $this->input->get('redirect');
        redirect($redirectUrl);
    }

}