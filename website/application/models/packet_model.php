<?php

/* Tan - Last 18-March-2014 */

class Packet_Model extends CI_Model {

    public function __construct() {
        parent:: __construct();
    }

    /*     * ***SELECT**** */
    /* Last 18-March-2014 */

    /* 	Get Packet list function from databases */

    public function getPacketList($currentPage, $pageSize) {

        $currentPage = (int) $currentPage;
        $pageSize = (int) $pageSize;

        $sql = 'CALL sp_Get_PacketList(?, ?)';
        $result = $this->db->query($sql, array($currentPage, $pageSize));

        return $result->result();
    }
    
    /* 	Get Packet availble (have <3 quests) list function from databases */

    public function getPacketAvailableList($currentPage, $pageSize) {

        $currentPage = (int) $currentPage;
        $pageSize = (int) $pageSize;

        $sql = 'CALL sp_Get_PacketAvailableList(?, ?)';
        $result = $this->db->query($sql, array($currentPage, $pageSize));

        return $result->result();
    }
    
     public function getNumPacket(){
        mysqli_next_result($this->db->conn_id);
        return (int) $this->db->count_all('packet');
    }

    /*     * ***INSERT**** */
    /* Last 18-March-2014 */
    /* 	Packet insert function */

    public function insertPacket($title, $imageUrl, $partner_id) {

        try {
            $sql = 'CALL sp_Insert_Packet(?, ?, ?)';
            $result = $this->db->query($sql, array($title, $imageUrl, $partner_id));
            return 'Success';
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }
    
    public function updatePacket($id, $title, $imageUrl, $partner_id){
        try {
            if ($imageUrl == NULL){
                $sql = 'UPDATE `packet` SET Title = ? WHERE `packet`.`Id` = ?';
                $result = $this->db->query($sql, array($title, $id));
            } else {
                $sql = 'UPDATE `packet` SET Title = ?, `ImageURL` = ? WHERE `packet`.`Id` = ?';
                $result = $this->db->query($sql, array($title, $imageUrl, $id));
            }
            
            return 'Success';
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }
    
    public function getPacket($id){

        $sql = 'SELECT * FROM `packet` WHERE `packet`.`Id` = ?';
        $result = $this->db->query($sql, $id);

        return $result->row();
    }

}

?>	