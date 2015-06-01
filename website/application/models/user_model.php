<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class User_model extends CI_Model {

    public function __construct() {
        parent::__construct();
        $this->load->database();
    }

    function login($username, $password) {
        $this->db->select('UserId, PartnerId, UserName, Password');
        $this->db->from('userpartner');
        $this->db->where('UserName', $username);
        $this->db->where('Password', md5($password));
        $this->db->limit(1);

        $query = $this->db->get();

        if ($query->num_rows() == 1) {
            return $query->result();
        } else {
            return false;
        }
    }
    
    function getRoleId($userId){
        $this->db->select("RoleId");
        $this->db->from("userrole");
        $this->db->where("UserId", $userId);
        $this->db->limit(1);
        $query = $this->db->get();
        
        if ($query->num_rows() == 1){
            return (int) $query->row()->RoleId;
        } else {
            return FALSE;
        }
    }
    
    function getUserId($username){
        $this->db->select("UserId");
        $this->db->from("userpartner");
        $this->db->where("UserName", $username);
        $this->db->limit(1);
        $query = $this->db->get();
        
        if ($query->num_rows() == 1){
            return (int) $query->row()->UserId;
        } else {
            return FALSE;
        }
    }
    
    function getPartnerId($userId){
        $this->db->select("PartnerId");
        $this->db->from("userpartner");
        $this->db->where("UserId", $userId);
        $this->db->limit(1);
        $query = $this->db->get();
        
        if ($query->num_rows() == 1){
            return (int) $query->row()->PartnerId;
        } else {
            return FALSE;
        }
    }
    
    function changePassword($partnerId, $old, $new){
        $this->db->select('Password');
        $this->db->from('userpartner');
        $this->db->where('PartnerId', $partnerId);
        $this->db->limit(1);
        $query = $this->db->get();

        if ($query->num_rows() == 1){
            $password = $query->row()->Password;
            if (md5($old) == $password){
                // Correct password
                $data = array(
                    'Password' => md5($new),
                );
                $this->db->where('PartnerId', $partnerId);
                $this->db->update("userpartner", $data);
                return TRUE;
            }
        }
        return FALSE;
    }
    
    /*
     * Register user.
     * Not use AdminName field yet. :)
     */
    function register($username, $password, $name, $adminName, $email, $address, $phone, $website, $type, $description, $logoImage, $iconImage){
        // Save to user table
        $dataUser = array(
            'Email'=> $email,
            'RegisterDate' => date("Y-m-d H:i:s"),
            'PhoneNumber' => $phone
        );
        $this->db->insert("user", $dataUser);
        $userId = $this->db->insert_id();
        
        // Save to userRole table: Here default is 4=partner
         $dataRole = array(
            'UserId'=> $userId,
            'RoleId' => 4
        );
        $this->db->insert("userrole", $dataRole);
        
        // Save to Partner table
        $dataPartner = array(
            'PartnerName'=> $name,
            'OrganizationTypeId' => $type,
            'Description' => $description,
            'Address' => $address,
            'PhoneNumber' => $phone,
            'WebsiteURL' => $website,
            'LogoURL' => $logoImage,
            'IconURL' => $iconImage,
            'AdminName' => $adminName
        );
        $this->db->insert("partner", $dataPartner);
        $partnerId = $this->db->insert_id();
        
        // Save to userpartner table
        $data = array(
            'UserId'=> $userId,
            'PartnerId' => $partnerId,
            'UserName' => $username,
            'Password' => md5($password),
        );
        $this->db->insert("userpartner", $data);
        return $partnerId;
    }

}

?>
