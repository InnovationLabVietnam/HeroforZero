<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User extends App_Controller {
    
    /*
     * Language variable: store the language option of site.
     */
    public $language;

    public function __construct() {
        parent::__construct();
        $this->load->model('user_model');
        $this->load->library('simple_mail');
        
        // Set language
        if ( ! ($this->session->userdata('language') == 'vi')){
            $this->language = '';
        } else {
            $this->language = '_vi';
        }
    }

    public function index() {
        redirect('login');
    }

    public function login() {

        // Check if login
        if ($this->session->userdata('islogin')) {
            if ($this->session->userdata('role') == 'admin') {
                redirect('admin');
            } else if ($this->session->userdata('role') == 'organization') {
                redirect('organization');
            }
        }

        $this->load->helper(array('form', 'url'));
        $this->load->library('form_validation');
        $this->form_validation->set_rules('username', 'Username', 'required');
        $this->form_validation->set_rules('password', 'Password', 'required');

        if ($this->form_validation->run() == FALSE) {
            $this->load->view('user'.$this->language.'/login');
        } else {
            // Check username and password.
            $username = $this->input->post('username');
            $password = $this->input->post('password');
            $valid = $this->user_model->login($username, $password);

            if ($valid) {
                // Check role
                $userId = $this->user_model->getUserId($username);
                $roleId = $this->user_model->getRoleId($userId);
                $partnerId = $this->user_model->getPartnerId($userId);
                if ($roleId == 4) { // Organization
                    // Store to session
                    $sess_array = array(
                        'islogin' => TRUE,
                        'partner_id' => $partnerId,
                        'role' => "organization"
                    );
                    $this->session->set_userdata($sess_array);
                    // Load view
                    redirect("organization/index");
                } else if ($roleId == 3) { // Admin
                    // Store to session
                    $sess_array = array(
                        'islogin' => TRUE,
                        'role' => "admin",
                        'partner_id' => $partnerId,
                    );
                    $this->session->set_userdata($sess_array);
                    // Load view
                    redirect("admin/index");
                }
            } else {
                // Incorrect login
                $this->load->view('user'.$this->language.'/login');
            }
        }
    }

    public function logout() {
        // log the user out
        //$this->session->sess_destroy();
        
        // Just unset 'islogin'. Keep other variable.
        $this->session->unset_userdata('islogin');

        // redirect them back to the login page
        redirect('/user/login');
    }

    public function signup() {
        $this->load->helper(array('form', 'url'));

        $this->load->library('form_validation');

        $config = array(
            array(
                'field' => 'username',
                'label' => 'Username',
                'rules' => 'trim|required|min_length[6]|is_unique[userpartner.UserName]|xss_clean'
            ),
            array(
                'field' => 'password',
                'label' => 'Password',
                'rules' => 'trim|required|min_length[6]|max_length[32]'
            ),
            array(
                'field' => 'passconf',
                'label' => 'Confirm Password',
                'rules' => 'trim|required|matches[password]'
            ),
            array(
                'field' => 'name',
                'label' => 'Organization\'s Name',
                'rules' => 'trim|required'
            ),
            array(
                'field' => 'admin_name',
                'label' => 'Administrator Name',
                'rules' => 'trim|required'
            ),
            array(
                'field' => 'email',
                'label' => 'Contact Email',
                'rules' => 'trim|required'
            ),
            array(
                'field' => 'address',
                'label' => 'Organization\'s Address',
                'rules' => 'trim|required'
            ),
            array(
                'field' => 'phone',
                'label' => 'Phone Number',
                'rules' => 'trim|required'
            ),
            array(
                'field' => 'website',
                'label' => 'Website',
                'rules' => 'trim'
            ),
            array(
                'field' => 'type',
                'label' => 'Organization type',
                'rules' => ''
            ),
            array(
                'field' => 'description',
                'label' => 'Description',
                'rules' => 'trim|required'
            ),
        );

        $this->form_validation->set_rules($config);

        if ($this->form_validation->run() == FALSE) {
            $this->load->view('user'.$this->language.'/signup');
        } else {
            // Add user
            
            /*
             * Get user image: logo and icon
             */
            $logoImage = $this->upload_image('logo_image');
            $iconImage = $this->upload_image('icon_image');
            
            $partnerId = $this->user_model->register(
                    $this->input->post('username'), 
                    $this->input->post('password'), 
                    $this->input->post('name'), 
                    $this->input->post('admin_name'), 
                    $this->input->post('email'), 
                    $this->input->post('address'), 
                    $this->input->post('phone'), 
                    $this->input->post('website'), 
                    $this->input->post('type'), 
                    $this->input->post('description'),
                    $logoImage,
                    $iconImage
            );

            // Store to session
            $sess_array = array(
                'islogin' => TRUE,
                'partner_id' => $partnerId,
                'role' => "organization"
            );
            $this->session->set_userdata($sess_array);
                        
            /*
             *  Send mail stuff.
             * Not in use yet.
             *
            $this->sendWaitMail($this->input->post('email'));
            $this->sendAnnouceAdminMail('nguyenvanhungbkit@gmail.com');
            /*
             * End of mail stuff.
             */

            // Redirect to proper page.
            redirect('organization/profile#additional_information');
        }
    }
    
    //change password
    function change_password() {
        $this->form_validation->set_rules('old', 'Old password', 'required');
        $this->form_validation->set_rules('new', 'New password', 'required|matches[new_confirm]|min_length[6]|max_length[32]');
        $this->form_validation->set_rules('new_confirm', 'Confirm new password', 'required');

        if ( ! $this->session->userdata('islogin')) {
            redirect('login', 'refresh');
        }

        // Get the user ID
        $partnerId = $this->session->userdata('partner_id');

        if ($this->form_validation->run() == false) {
            //display the form
            //set the flash data error message if there is one
            $this->data['message'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('message');

            $this->data['min_password_length'] = $this->config->item('min_password_length', 'ion_auth');
            $this->data['old_password'] = array(
                'name' => 'old',
                'id' => 'old',
                'type' => 'password',
            );
            $this->data['new_password'] = array(
                'name' => 'new',
                'id' => 'new',
                'type' => 'password',
                'pattern' => '^.{6}.*$',
            );
            $this->data['new_password_confirm'] = array(
                'name' => 'new_confirm',
                'id' => 'new_confirm',
                'type' => 'password',
                'pattern' => '^.{6}.*$',
            );
            $this->data['user_id'] = array(
                'name' => 'user_id',
                'id' => 'user_id',
                'type' => 'hidden',
                'value' => $partnerId,
            );

            //render page base on role
            
            $this->render_page('user/change_password', $this->data);
        } else {
            $identity = $this->session->userdata($this->config->item('identity', 'ion_auth'));

            $change = $this->ion_auth->change_password($identity, $this->input->post('old'), $this->input->post('new'));

            if ($change) {
                //if the password was successfully changed
                $this->session->set_flashdata('message', $this->ion_auth->messages());
                $this->logout();
            } else {
                $this->session->set_flashdata('message', $this->ion_auth->errors());
                redirect('user/change_password', 'refresh');
            }
        }
    }
    
    /*
     * Upload image to server.
     * Return: the url of that image.
     * TODO : This stuff should lie in model.
     */
    public function upload_image($field){
        // Codeigniter config
        $config['upload_path'] = './assets/uploads/';
        $config['allowed_types'] = 'gif|jpg|png';
        $config['max_size']	= '1000';
        $config['max_width']  = '2024';
        $config['max_height']  = '1768';

        //set filename in config for upload
        $config['file_name'] = md5(time()+rand(1,10));
        
        $this->load->library('upload', $config);
                
        if ($this->upload->do_upload($field)){
            // Upload successful
            return '/assets/uploads/'.$this->upload->file_name;
        } else {
            // Upload error
            return false;
        }
    }
    
    /*
     * Upload to http://mytempbucket.s3.amazonaws.com/
     * Return json file
     */
    public function upload_s3($field) {

        //error_reporting(E_ALL);
        include_once('Upload.php');
        //print_r(get_declared_classes());
        // retrieve eventual CLI parameters
        $cli = (isset($argc) && $argc > 1);
        if ($cli) {
            if (isset($argv[1]))
                $_GET['file'] = $argv[1];
            if (isset($argv[2]))
                $_GET['dir'] = $argv[2];
            if (isset($argv[3]))
                $_GET['pics'] = $argv[3];
        }

        // set variables
        $dir_dest = (isset($_GET['dir']) ? $_GET['dir'] : 'test');
        $dir_pics = (isset($_GET['pics']) ? $_GET['pics'] : $dir_dest);

        // we have three forms on the test page, so we redirect accordingly
        if (true) {
            $handle = new Upload($_FILES[$field]);

            if ($handle->uploaded) {
                
                // Keep origin image, no resize. :)
                $handle->image_resize = false;
                $handle->image_ratio_y = true;
                $handle->image_x = 50;

                $handle->Process($dir_dest);

                // we check if everything went OK
                if ($handle->processed) {
                    $url = $dir_pics . '/' . $handle->file_dst_name;

                    //$this->load->library('s3_config');
                    $bucket = "mytempbucket";
                    if (!class_exists('S3')){
                        require_once('S3.php');
                    }

                    //AWS access info
                    if (!defined('awsAccessKey'))
                        define('awsAccessKey', 'AKIAJIWOJ6L32GWAUUUQ');
                    if (!defined('awsSecretKey'))
                        define('awsSecretKey', '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');

                    $s3 = new S3(awsAccessKey, awsSecretKey);
                    //$s3->putBucket($bucket, S3::ACL_PUBLIC_READ);
                    //Rename image name. 
                    $actual_image_name = time() . ".".$handle->file_src_name_ext;
                    
                    // Init result json file:
                    $result = array();
                    $result['code'] = -1;
                    $result['message'] = "";
                    $result['info'] = array();

                    if ($s3->putObjectFile($url, $bucket, $actual_image_name, S3::ACL_PUBLIC_READ)) {
                        // Upload successful
                        $s3file = 'http://' . $bucket . '.s3.amazonaws.com/' . $actual_image_name;
                        return $s3file;
                    } else{
                        // Upload error
                        return false;
                    }
                } else {
                    // one error occured
                    // Upload error
                    return false;
                }

                // we delete the temporary files
                $handle->Clean();
            } else {
                // if we're here, the upload file failed for some reasons
                // i.e. the server didn't receive the file
                return false;
            }
        } else {
            //echo "Something wrong";
        }
    }
    
    /**
     * Verify user by Email address
     */

    /**
     * Below are functions to send mail.
     * Actually this function should be run asynchronized make user feel comfortable.
     * Untill now, this function still run with main process, so that the process may
     * a little bit slow.
     */
    
    /*
     * Mail API to approve user.
     */
    public function sendApproveMail(){
        $approve = $this->input->post("is_approved");
        $email = $this->input->post('email');
        
        // Send mail.
        $sendState = false;
        if ($approve === '1'){
            $sendState = $this->sendSuccessMail($email);
        } else {
            $sendState = $this->sendDenyMail($email);
        }
        
        // Return result API
        $result = array();
        if ($sendState){ // Send mail successful
            $result['code'] = 1;
            $result['message'] = "Success";
        } else { // Send mail fail
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }    

    /**
     * Send mail to user announce that they had registered successfully. Now they will until
     * admin approve them.
     * Return 'true' if send mail successful. Otherwise, return 'false'.
     */
    private function sendWaitMail($emailTo) {
        $subject = 'Welcome to Hero for Zero Program';
        $message = 'Thank you for your time registering "for Hero for Zero" program. We will need some time to process your '
                . 'information before appoving your application. We will send you an email when your approval process complete.'
                . ' Best regards, "Hero for Zero" team.';
        
        // Send mail:
        return $this->simple_mail->sendMail($emailTo, $subject, $message);
    }

    /**
     * Send mail to admin announce that there are a new user registered.
     */
    private function sendAnnouceAdminMail($emailTo ){
        $subject = 'A new NGO registered in Hero for Zero Program';
        $message = 'Hi admin,'
                . 'There are a new NGO registered. Please go to admin panel (on http://www.heroforzero.be ) to approve or deny them.';
        
        // Send mail:
        return $this->simple_mail->sendMail($emailTo, $subject, $message);
    }

    /**
     * Send mail to user announce that they have been approved by the admin.
     */
    private function sendSuccessMail($emailTo) {
        $subject = 'You had been approved to Hero for Zero program';
        $message = 'Welcome to "Hero for Zero" program. You can visit page on http://www.heroforzero.be';
        
        // Send mail:
        return $this->simple_mail->sendMail($emailTo, $subject, $message);
    }

    /**
     * Send mail to user announce that they have been denied by the admin.
     */
    public function sendDenyMail($emailTo) {
        $subject = 'Hero for Zero program - Please sign up again.';
        $message = 'Some of your information may not correct so we cannot approve your account right now. '
                . 'Please consider to register again with more detail informaiton. '
                . 'Best regards,';
        
        // Send mail:
        return $this->simple_mail->sendMail($emailTo, $subject, $message);
    }
    /**
     * End of mail functions
     */
}
