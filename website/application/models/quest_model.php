<?php

class Quest_Model extends CI_Model {

    public function __construct() {
        parent::__construct();
    }

    /*
      Last Edit 16-Oct-2013
     */

    public function getSpecialQuestData($questId) {
        $sql = 'SELECT id, `name`, points FROM quest WHERE id = ?';
        $result = $this->db->query($sql, array($questId));
        
        return $result->row();
    }

    /*
      Last Edit 17-Oct-2013
     */

    public function getQuestReferData($questId) {
        $sql = 'CALL sp_getquestrefer(?)';
        $result = $this->db->query($sql, array($questId));
        return $result->result();
    }

    /* Last Edit 17-Oct-2013 */

    public function getQuestData($currentPage, $pageSize) {
        try {
			$currentPage = (int) $currentPage;
			$pageSize = (int) $pageSize;
            $sql = 'CALL sp_paginationquest(?, ?)';
            $result = $this->db->query($sql, array($currentPage, $pageSize));
            return $result->result();
        } catch (PDOException $e) {
            return $e->getMessage();
        }
    }

    /* Last Edit 18-Oct-2013 */

    public function updateAcceptQuest($userId, $questId, $parentQuestId) {

        $sql = 'CALL sp_useracceptquest(?, ?, ?)';
        $result = $this->db->query($sql, array($userId, $questId, $parentQuestId));

        return $result->row();
    }

    /* Last Edit 18-Oct-2013 */

    public function updateStatus($userId, $questId) {

        $sql = 'CALL sp_usercompletequest(?, ?)';
        $result = $this->db->query($sql, array($userId, $questId));
        return $result->row();
    }

    public function getAcceptQuestOfUser($userId) {
        $sql = 'CALL sp_allquestofuseraccept(?)';
        $result = $this->db->query($sql, array($userId));
        return $result->result();
    }
    
    // Get quest list for one specific user.
    public function getQuestDatabyUser($currentPage, $pageSize, $userId) {
        try {
            $rowNumber = (int) $currentPage*$pageSize;
            $pageSize = (int) $pageSize;
            $sql = 'SELECT * FROM quest WHERE quest_owner_id = ? AND !isnull(parent_quest_id)
                ORDER BY id DESC LIMIT ?, ?';
            $result = $this->db->query($sql, array($userId, $rowNumber, $pageSize));
            return $result->result();
        } catch (PDOException $e) {
            return $e->getMessage();
        }
    }
    
    // Get number of quest for one specific user.
    public function getQuestCountbyUser($userId) {
        try {
            $sql = 'SELECT COUNT(*) FROM quest WHERE quest_owner_id = ? AND !isnull(parent_quest_id)';
            //$stmt = $this->db->prepare($sql);
            //$stmt->bindparam(':userId', $userId, PDO::PARAM_INT);
            
            $result = $this->db->query($sql, array($userId));
            return $result->result();
        } catch (PDOException $e) {
            return $e->getMessage();
        }
    }
    
    // Get detail information of one quest
    public function getQuestDetail($questId) {
        $sql = 'SELECT * FROM quest WHERE id = ?';
        $result = $this->db->query($sql, array($questId));
        return $result->row();
    }
    
    // Activate or deactivate state of quest
    public function updateQuestState($questId, $state){
        $sql = 'UPDATE quest SET state= ? WHERE id= ?';
        $result = $this->db->query($sql, array($state, $questId));

        return "success";
    }

}

