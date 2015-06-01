<?php

/* Tan - Last 13-March-2014 */

class Activity_Model extends CI_Model {

    public static $ActivityId = array();

    public function __construct() {
        parent:: __construct();
    }

    /*     * ***SELECT**** */
    /* Last 14-March-2014 */
    /* 	Get System time */

    public function getTime() {
        $currentDate = date("Y-m-d H:i:s");
        return $currentDate;
    }

    /* 	Get a activity function from databases */

    public function getActivity($id) {
        $sql = 'CALL sp_Get_Activity(?)';
        $result = $this->db->query($sql, array($id));

        return $result->row();
    }

    /* 	Get Activity list function from databases */

    public function getActivityList($currentPage, $pageSize) {

        $currentPage = (int) $currentPage;
        $pageSize = (int) $pageSize;

        $sql = 'CALL sp_Get_ActivityList(?, ?)';
        $result = $this->db->query($sql, array($currentPage, $pageSize));

        return $result->result();
    }

    /* 	Get Activity list by Organization function from databases */

    public function getActivityListByOrganization($currentPage, $pageSize, $partnerId) {

        $currentPage = (int) $currentPage;
        $pageSize = (int) $pageSize;
        $partnerId = (int) $partnerId;


        $sql = 'CALL sp_Get_ActivityListByOrganization(?, ?, ?)';
        $result = $this->db->query($sql, array($currentPage, $pageSize, $partnerId));

        return $result->result();
    }

    public function getNumActivity() {
        mysqli_next_result($this->db->conn_id);
        return (int) $this->db->count_all('activity');
    }

    public function getNumActivityByOrganization($partnerId) {
        mysqli_next_result($this->db->conn_id);
        $this->db->where("PartnerId", $partnerId);
        $this->db->where("IsApproved", 1);
        $this->db->from('activity');
        return (int) $this->db->count_all_results();
    }

    /*     * ***INSERT**** */
    /* Last 13-March-2014 */

    /* 	Donation insert function */

    public function insertActivity($title, $description, $partner_id, $action_id, $action_content, $date) {

        try {
            $data = array(
                'PartnerId' => $partner_id,
                'Title' => $title,
                'Description' => $description,
                'ActionId' => $action_id,
                'BonusPoint' => 2,
                'IsApproved' => 0,
                'CreateDate' => $date,
                'ActionContent' => $action_content
            );
            $this->db->insert('activity', $data);
            
            // We not use this Stored Procedure.
//            $sql = 'CALL sp_Insert_Activity(?, ?, ?, ?, ?, ?)';
//            $result = $this->db->query($sql, array($title, $description, $partner_id,
//                $action_id, $action_content, $date));
            return 'Success';
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /*     * ***UPDATE**** */
    /* Last 17-March-2014 */
    /* Update activity function from Activity Table */

    public function updateActivity($Id, $partner_id, $title, $description, $action_id, $action_content, $point, $approve) {
        try {
            // Call sp_Update_BonusPoint_Quiz StoreProcedure
            $sql = 'Call sp_Update_Activity(?, ?, ?, ?, ?, ?, ?, ?)';
            $result = $this->db->query($sql, array($Id, $partner_id, $title, $description,
                $action_id, $action_content, $point, $approve));
            return "Success";
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /* Update BonusPoint function from Activity Table */

    public function updateBonusPoint($Id, $BonusPoint) {
        try {
            // Call sp_Update_BonusPoint_Quiz StoreProcedure
            $sql = 'Call sp_Update_BonusPoint_Activity(?, ?)';
            $result = $this->db->query($sql, array($Id, $BonusPoint));
            return "Success";
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /* Update IsApproved function from Activity Table */

    // Last 18-March-2014
    public function updateIsApproved($Id, $IsApproved) {
        try {
            // Call sp_Update_ActivityApprove StoreProcedure
            $sql = 'Call sp_Update_ActivityApprove(?, ?)';
            $result = $this->db->query($sql, array($Id, $IsApproved));
            return "Success";
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /*     * **DELETE*** */
    /* Last 12-March-2014 */
    /* Delete Activity function */

    public function deleteActivity($Id) {
        try {
            $sql = 'CALL sp_Delete_Activity(?)';
            $result = $this->db->query($sql, array($Id));

            return 'Success';
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

}

?>