<?php

/* Tan - Last 11-March-2014 */

class Quiz_Model extends CI_Model {

    public function __construct() {
        parent::__construct();
    }

    /*     * **GET*** */
    /* Last 11-March-2014 */
    /* 	Get System time */

    public function getTime() {
        $currentDate = date("Y-m-d H:i:s");
        return $currentDate;
    }

    /* 	Get a quiz function from databases */

    public function getQuiz($Id) {
        $sql = 'CALL sp_Get_Quiz(?)';
        $result = $this->db->query($sql, array($Id));

        $array = array();

        $array['quiz'] = array(
            "Id" => $Id,
            "BonusPoint" => $result->row()->{'BonusPoint'},
            "CreatedDate" => $result->row()->{'CreatedDate'},
            "CorrectChoiceId" => $result->row()->{'CorrectChoiceId'},
            "SharingInfo" => $result->row()->{'SharingInfo'},
            "LearnMoreURL" => $result->row()->{'LearnMoreURL'},
            "ImageURL" => $result->row()->{'ImageURL'},
            "IsApproved" => $result->row()->{'IsApproved'},
            "CategoryName" => $result->row()->{'CategoryName'},
            "PartnerName" => $result->row()->{'PartnerName'},
            "CategoryId" => $result->row()->{'CategoryId'},
            "Content" => $result->row()->{'Content'}
        );
        $i = 0;
        foreach ($result->result_array() as $row) {
            $array['choice'][$i] = array(
                "Id" => $row['Id'],
                "answerContent" => $row['answer']
            );
            $i = $i + 1;
        }

        return $array;
    }

    /* 	Get quiz list function from databases */

    public function getQuizList($currentPage, $pageSize) {
        // try {
        $currentPage = (int) $currentPage;
        $pageSize = (int) $pageSize;

        $sql = 'CALL sp_Get_QuizList(?, ?)';
        $query = $this->db->query($sql, array($currentPage, $pageSize));

        return $query->result();
    }
    
    public function getQuizChoiceList($pageNumber, $pageSize) {
        // Get list of quiz first.
        mysqli_next_result($this->db->conn_id);
        $sql = 'CALL `sp_Get_QuizChoiceList`(?, ?)';
        $result = $this->db->query($sql, array((int) $pageNumber, (int) $pageSize));
        $quizList = $result->result();
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
                    'sharing_info' => $quiz->SharingInfo,
                    'CategoryName' =>$quiz->CategoryName,
                    'CreatedDate' => $quiz->CreatedDate,
                    'IsApproved' => $quiz->IsApproved,
                    'PartnerName' => $quiz->PartnerName
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

    /*     * **INSERT*** */
    /* Last 11-March-2014 */
    /* Insert a new quiz function into databases			
      Parameter passed:
        questCategory 	int,
	questQuestion	nvarchar(140),
	correctChoiceId int,
	sharingInfo		nvarchar(8000),
	linkURL	     	nvarchar(200),
	partnerId		int,
	createdDate	  	datetime,
	answerA nvarchar(50),
	answerB nvarchar(50),
	answerC nvarchar(50),
	answerD nvarchar(50) */

    public function insertQuiz($questCategory, $questQuestion, $imageUrl, $CorrectChoiceId,
                                     $sharingInfo, $linkURL, $partnerId, $createDate,
                                        $answerA, $answerB, $answerC, $answerD) {

        try {
            $sql = 'CALL sp_Insert_Quiz_Choice(?, ?, ?, ?, ?, ?, ?, ?, ? ,? , ?, ?)';
            $result = $this->db->query($sql, array($questCategory, $questQuestion, $imageUrl, $CorrectChoiceId,
                                                         $sharingInfo, $linkURL, $partnerId, $createDate,
                                                             $answerA, $answerB, $answerC, $answerD));
        } catch (Exception $e) {

            return $e->getMessage();
        }
        return "Success";
    }

    /* Insert choice function into Choice table
      Input parameters: + Content varchar() */

    public function insertChoice($Content) {
        try {
            $sql = 'CALL sp_Insert_Choice(?)';
            $result = $this->db->query($sql, array($Content));
        } catch (Exception $e) {
            
        }
    }

    /* 	Get Id function of Choice table to filter correct choice */

    public function getChoiceId() {

        //	Get quiz Id from Quiz table		
        $sql = 'SELECT MAX(quiz.Id) FROM quiz';
        $result = $this->db->query($sql, array());

        $QuestionId = $result->row();
        $Id = $QuestionId->{'MAX(quiz.Id)'} + 1;

        //	Get min choice Id from Choice table	
        $sql1 = 'SELECT MIN(choice.Id) FROM choice WHERE choice.QuestionId = ?';
        $result1 = $this->db->query($sql1, array($Id));

        $minId = $result1->row()->{'MIN(choice.Id)'};
        return (int) $minId;
    }

    /*     * **UPDATE*** */
    /* Last 11-March-2014 */

    /* 	Update a quiz function into Quiz table
      Input parameters:
      Id 				int,
      questCategory 	int,
      questQuestion 	nvarchar(140),
      CorrectChoiceId int,
      sharingInfo		nvarchar(8000),
      linkURL	      	nvarchar(200),
      createdDate	  	datetime
     */

    public function updateQuiz($Id, $questCategory, $questQuestion, $imageUrl, $CorrectChoiceId, $sharingInfo, $linkURL, $createDate) {
        try {
            $sql = 'CALL sp_Update_Quiz(?, ?, ?, ?, ?, ?, ?, ?)';
            $result = $this->db->query($sql, array($Id, $questCategory, $questQuestion, $imageUrl, $CorrectChoiceId,
                $sharingInfo, $linkURL, $createDate));
            return "Success";
        } catch (Exception $e) {

            return $e->getMessage();
        }
    }

    /* Get min Id function */

    public function getMinChoiceId($Id) {
        try {
            // Select minChoiceId from Choice Table
            $sql = 'SELECT MIN(choice.Id) FROM choice WHERE choice.QuestionId = ?';
            $result = $this->db->query($sql, array($Id));

            // Get minChoiceId
            $minChoiceId = $result->row()->{'MIN(choice.Id)'};
        } catch (Exception $e) {
            return $e->getMessage();
        }
        return (int) $minChoiceId;
    }

    /* Update choice function from Choice Table */

    public function updateChoice($Id, $Content) {
        try {
            // Call sp_Update_Choice StoreProcedure
            $sql = 'CALL sp_Update_Choice(?, ?)';
            $result = $this->db->query($sql, array($Id, $Content));
            return "Success";
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /* Update BonusPoint function from Quiz Table */

    public function updateBonusPoint($Id, $BonusPoint) {
        try {
            // Call sp_Update_BonusPoint_Quiz StoreProcedure
            $sql = 'Call sp_Update_BonusPoint_Quiz(?, ?)';
            $result = $this->db->query($sql, array($Id, $BonusPoint));
            return "Success";
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /* Update IsApproved function from Quiz Table */

    // Last 17-March-2014
    public function updateIsApproved($Id, $IsApproved) {
        try {
            // Call sp_Update_QuizApprove StoreProcedure
            $sql = 'Call sp_Update_QuizApprove(?, ?)';
            $result = $this->db->query($sql, array($Id, $IsApproved));
            return "Success";
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /*     * **DELETE*** */
    /* Last 12-March-2014 */
    /* Delete quiz and choice function from Quiz Table, Choice Table */

    public function deleteQuiz($Id) {
        try {
            $sql = 'CALL sp_Delete_Quiz(?)';
            $result = $this->db->query($sql, array($Id));

            return 'Success';
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

}

?>