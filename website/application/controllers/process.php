<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Process extends App_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->helper(array('form', 'url'));
    }

    /*
     * Upload photo to same folder of source code. :)
     */

    public function upload() {
        // Codeigniter config
        $config['upload_path'] = './assets/uploads/';
        $config['allowed_types'] = 'gif|jpg|png';
        //$config['max_size'] = '1000';
        //$config['max_width'] = '2048';
        //$config['max_height'] = '1768';
        //set filename in config for upload
        $config['file_name'] = md5(time());

        $this->load->library('upload', $config);
        $this->upload->initialize($config);

        // Init result json file:
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        if ($this->upload->do_upload()) {

            // Upload successful
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info'] = array(
                'file_name' => $this->config->base_url() . "assets/uploads/" . $this->upload->file_name
            );
        } else {
            // Upload error
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info'] = $this->upload->display_errors();
        }

        echo json_encode($result);
    }

    function test() {
        $result = array();
        $result["name"] = $this->input->post("name");
        echo json_encode($result);
    }

    /*
     * Upload photo to same folder of source code. :)
     */

    public function upload_files() {
        // Codeigniter config
        $config['upload_path'] = './assets/uploads/';
        $config['allowed_types'] = 'gif|jpg|png';
        //$config['max_size'] = '1000';
        //$config['max_width'] = '2024';
        //$config['max_height'] = '1768';
        //set filename in config for upload
        $config['file_name'] = array(md5(time() + 1), md5(time()));

        $this->load->library('upload', $config);
        $this->upload->initialize($config);
        
        $postParams = $this->input->post();

        // Init result json file:
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        if ($this->upload->do_multi_upload('userfile')) {
            // Upload successful
            $uploadInfo = $this->upload->get_multi_upload_data();
            $result['code'] = 1;
            $result['message'] = "Success";
            $fileNames = array();
            foreach ($uploadInfo as $info) {
                $fileNames[] = $this->config->base_url()."assets/uploads/".$info['file_name'];
            }
            $result['info'] = array(
                'file_name' => $fileNames,
                'post' => $postParams
                    );
        } else {
            // Upload error
            $result['code'] = 0;
            $result['message'] = "Fail";
        }

        echo json_encode($result);
    }

    /*
     * Upload to http://mytempbucket.s3.amazonaws.com/
     * Return json file
     */

    public function upload_s3() {

        //error_reporting(E_ALL);
        error_reporting(E_ERROR | E_PARSE);
        include('Upload.php');

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
            $handle = new Upload($_FILES['userfile']);

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
                    if (!class_exists('S3'))
                        require_once('S3.php');

                    //AWS access info
                    if (!defined('awsAccessKey'))
                        define('awsAccessKey', 'AKIAJIWOJ6L32GWAUUUQ');
                    if (!defined('awsSecretKey'))
                        define('awsSecretKey', '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');

                    $s3 = new S3(awsAccessKey, awsSecretKey);
                    //$s3->putBucket($bucket, S3::ACL_PUBLIC_READ);
                    //Rename image name. 
                    $actual_image_name = time() . "." . $handle->file_src_name_ext;

                    // Init result json file:
                    $result = array();
                    $result['code'] = -1;
                    $result['message'] = "";
                    $result['info'] = array();

                    if ($s3->putObjectFile($url, $bucket, $actual_image_name, S3::ACL_PUBLIC_READ)) {
                        $s3file = 'http://' . $bucket . '.s3.amazonaws.com/' . $actual_image_name;

                        // Upload successful
                        $result['code'] = 1;
                        $result['message'] = "Success";
                        $result['info'] = array(
                            'file_name' => $s3file
                        );
                    } else {
                        // Upload error
                        $result['code'] = 0;
                        $result['message'] = "Fail";
                        $result['info'] = $handle->error;
                    }
                } else {
                    // one error occured
                    // Upload error
                    $result['code'] = 0;
                    $result['message'] = "Fail";
                    $result['info'] = $handle->error;
                }

                // we delete the temporary files
                $handle->Clean();
            } else {
                // if we're here, the upload file failed for some reasons
                // i.e. the server didn't receive the file
                echo '  Error: ' . $handle->error . '';
            }
        } else {
            //echo "Something wrong";
        }
        echo json_encode($result);
    }

    public function upload_image() {
        $this->current_section = 'upload_image';
        //$this->assets_js[] = '';
        $this->assets_js[] = 'upload_images/ajax_upload.js';
        $this->assets_css[] = 'admin.css';
        $this->render_page_admin('test_upload');
    }

    public function uploadfunction() {

        //error_reporting(E_ALL);
        include('Upload.php');

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
        if ((isset($_POST['action']) ? $_POST['action'] : (isset($_GET['action']) ? $_GET['action'] : '')) == 'simple') {
            $handle = new Upload($_FILES['my_field']);

            if ($handle->uploaded) {

                // Resize image
                $handle->image_resize = true;
                $handle->image_ratio_y = true;
                $handle->image_x = 50;

                $handle->Process($dir_dest);

                // we check if everything went OK
                if ($handle->processed) {
                    $url = $dir_pics . '/' . $handle->file_dst_name;

                    //$this->load->library('s3_config');
                    $bucket = "mytempbucket";
                    if (!class_exists('S3'))
                        require_once('S3.php');

                    //AWS access info
                    if (!defined('awsAccessKey'))
                        define('awsAccessKey', 'AKIAJIWOJ6L32GWAUUUQ');
                    if (!defined('awsSecretKey'))
                        define('awsSecretKey', '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');

                    $s3 = new S3(awsAccessKey, awsSecretKey);
                    //$s3->putBucket($bucket, S3::ACL_PUBLIC_READ);
                    //Rename image name. 
                    $actual_image_name = time() . "." . $handle->file_dst_name;

                    if ($s3->putObjectFile($url, $bucket, $actual_image_name, S3::ACL_PUBLIC_READ)) {
                        $s3file = 'http://' . $bucket . '.s3.amazonaws.com/' . $actual_image_name;
                        echo "<p style='color: blue'>Image upload successfull.</p><img id='imgPreview' src='" . $s3file . "'/>";
                    } else
                        echo '<p style="color: red">S3 Upload Fail.</p>';
                } else {
                    // one error occured
                    echo '  Error: ' . $handle->error . '';
                }

                // we delete the temporary files
                $handle->Clean();
            } else {
                // if we're here, the upload file failed for some reasons
                // i.e. the server didn't receive the file
                echo '  Error: ' . $handle->error . '';
            }
        }
    }

}
