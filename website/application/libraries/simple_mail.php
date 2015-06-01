<?php

defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * This libray provide simple method to send mail.
 * This has been test successfully with Google Mail.
 */
class Simple_Mail {

    public function __construct() {
        
        // get Codeigniter instance
        $this->CI = & get_instance();
        
        $this->CI->load->library('email');
    }
    
    // Simple function to send a mail to user.
    public function sendMail($email_to, $subject, $message) {
        
        // Some mail config:
        $emailAccount =  'heroforzero.vn@gmail.com';
        $emailPassword = 'oceanfour';
        $nameDisplay = 'Hero for Zero Program';
        
        $config['protocol'] = 'smtp';       // Using protocol SMTP for send mail
        $config['smtp_host'] = 'smtp.gmail.com';
        $config['smtp_crypto'] = 'tls';     // Choose way for send mail
        $config['smtp_port'] = '25';
        $config['smtp_timeout'] = '7';
        $config['smtp_user'] = $emailAccount;  // name's user using send mail with SMTP
        $config['smtp_pass'] = $emailPassword;  // Password of user
        $config['charset'] = 'utf-8';
        $config['newline'] = "\r\n";
        $config['mailtype'] = 'text';       // or html
        $config['validation'] = TRUE;       // bool whether to validate email or not      

        // Making mail content.
        $this->CI->email->initialize($config);

        $this->CI->email->from($emailAccount, $nameDisplay);
        $this->CI->email->to($email_to);

        $this->CI->email->subject($subject);
        $this->CI->email->message($message);

        // Start sending mail. This will block process for a while.
        return $this->CI->email->send();
    }

    /* SEND EMAIL FUNCTION USING SMTP */
    // Not in use.
    public function sendMail2($smtp_user, $smtp_pass, $email_from, $email_to, $nameDislay, $subject, $message) {


        /*
          $config['protocol']    = 'smtp';
          $config['smtp_host']    = 'smtp.gmail.com';
          $config['smtp_crypto']  = 'tls';
          $config['smtp_port']    = '25';
          $config['smtp_timeout'] = '7';
          $config['smtp_user']    = 'lengoctan92@gmail.com';
          $config['smtp_pass']    = '';
          $config['charset']    = 'utf-8';
          $config['newline']    = "\r\n";
          $config['mailtype'] = 'text'; // or html
          $config['validation'] = TRUE; // bool whether to validate email or not

          $this->email->initialize($config);

          $this->email->from('lengoctan92@gmail.com', 'myname');
          $this->email->to('lengoctan1992@gmail.com');

          $this->email->subject('Email Test');
          $this->email->message('Testing the email class.');
          //$this->email->attach('logo.png');
         */


        $config['protocol'] = 'smtp'; // Using protocol SMTP for send mail
        $config['smtp_host'] = 'smtp.gmail.com';
        $config['smtp_crypto'] = 'tls'; // Choose way for send mail
        $config['smtp_port'] = '25';
        $config['smtp_timeout'] = '7';
        $config['smtp_user'] = $smtp_user; // name's user using send mail with SMTP
        $config['smtp_pass'] = $smtp_pass; // Password of user
        $config['charset'] = 'utf-8';
        $config['newline'] = "\r\n";
        $config['mailtype'] = 'text'; // or html
        $config['validation'] = TRUE; // bool whether to validate email or not      

        $this->email->initialize($config);

        $this->email->from($email_from, $nameDislay);
        $this->email->to($email_to);

        $this->email->subject($subject);
        $this->email->message($message);
        // Specifying a file to be attached with the email
        //$file = FCPATH . 'license.txt';
        //$this->email->attach('');


        $this->email->send();

        if ($this->email->send()) {

            echo 'Your email was sent, successfully.';
        } else {

            show_error($this->email->print_debugger());
        }
    }

    /* INSERT FILE TO GOOGLE DRIVE USING GOOGLE DRIVE API */

    public function insertFile($title, $description, $pathFile) {

        $this->CI->load->add_package_path(APPPATH . 'google-api-php-client/src/');
        $this->CI->load->library('Google_Client');

        $client = new Google_Client();
        // Get your credentials from the console
        $client->setClientId('53163767342-q86vvesolleftv46ujhu4sunqopqn0qh.apps.googleusercontent.com');
        $client->setClientSecret('YNozbYfBwiHXz-RWOlS3pGY-');
        $client->setRedirectUri('http://localhost:1443/travel_hero/index.php/user/insertFile');
        $client->setScopes(array('https://www.googleapis.com/auth/drive'));

        $service = new Google_DriveService($client);

        $authUrl = $client->createAuthUrl();

        //Request authorization
        //print "Please visit:\n$authUrl\n\n";
        //print "Please enter the auth code:\n";
        $authCode = trim(fgets(STDIN));

        // Exchange authorization code for access token
        $accessToken = $client->authenticate($authCode);
        $client->setAccessToken($accessToken);


        //Insert a file
        $file = new Google_DriveFile();
        $file->setTitle($title);
        $file->setDescription($description);
        $file->setMimeType('text/plain');

        $data = file_get_contents($pathFile);

        $createdFile = $service->files->insert($file, array(
            'data' => $data,
            'mimeType' => 'text/plain',
        ));
    }

    /* INSERT VIDEO TO YOUTUBE USING YOUTUBE API */

    public function insertVideo() {
        session_start();

        //$this->load->add_package_path(APPPATH.'Zend/');
        $this->CI->load->library('Loader');
        $this->CI->load->library('Media');
        $this->CI->load->library('App');
        $this->CI->load->library('Gdata');
        // the Zend dir must be in your include_path

        Zend_Loader::loadClass('Zend_Gdata_YouTube');

        Zend_Loader::loadClass('Zend_Gdata_AuthSub');

        Zend_Loader::loadClass('Zend_Gdata_ClientLogin');

        $httpClient = Zend_Gdata_ClientLogin::getHttpClient(
                        'lengoctan1992@gmail.com', 'lengoctan', 'youtube' // service name
        );

        $applicationId = 'video 1';
        $clientId = '53163767342-4gbvjjttp9vlqr0ejg97ll9mpd9rhiha.apps.googleusercontent.com';
        $developerKey = 'AIzaSyCbuFPkd0piRv7gTdXUc5tyM8zYvQu0fVU';
        $yt = new Zend_Gdata_YouTube($httpClient, $applicationId, $clientId, $developerKey);





        //$yt = new Zend_Gdata_YouTube($httpClient);


        $myVideoEntry = new Zend_Gdata_YouTube_VideoEntry();
        $myVideoEntry->setVideoTitle('tan3');
        $myVideoEntry->setVideoDescription('tien trinh 2');

        // Note that category must be a valid YouTube category
        $myVideoEntry->setVideoCategory('Comedy');
        $myVideoEntry->SetVideoTags('cars, funny');

        $tokenHandlerUrl = 'http://gdata.youtube.com/action/GetUploadToken';
        $tokenArray = $yt->getFormUploadToken($myVideoEntry, $tokenHandlerUrl);
        $tokenValue = $tokenArray['token'];
        $postUrl = $tokenArray['url'];

        // place to redirect user after upload
        $nextUrl = 'http://localhost:1443/youtube-api-samples/samples/php/my_uploads.php';

        echo '<form action="' . $postUrl . '?nexturl=' . $nextUrl .
        '" method="post" enctype="multipart/form-data">' .
        '<input name="file" type="file"/>' .
        '<input name="token" type="hidden" value="' . $tokenValue . '"/>' .
        '<input value="Upload Video File" type="submit" />' .
        '</form>';

        //echo $form;
    }

}
