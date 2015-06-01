<?php

/* Tan - Last 12-March-2014 */

class Partner_Model extends CI_Model {

    public function __construct() {
        parent:: __construct();
    }

    /*     * ***SELECT**** */
    /* Last 18-March-2014 */
    /* 	Get System time */

    public function getTime() {
        $currentDate = date("Y-m-d H:i:s");
        return $currentDate;
    }

    /* 	Get a partner function from databases */

    public function getPartner($id) {
        $sql = 'CALL sp_Get_Partner(?)';
        $result = $this->db->query($sql, array($id));

        return $result->row();
    }
    
    public function getPartnerTable($id){
        $sql = "SELECT * FROM partner WHERE Id = ?";
        $result = $this->db->query($sql, $id);
        
        return $result->row();
    }

    /* 	Get partner list function from databases */

    public function getPartnerList($currentPage, $pageSize) {

        $currentPage = (int) $currentPage;
        $pageSize = (int) $pageSize;

        $sql = 'CALL sp_Get_PartnerList(?, ?)';
        $result = $this->db->query($sql, array($currentPage, $pageSize));

        return $result->result();
    }
    
    public function getNumPartner(){
        mysqli_next_result($this->db->conn_id);
        return (int) $this->db->count_all('partner');
    }

    /* Update IsApproved function from Partner Table */

    // Last 18-March-2014
    public function updateIsApproved($Id, $IsApproved) {
        try {
            // Call sp_Update_Partner_IsApproved StoreProcedure
            $sql = 'Call sp_Update_Partner_IsApproved(?, ?)';
            $result = $this->db->query($sql, array($Id, $IsApproved));
            return "Success";
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }
    
    public function getPartnerExt($partnerId){
        $query = $this->db->get_where('partner_ext', array('partner_id'=>$partnerId));
        return $query->row();
    }
    
    public function getPartnerExtList(){
        $this->db->select("*");
        $this->db->from('partner_ext');
        $this->db->join('partner', 'partner.Id = partner_ext.partner_id');
        
        $query = $this->db->get();
        return $query->result_array();
    }
    
    public function updatePartnerExt($id, $fanpage, $message, $link, $paypal, $address){
        $data = array(
            'partner_id' => $id,
            'fanpage' => $fanpage,
            'donation_message' => $message,
            'donation_link' => $link,
            'donation_paypal' => $paypal,
            'donation_address' => $address
        );
        
        $query = $this->db->get_where('partner_ext', array('partner_id'=>$id));
        
        if ($query->row_array()){
            $this->db->where('partner_id', $id);
            return $this->db->update('partner_ext', $data);
        } else {
            return $this->createPartnerExt($id, $fanpage, $message, $link, $paypal, $address);
        }
    }
    
    public function createPartnerExt($id, $fanpage, $message, $link, $paypal, $address){
        $data = array(
            'partner_id' => $id,
            'fanpage' => $fanpage,
            'donation_message' => $message,
            'donation_link' => $link,
            'donation_paypal' => $paypal,
            'donation_address' => $address
        );
        return $this->db->insert('partner_ext', $data);      
    }
    
    public function updatePartner($id, $name, $logo, $icon, $admin, $email, $address, $phone,$website,$type, $description){
        // We will update in multiple table
        // 'partner' table
        $data = array(
            'PartnerName' => $name,
            'LogoURL' => $logo,
            'IconURL' => $icon,
            'AdminName' => $admin,
            'Address' => $address,
            'PhoneNumber' => $phone,
            'WebsiteURL' => $website,
            'OrganizationTypeId' => $type,
            'Description' => $description
        );
        $this->db->where('id', $id);
        $this->db->update('partner', $data);
        
        // 'user' table        
        // Get user ID
        $query = $this->db->get_where('userpartner', array('PartnerId'=>$id));
        $userId = $query->row()->UserId;
        $dataUser = array(
            'Email' => $email
        );
        $this->db->where('id', $userId);
        $this->db->update('user', $dataUser);
        
        return true;
    }
    
    public function deletePartner($partnerId){
        // We will delete from multiple (5) table
        // Because we don't set foreign key between table so we can easily delete
        // table one by one without worrying about foreign key constraint.
        
        // Get user ID
        $query = $this->db->get_where('userpartner', array('PartnerId'=>$partnerId));
        $result = $query->row();
        if ($result){
            $userId = $result->UserId;
        } else {
            $userId = 0;
        }
        
        $this->db->trans_start();
        
        // user role
        $this->db->delete('userrole', array('UserId'=>$userId));
        // user
        $this->db->delete('user', array('Id'=>$userId));
        // userpartner
        $this->db->delete('userpartner', array('PartnerId'=>$partnerId));
        // partner
        $this->db->delete('partner', array('Id'=>$partnerId));
        // partner_ext
        $this->db->delete('partner_ext', array('partner_id'=>$partnerId));
        
        $this->db->trans_complete();
        
        if ($this->db->trans_status() === FALSE) {
            return FALSE;
        }
        return TRUE;
    }
    
}