<?php

// Author: Hau
// Start date: 10-April-2014

class Service_Model extends CI_Model {

    public function __construct() {
        parent:: __construct();
    }

    public function getTestById($id) {
        $sql = 'SELECT * FROM testtable WHERE id = ?';
        $result = $this->db->query($sql, array($id));

        return $result->row();
    }

	/*  Update quest status*/

    public function updateQuestStatus($userId, $questId, $questStatus) {
        try {
            $sql = 'CALL sp_UpdateQuestStatus(?,?,?)';
            $result = $this->db->query($sql, array($userId, $questId, $questStatus));
            return 'Success';
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }
    /*  Insert award for user  */

    public function insertMedal($userId, $medalId) {
        try {
            $sql = 'CALL sp_InsertMedal(?,?)';
            $result = $this->db->query($sql, array($userId, $medalId));
            if ($result->row()->iStatus == 1){
                return 'Existed';
            } else {
                return 'Success';
            }
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /* 	Get Activity list function from databases */

    public function getOrganizationList($currentPage, $pageSize) {

        $currentPage = (int) $currentPage;
        $pageSize = (int) $pageSize;

        $sql = 'CALL sp_GetOrganizationList(?, ?)';
        $result = $this->db->query($sql, array($currentPage, $pageSize));

        return $result->result();
    }

    public function getPacketsBy($rowIndex, $pageSize) {
        $result = array(array());

        $rowIndex = (int) $rowIndex;
        $pageSize = (int) $pageSize;

        $resultPackets = $this->db->query('CALL sp_getPacketsBy(?,?)', array($rowIndex, $pageSize));

        $indexPacket = -1;
        $indexQuest = -1;
        $indexCondition = -1;

        $pId = -1;
        $vId = -1;
        //$cId = -1;

        if ($resultPackets->num_rows() > 0) {

            foreach ($resultPackets->result_array() as $row) {

                if ($pId != $row['pId']) {

                    $pId = $row['pId'];
                    $indexPacket++;

                    $result[$indexPacket]['Id'] = $row['pId'];
                    $result[$indexPacket]['Title'] = $row['pTitle'];
                    $result[$indexPacket]['ImageURL'] = $row['pImageURL'];

                    $vId = $row['vId'];
                    $indexQuest = 0;

                    $result[$indexPacket]['Quests'][$indexQuest]['Id'] = $row['vId'];
                    $result[$indexPacket]['Quests'][$indexQuest]['vQuestName'] = $row['vQuestName'];
                    $result[$indexPacket]['Quests'][$indexQuest]['vPacketId'] = $row['vPacketId'];
                    $result[$indexPacket]['Quests'][$indexQuest]['vPartnerId'] = $row['vPartnerId'];
                    $result[$indexPacket]['Quests'][$indexQuest]['vAnimationId'] = $row['vAnimationId'];
                    $result[$indexPacket]['Quests'][$indexQuest]['UnlockPoint'] = $row['vUnlockPoint'];
                    $result[$indexPacket]['Quests'][$indexQuest]['vCreateDate'] = $row['vCreateDate'];
                    $result[$indexPacket]['Quests'][$indexQuest]['ImageUrl'] = $row['questImageUrl'];
                    $result[$indexPacket]['Quests'][$indexQuest]['MedalId'] = $row['medalId'];

                    $indexCondition = 0;

                    $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['Id'] = $row['cId'];
                    $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['Type'] = $row['cType'];
                    $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['Value'] = $row['cValue'];
                    $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['cVirtualQuestId'] = $row['cVirtualQuestId'];
                    $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['ObjectId'] = $row['cObjectId'];
                } else {

                    if ($vId == $row['vId']) {

                        //
                        //Van con condition chua nap
                        // Tang indexCondition len 1
                        $indexCondition++;

                        $vId = $row['vId'];
                        $pId = $row['pId'];

                        $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['Id'] = $row['cId'];
                        $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['Type'] = $row['cType'];
                        $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['Value'] = $row['cValue'];
                        $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['cVirtualQuestId'] = $row['cVirtualQuestId'];
                        $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['ObjectId'] = $row['cObjectId'];
                    } else {

                        // tang indexQuest
                        $indexQuest++;
                        $vId = $row['vId'];
                        $pId = $row['pId'];

                        // nap quest
                        $result[$indexPacket]['Quests'][$indexQuest]['Id'] = $row['vId'];
                        $result[$indexPacket]['Quests'][$indexQuest]['vQuestName'] = $row['vQuestName'];
                        $result[$indexPacket]['Quests'][$indexQuest]['vPacketId'] = $row['vPacketId'];
                        $result[$indexPacket]['Quests'][$indexQuest]['vPartnerId'] = $row['vPartnerId'];
                        $result[$indexPacket]['Quests'][$indexQuest]['vAnimationId'] = $row['vAnimationId'];
                        $result[$indexPacket]['Quests'][$indexQuest]['UnlockPoint'] = $row['vUnlockPoint'];
                        $result[$indexPacket]['Quests'][$indexQuest]['vCreateDate'] = $row['vCreateDate'];
                        $result[$indexPacket]['Quests'][$indexQuest]['ImageUrl'] = $row['questImageUrl'];
                        $result[$indexPacket]['Quests'][$indexQuest]['MedalId'] = $row['medalId'];

                        // set lai gia tri moi cho indexCondition
                        $indexCondition = 0;
                        // nap condition
                        $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['Id'] = $row['cId'];
                        $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['Type'] = $row['cType'];
                        $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['Value'] = $row['cValue'];
                        $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['cVirtualQuestId'] = $row['cVirtualQuestId'];
                        $result[$indexPacket]['Quests'][$indexQuest]['Condition'][$indexCondition]['ObjectId'] = $row['cObjectId'];
                    }
                }
            }

            return $result;
        } else
            return array();
    }

    public function getDonationByPageIndex($pageIndex, $pageSize) {
        $sql = 'CALL sp_getDonationBy(?,?)';
        $result = $this->db->query($sql, array($pageIndex, $pageSize));

        return $result->row();
    }

    public function getPacketsBy1($rowIndex, $pageSize) {
        $arrPacket;

        $rowIndex = (int) $rowIndex;
        $pageSize = (int) $pageSize;

        $resultPackets = $this->db->query('SELECT * FROM packet LIMIT ?,?', array($rowIndex, $pageSize));
        $i = 0;
        foreach ($resultPackets->result_array() as $row) {
            $arrPacket[$i] = $row;
            $tmp = $row['Id'];
            $resultQuets = $this->db->query('SELECT * FROM virtualquest WHERE PacketId = ?', array($tmp));
            $y = 0;
            foreach ($resultQuets->result_array() as $rowQuest) {
                $arrPacket[$i]['Quests'][$y] = $rowQuest;
                $tmp = $rowQuest['Id'];
                $resultCondition = $this->db->query('SELECT * FROM questcondition WHERE VirtualQuestId = ?', array($tmp));
                $z = 0;
                foreach ($resultCondition->result_array() as $rowCondition) {
                    $arrPacket[$i]['Quests'][$y]['Condition'][$z] = $rowCondition;
                    $z++;
                }
                $y++;
            }
            $i++;
        }

        return $arrPacket;
    }

    public function insertScore($userId, $score, $conditionId) {
        $sql = 'CALL sp_saveGame(?,?,?)';
        $result = $this->db->query($sql, array($userId, $score, $conditionId));

        return $result->row();
    }

    public function getQuizzBy($id) {
        $sql = 'CALL sp_getQuizzBy(?)';
        $result = $this->db->query($sql, array($id));

        return $result->row();
    }

    public function getUserProfileBy($partnerId) {
        $sql = 'CALL sp_getUserProfileBy(?)';
        $result = $this->db->query($sql, array($partnerId));

        return $result->row();
    }

    public function getDonationByPartnerId($partnerId) {
        $sql = 'CALL sp_getDonationByPartnerId(?)';
        $result = $this->db->query($sql, array($partnerId));

        return $result->row();
    }

    public function getLeaderBoardBy($id) {
        $sql = 'CALL sp_getLeaderBoardBy(?)';
        $result = $this->db->query($sql, array($id));

        return $result->row();
    }

    public function getUserAwardsBy($id) {
        $sql = 'CALL sp_getUserAwardsBy(?)';
        $result = $this->db->query($sql, array($id));

        return $result->row();
    }

    public function getActivitiesByPartnerId($partnerId) {
        $sql = 'CALL sp_getActivitiesByPartnerId(?)';
        $result = $this->db->query($sql, array($partnerId));

        return $result->row();
    }

    public function getUserCurrentQuestBy($id) {
        $sql = 'CALL sp_getUserCurrentQuestBy(?)';
        $result = $this->db->query($sql, array($id));

        return $result->row();
    }

    public function getNumberOfChildrenByUserId() {

        $sql = 'CALL sp_getNumberOfChildrenByUserId()';
        $result = $this->db->query($sql);

        return $result->row();
    }

    public function insertSpentPointDonation($partnerId, $donationId) {
        $sql = 'CALL sp_insertSpentPointDonation(?,?)';
        $result = $this->db->query($sql, array($partnerId, $donationId));

        return $result->row();
    }

    public function insertUserQuest($id) {
        try {
            $sql = 'CALL sp_insertUserQuest(?)';
            $result = $this->db->query($sql, array($id));
            return 'Success';
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    // Login user with facebook.
    public function insertUserFb($fullName, $email, $phone, $facebookId) {

        $result = array();

        $resultPackets = $this->db->query('CALL sp_insertUserFb(?,?,?,?)', array($fullName, $email, $phone, $facebookId));

        $index = -1;
        $indexQuest = -1;
        $indexCondition = -1;

        $userId = -1;
        $vId = -1;
        $cId = -1;

        foreach ($resultPackets->result_array() as $row) {
            if ($userId == $row['uUserId']) {

                if ($vId != $row['vId']) {
                    $vId = $row['vId'];
                    $indexQuest++;

                    $result[0]['quests'][$indexQuest]['id'] = $row['vId'];
                    $result[0]['quests'][$indexQuest]['questName'] = $row['vQuestName'];
                    $result[0]['quests'][$indexQuest]['packetId'] = $row['vPacketId'];
                    $result[0]['quests'][$indexQuest]['partnerId'] = $row['vPartnerId'];
                    $result[0]['quests'][$indexQuest]['animationId'] = $row['vAnimationId'];
                    $result[0]['quests'][$indexQuest]['unlockPoint'] = $row['vUnlockPoint'];
                    $result[0]['quests'][$indexQuest]['createDate'] = $row['vCreateDate'];
                    $result[0]['quests'][$indexQuest]['status'] = $row['qStatus'];

                    $indexCondition = 0;

                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['id'] = $row['cId'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['type'] = $row['cType'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['value'] = $row['cValue'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['virtualQuestId'] = $row['cVirtualQuestId'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['objectId'] = $row['cObjectId'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['is_completed'] = $row['is_completed'];
                } else {
                    $vId = $row['vId'];
                    $indexCondition++;

                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['id'] = $row['cId'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['type'] = $row['cType'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['value'] = $row['cValue'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['virtualQuestId'] = $row['cVirtualQuestId'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['objectId'] = $row['cObjectId'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['is_completed'] = $row['is_completed'];
                }
            } else {
                $userId = $row['uUserId'];

                $result[0]['userId'] = $row['uUserId'];
                $result[0]['facebookId'] = $row['uFacebookId'];
                $result[0]['points'] = $row['uPoints'];
                $result[0]['currentLv'] = $row['uCurrentLevel'];
                
                $result[0]['avatar_id'] = $row['uAvatar'];

                $vId = $row['vId'];
                $indexQuest = 0;

                $result[0]['quests'][$indexQuest]['id'] = $row['vId'];
                $result[0]['quests'][$indexQuest]['questName'] = $row['vQuestName'];
                $result[0]['quests'][$indexQuest]['packetId'] = $row['vPacketId'];
                $result[0]['quests'][$indexQuest]['partnerId'] = $row['vPartnerId'];
                $result[0]['quests'][$indexQuest]['animationId'] = $row['vAnimationId'];
                $result[0]['quests'][$indexQuest]['unlockPoint'] = $row['vUnlockPoint'];
                $result[0]['quests'][$indexQuest]['createDate'] = $row['vCreateDate'];
                $result[0]['quests'][$indexQuest]['status'] = $row['qStatus'];

                $indexCondition = 0;

                $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['id'] = $row['cId'];
                $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['type'] = $row['cType'];
                $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['value'] = $row['cValue'];
                $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['virtualQuestId'] = $row['cVirtualQuestId'];
                $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['objectId'] = $row['cObjectId'];
                $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['is_completed'] = $row['is_completed'];
            }
        }

        return $result;
    }
    
    // Login user with device ID.
    public function insertUser($userName, $deviceId) {

        $result = array();

        $resultPackets = $this->db->query('CALL sp_insert_user(?,?)', array($userName, $deviceId));

        $index = -1;
        $indexQuest = -1;
        $indexCondition = -1;

        $userId = -1;
        $vId = -1;
        $cId = -1;

        foreach ($resultPackets->result_array() as $row) {
            if ($userId == $row['uUserId']) {

                if ($vId != $row['vId']) {
                    $vId = $row['vId'];
                    $indexQuest++;

                    $result[0]['quests'][$indexQuest]['id'] = $row['vId'];
                    $result[0]['quests'][$indexQuest]['questName'] = $row['vQuestName'];
                    $result[0]['quests'][$indexQuest]['packetId'] = $row['vPacketId'];
                    $result[0]['quests'][$indexQuest]['partnerId'] = $row['vPartnerId'];
                    $result[0]['quests'][$indexQuest]['animationId'] = $row['vAnimationId'];
                    $result[0]['quests'][$indexQuest]['unlockPoint'] = $row['vUnlockPoint'];
                    $result[0]['quests'][$indexQuest]['createDate'] = $row['vCreateDate'];
                    $result[0]['quests'][$indexQuest]['status'] = $row['qStatus'];

                    $indexCondition = 0;

                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['id'] = $row['cId'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['type'] = $row['cType'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['value'] = $row['cValue'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['virtualQuestId'] = $row['cVirtualQuestId'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['objectId'] = $row['cObjectId'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['is_completed'] = $row['is_completed'];
                } else {
                    $vId = $row['vId'];
                    $indexCondition++;

                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['id'] = $row['cId'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['type'] = $row['cType'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['value'] = $row['cValue'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['virtualQuestId'] = $row['cVirtualQuestId'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['objectId'] = $row['cObjectId'];
                    $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['is_completed'] = $row['is_completed'];
                }
            } else {
                $userId = $row['uUserId'];

                $result[0]['userId'] = $row['uUserId'];
                $result[0]['facebookId'] = $row['uFacebookId'];
                $result[0]['points'] = $row['uPoints'];
                $result[0]['currentLv'] = $row['uCurrentLevel'];
                $result[0]['device_id'] = $row['device_id'];
                $result[0]['avatar_id'] = $row['uAvatar'];

                $vId = $row['vId'];
                $indexQuest = 0;

                $result[0]['quests'][$indexQuest]['id'] = $row['vId'];
                $result[0]['quests'][$indexQuest]['questName'] = $row['vQuestName'];
                $result[0]['quests'][$indexQuest]['packetId'] = $row['vPacketId'];
                $result[0]['quests'][$indexQuest]['partnerId'] = $row['vPartnerId'];
                $result[0]['quests'][$indexQuest]['animationId'] = $row['vAnimationId'];
                $result[0]['quests'][$indexQuest]['unlockPoint'] = $row['vUnlockPoint'];
                $result[0]['quests'][$indexQuest]['createDate'] = $row['vCreateDate'];
                $result[0]['quests'][$indexQuest]['status'] = $row['qStatus'];

                $indexCondition = 0;

                $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['id'] = $row['cId'];
                $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['type'] = $row['cType'];
                $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['value'] = $row['cValue'];
                $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['virtualQuestId'] = $row['cVirtualQuestId'];
                $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['objectId'] = $row['cObjectId'];
                $result[0]['quests'][$indexQuest]['conditions'][$indexCondition]['is_completed'] = $row['is_completed'];
            }
        }

        return $result;
    }
    
    public function checkUsernameExist($username){
        $this->db->where('FullName',$username);
        $query = $this->db->get('user');
        if ($query->num_rows() > 0){
            return true;
        } else{
            return false;
        }
    }
    
    public function checkDeviceIdExist($id){
        $this->db->where('device_id',$id);
        $query = $this->db->get('userapplication');
        if ($query->num_rows() > 0){
            return true;
        } else{
            return false;
        }
    }
    
    public function checkUserExist($username, $deviceId){
        $this->db->select('*');
        $this->db->from('user');
        $this->db->join('userapplication', 'userapplication.UserId = user.Id');
        $this->db->where('userapplication.device_id', $deviceId);
        $this->db->where('user.FullName', $username);
        $query = $this->db->get();
        
        if ($query->num_rows() > 0){
            return true;
        } else{
            return false;
        }
    }

    /*
     * Services of Hung
     */

    public function getLeaderBoard($pageNumber, $pageSize) {
        mysqli_next_result($this->db->conn_id);
        if ((int) $pageSize === 0){
            $result = $this->db->get('leaderboard');
        } else {
            $result = $this->db->get('leaderboard', $pageSize, $pageNumber*$pageSize);
        }
        
        return $result->result();
    }
    
    public function getLeaderBoardFb($pageNumber, $pageSize, $fbidString) {
        $sql = 'CALL `sp_Get_Leaderboard`(?, ?, ?);';
        $result = $this->db->query($sql, array((int) $pageNumber, (int) $pageSize, $fbidString));
        return $result->result();
    }
    
    public function getUserRank($userId){
        $result = $this->db->get_where('leaderboard', array('id'=> $userId));
        
        
        return $result->row();        
    }

    public function getUserMedal($pageNumber, $pageSize, $userId) {
        $sql = 'CALL `sp_Get_UserMedal`(?,?,?);';
        $result = $this->db->query($sql, array((int) $pageNumber, (int) $pageSize, (int) $userId));

        return $result->result();
    }

    public function getVirtualQuestTable($questId) {
        $sql = "SELECT * FROM virtualquest WHERE virtualquest.Id = $questId";
        $result = $this->db->query($sql);

        return $result->row();
    }

    public function getAnimation($animationId) {
        $sql = 'CALL `sp_Get_Animation`(?)';
        $result = $this->db->query($sql, array((int) $animationId));

        return $result->row();
    }

    public function getQuizChoiceList($pageNumber, $pageSize, $quizCate) {
        // Get list of quiz first.
        $sql = 'CALL `sp_Get_QuizList_ByCategory`(?, ?, ?)';
        $result = $this->db->query($sql, array((int) $pageNumber, (int) $pageSize, (int) $quizCate));
        $quizList = $result->result();

        // TODO : how to get exactly $pageSize quiz? :)
        // Init return array:
        $quizChoiceArray = array();

        // Then with each quiz/question, we extract needed data:
        foreach ($quizList as $quiz) {
            //$quizChoice = array();
            $choice = array();

            // Question information
            $quizChoice = array(
                'id' => $quiz->Id,
                'content' => $quiz->Content,
                'image_url' => $quiz->ImageURL,
                'correct_choice_id' => $quiz->CorrectChoiceId,
                'learn_more_url' => $quiz->LearnMoreURL,
                'point' => $quiz->BonusPoint,
                'sharing_info' => $quiz->SharingInfo
            );
            // Make choices list. 
            // And determine "choice_type": long or short
            $maxChoiceLength = 0;
            mysqli_next_result($this->db->conn_id);
            $sql2 = 'CALL sp_Get_Quiz(?)';
            $result2 = $this->db->query($sql2, array((int) $quiz->Id));
            foreach ($result2->result() as $row) {
                $choice[] = array(
                    'id' => $row->Id,
                    'content' => $row->answer
                );
                if (strlen($row->answer) > $maxChoiceLength) {
                    $maxChoiceLength = strlen($row->answer);
                }
            }

            if ($maxChoiceLength > 17) {
                $quizChoice['choice_type'] = 0;
            } else {
                $quizChoice['choice_type'] = 1;
            }
            $quizChoice['choice'] = $choice;

            // Add to quiz list:
            $quizChoiceArray[] = $quizChoice;
        }
        return $quizChoiceArray;
    }

    public function getQuizChoiceListRandom($pageSize) {
        // Get list of quiz first.
        mysqli_next_result($this->db->conn_id);
        $sql = 'CALL `sp_Get_QuizChoiceList_Random`(?)';
        $result = $this->db->query($sql, (int) $pageSize);
        $quizList = $result->result();

        // TODO : how to get exactly $pageSize quiz? :)
        // Init return array:
        $quizChoiceArray = array();
        $flag = 0;

        // Then with each quiz/question, we extract needed data:
        foreach ($quizList as $quiz) {

            if ($flag === 0) {
                $choice = array();

                // Question information
                $quizChoice = array(
                    'id' => $quiz->Id,
                    'content' => $quiz->Content,
                    'image_url' => $quiz->ImageURL,
                    'correct_choice_id' => $quiz->CorrectChoiceId,
                    'learn_more_url' => $quiz->LearnMoreURL,
                    'point' => $quiz->BonusPoint,
                    'sharing_info' => $quiz->SharingInfo
                );
                // And determine "choice_type": long or short
                $maxChoiceLength = 0;
            }

            // Make choices list. 
            $choice[] = array(
                'id' => $quiz->cId,
                'content' => $quiz->answer
            );
            if (strlen($quiz->answer) > $maxChoiceLength) {
                $maxChoiceLength = strlen($quiz->answer);
            }

            if ($flag === 3) {
                if ($maxChoiceLength > 17) {
                    $quizChoice['choice_type'] = 0;
                } else {
                    $quizChoice['choice_type'] = 1;
                }
                $quizChoice['choice'] = $choice;

                // Add to quiz list:
                $quizChoiceArray[] = $quizChoice;
            }

            // Increase the flag value.
            $flag = ($flag + 1) % 4;
        }
        return $quizChoiceArray;
    }

    public function getQuizChoiceListRandomCate($pageSize, $category) {
        // Get list of quiz first.
        mysqli_next_result($this->db->conn_id);
        $sql = 'CALL `sp_Get_QuizChoiceList_Random_Cate`(?, ?)';
        $result = $this->db->query($sql, array((int) $pageSize, (int) $category));
        $quizList = $result->result();

        // TODO : how to get exactly $pageSize quiz? :)
        // Init return array:
        $quizChoiceArray = array();
        $flag = 0;

        // Then with each quiz/question, we extract needed data:
        foreach ($quizList as $quiz) {

            if ($flag === 0) {
                $choice = array();

                // Question information
                $quizChoice = array(
                    'id' => $quiz->Id,
                    'content' => $quiz->Content,
                    'image_url' => $quiz->ImageURL,
                    'correct_choice_id' => $quiz->CorrectChoiceId,
                    'learn_more_url' => $quiz->LearnMoreURL,
                    'point' => $quiz->BonusPoint,
                    'sharing_info' => $quiz->SharingInfo
                );
                // And determine "choice_type": long or short
                $maxChoiceLength = 0;
            }

            // Make choices list. 
            $choice[] = array(
                'id' => $quiz->cId,
                'content' => $quiz->answer
            );
            if (strlen($quiz->answer) > $maxChoiceLength) {
                $maxChoiceLength = strlen($quiz->answer);
            }

            if ($flag === 3) {
                if ($maxChoiceLength > 17) {
                    $quizChoice['choice_type'] = 0;
                } else {
                    $quizChoice['choice_type'] = 1;
                }
                $quizChoice['choice'] = $choice;

                // Add to quiz list:
                $quizChoiceArray[] = $quizChoice;
            }

            // Increase the flag value.
            $flag = ($flag + 1) % 4;
        }
        return $quizChoiceArray;
    }

    public function getQuizChoiceListRandom2($pageSize) {
        // Get list of quiz first.
        mysqli_next_result($this->db->conn_id);
        $sql = 'CALL `sp_Get_QuizList_Random`(?)';
        $result = $this->db->query($sql, (int) $pageSize);
        $quizList = $result->result();

        // TODO : how to get exactly $pageSize quiz? :)
        // Init return array:
        $quizChoiceArray = array();

        // Then with each quiz/question, we extract needed data:
        foreach ($quizList as $quiz) {
            //$quizChoice = array();
            $choice = array();

            // Question information
            $quizChoice = array(
                'id' => $quiz->Id,
                'content' => $quiz->Content,
                'image_url' => $quiz->ImageURL,
                'correct_choice_id' => $quiz->CorrectChoiceId,
                'learn_more_url' => $quiz->LearnMoreURL,
                'point' => $quiz->BonusPoint,
                'sharing_info' => $quiz->SharingInfo
            );
            // Make choices list. 
            // And determine "choice_type": long or short
            $maxChoiceLength = 0;
            mysqli_next_result($this->db->conn_id);
            $sql2 = 'CALL sp_Get_Quiz(?)';
            $result2 = $this->db->query($sql2, array((int) $quiz->Id));
            foreach ($result2->result() as $row) {
                $choice[] = array(
                    'id' => $row->Id,
                    'content' => $row->answer
                );
                if (strlen($row->answer) > $maxChoiceLength) {
                    $maxChoiceLength = strlen($row->answer);
                }
            }

            if ($maxChoiceLength > 17) {
                $quizChoice['choice_type'] = 0;
            } else {
                $quizChoice['choice_type'] = 1;
            }
            $quizChoice['choice'] = $choice;

            // Add to quiz list:
            $quizChoiceArray[] = $quizChoice;
        }
        return $quizChoiceArray;
    }

    /*
     * Return integer value of Quiz category
     */

    public function getQuizCategoryInQuest($questId) {
        mysqli_next_result($this->db->conn_id);
        $sql = "SELECT questcondition.ObjectId FROM questcondition WHERE VirtualQuestId = $questId AND Type = 0";
        $result = $this->db->query($sql);

        if ($result->row()) {
            return (int) $result->row()->ObjectId;
        } else {
            return 0;
        }
    }
    
    public function resetPlayer($id){
        $sql = 'CALL sp_reset_player(?)';
        $result = $this->db->query($sql, array($id));

        return true;
    }
    
    public function deletePlayer($id){
        $sql = 'CALL sp_delete_player(?)';
        $result = $this->db->query($sql, array($id));

        return true;
    }

    /*
     * End of Hung's services
     */

    /*
     * Pagination purpose.
     */

    public function getNumOrganization() {
        mysqli_next_result($this->db->conn_id);
        $sql = 'CALL sp_GetOrganizationList(0,0)';
        $result = $this->db->query($sql);
        return (int) sizeof($result->result());
    }
    
    public function getNumLeaderBoard() {
        mysqli_next_result($this->db->conn_id);
        return (int) $this->db->count_all('userapplication');
    }
    
    public function getNumMedal($userId){
        mysqli_next_result($this->db->conn_id);
        $this->db->where('UserId', $userId);
        $this->db->from('usermedal');
        return (int) $this->db->count_all_results();
    }
    
    public function updateAvatar($userId, $avatarId, $facebookId){
        if ($facebookId == '0'){
            $sql = 'UPDATE user SET AvatarId = ? WHERE Id = ?';
            $this->db->query($sql, array($avatarId, $userId));
        } else {
            $sql = 'UPDATE userapplication SET FacebookId = ? WHERE UserId = ?';
            $this->db->query($sql, array($facebookId, $userId));
            $sql = 'UPDATE user SET AvatarId = 0 WHERE Id = ?';
            $this->db->query($sql, array($userId));
        }

        return true;
    }
    
    public function getAvatar($avatarId){
        $sql = 'SELECT * FROM player_avatar WHERE id = ?';
        $result = $this->db->query($sql, array($avatarId));

        return $result->row();
    }
    
    public function getAvatars(){
        $sql = 'SELECT * FROM player_avatar';
        $result = $this->db->query($sql);

        return $result->result();
    }

}
