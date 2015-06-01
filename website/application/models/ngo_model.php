<?php

class Ngo_Model extends CI_Model {

    public function __construct() {
        parent::__construct();
    }

    public function getUserDataWithEmail($username, $password) {
        $sql = "CALL sp_getuserdatawithemail(?, ?)";
        $result = $this->db->query($sql, array($username, $password));
        return $result->row();
    }

    public function getUserDataWithFacebookId($facebookId) {
        $sql = 'CALL sp_getuserdatawithfacebook(?)';
        $result = $this->db->query($sql, array($facebookId));
        return $result->row();
    }

    public function checkInfoExistsWithEmail($fullName, $heroName, $email, $phone, $password) {
        try {
            $sql = 'CALL sp_checksignupwithemailinfo(?,?,?,?,?)';
            $result = $this->db->query($sql, array($fullName, $heroName, $email, $phone, $password));
            return $result->row();
        } catch (PDOException $e) {
            return $e->getMessage();
        }
    }

    /* Last Edit 17-Oct-2013 */

    public function checkInfoExistsWithFacebookId($facebookId, $fullName, $heroName, $email) {
        try {
            $sql = 'CALL sp_checksignupwithfacebookinfo(?, ?, ?, ?)';
            
            $result = $this->db->query($sql, array($facebookId, $fullName, $heroName, $email));
            return $result->row();
        } catch (PDOException $e) {
            return $e->getMessage();
        }
    }

    public function getHotelAgodaData($currentPage, $pageSize, $lat, $lon, $distance, $countryisocode) {
        try {
            $sql = 'CALL sp_paginationhotelagodabydistance(?, ?, ?, ?, ?, ?)';
            $result = $this->db->query($sql, array($currentPage, $pageSize, $lat, $lon, $distance, $countryisocode));
            return $result->result();
        } catch (PDOException $e) {
            return $e->getMessage();
        }
    }

    /* Get Leader board Last Edit 22-Oct-2013 */

    public function getLeaderBoard() {
        $sql = 'SELECT * FROM user ORDER BY user.points DESC LIMIT 10';
        $result = $this->db->query($sql);
        return $result->result();
    }

}

