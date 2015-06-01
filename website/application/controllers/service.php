<?php

// Author: Hau
// Start date: 10-April-2014

defined('BASEPATH') OR exit('No direct script access allowed');

class Service extends App_Controller {

    function __construct() {
        parent::__construct();
        $this->load->model('service_model');
    }

    /* Update quest status */

    public function updateQuestStatus() {
        // Input data
        $userId = $this->input->post('userId');
        $questId = $this->input->post('questId');
        $questStatus = $this->input->post('questStatus');


        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        $resultCheck = $this->service_model->updateQuestStatus($userId, $questId, $questStatus);

        if ($resultCheck == 'Success') {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }

        echo json_encode($result);
    }

    /* Insert award for user */

    public function insertMedal() {
        // Input data
        $userId = $this->input->post('userId');
        $medalId = $this->input->post('medalId');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        $resultCheck = $this->service_model->insertMedal($userId, $medalId);

        if ($resultCheck == 'Success') {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else if ($resultCheck == 'Existed'){
            $result['code'] = 2;
            $result['message'] = "Existed";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }

    /* Get Organization list function from database */

    public function getOrganizationList() {
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['organization'] = "";

        $currentPage = $_POST['currentPage'];
        $pageSize = $_POST['pageSize'];

        $resultCheck = $this->service_model->getOrganizationList($currentPage, $pageSize);

        // Get the number of pages of this list.
        $numOfOrganization = $this->service_model->getNumOrganization();

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['organization'] = $resultCheck;
            $result['info']['quantity'] = $numOfOrganization;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['organization'] = $resultCheck;
        }
        echo json_encode($result);
    }

    public function getTest() {
        $id = $this->input->post("id");

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['activity'] = null;

        $resultCheck = $this->service_model->getTestById($id);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['activity'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['activity'] = $resultCheck;
        }

        echo json_encode($result);
    }

    public function getPackets() {
        $pageSize = $this->input->post('pageSize');
        $rowIndex = $this->input->post('pageIndex');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['packet'] = null;

        $resultCheck = $this->service_model->getPacketsBy($rowIndex, $pageSize);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['packet'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['packet'] = $resultCheck;
        }

        echo json_encode($result);
    }

    public function getDonation() {
        $partnerId = $this->input->post('partnerId');

        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['quizz'] = null;

        $resultCheck = $this->service_model->getDonationByPartnerId($partnerId);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['quizz'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['quizz'] = $resultCheck;
        }

        echo json_encode($result);
    }

    /*
      public function getQuizz() {
      // Initialization Array
      $result = array();
      $result['code'] = -1;
      $result['message'] = "";
      $result['info'] = array();

      $result['info']['quizz'] = null;

      $resultCheck= $this->service_model->getQuizzBy($id);

      if ($resultCheck) {
      $result['code'] = 1;
      $result['message'] = "Success";
      $result['info']['quizz'] = $resultCheck;
      } else {
      $result['code'] = 0;
      $result['message'] = "Fail";
      $result['info']['quizz'] = $resultCheck;
      }

      echo json_encode($result);
      }
     * 
     */

    public function getUserProfile() {
        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['profile'] = null;

        $resultCheck = $this->service_model->getUserProfileBy($id);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['profile'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['profile'] = $resultCheck;
        }

        echo json_encode($result);
    }

    /*
      public function getLeaderBoard() {
      // Initialization Array
      $result = array();
      $result['code'] = -1;
      $result['message'] = "";
      $result['info'] = array();

      $result['info']['leaderBoard'] = null;

      $resultCheck= $this->service_model->getLeaderBoardBy($id);

      if ($resultCheck) {
      $result['code'] = 1;
      $result['message'] = "Success";
      $result['info']['leaderBoard'] = $resultCheck;
      } else {
      $result['code'] = 0;
      $result['message'] = "Fail";
      $result['info']['leaderBoard'] = $resultCheck;
      }

      echo json_encode($result);
      }
     * 
     */

    public function getUserAwards() {
        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['userAwards'] = null;

        $resultCheck = $this->service_model->getUserAwardsBy($id);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['userAwards'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['userAwards'] = $resultCheck;
        }

        echo json_encode($result);
    }

    public function getActivities() {
        $partnerId = $this->input->post('partnerId');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['activity'] = null;

        $resultCheck = $this->service_model->getActivitiesByPartnerId($partnerId);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['activity'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['activity'] = $resultCheck;
        }

        echo json_encode($result);
    }

    public function getUserCurrentQuest() {
        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['currentQuest'] = null;

        $resultCheck = $this->service_model->getUserCurrentQuestBy($id);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info']['currentQuest'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info']['currentQuest'] = $resultCheck;
        }

        echo json_encode($result);
    }

    public function getNumberOfChildren() {
        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $result['info']['numberChildren'] = null;

        $resultCheck = $this->service_model->getNumberOfChildrenByUserId();

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info'] = $resultCheck;
        }

        echo json_encode($result);
    }

    public function saveUserQuest() {
        // Input data
        $id = $this->input->post('id');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        $resultCheck = $this->service_model->insertUserQuest($id);

        if ($resultCheck == 'Success') {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }

        echo json_encode($result);
    }

    public function registerUserFb() {
        $fullName = $this->input->post('fullName');
        $email = $this->input->post('email');
        $phone = $this->input->post('phone');
        $facebookId = $this->input->post('facebookId');

        $resultCheck = $this->service_model->insertUserFb($fullName, $email, $phone, $facebookId);

        $result['code'] = 1;
        $result['message'] = "Success";
        $result['info'] = $resultCheck;

        echo json_encode($result);
    }

    public function registerUser() {
        $fullName = $this->input->post('user_name');
        $deviceId = $this->input->post('device_id');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        $existUsername = $this->service_model->checkUsernameExist($fullName);

        if ($existUsername) {
            // Username existed, return failure
            $result['code'] = 2;
            $result['message'] = "User Name Existed";
        } else {
            $resultCheck = $this->service_model->insertUser($fullName, $deviceId);
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info'] = $resultCheck;
        }
        echo json_encode($result);
    }

    public function loginUser() {
        $fullName = $this->input->post('user_name');
        $deviceId = $this->input->post('device_id');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        $existUser = $this->service_model->checkUserExist($fullName, $deviceId);

        if ($existUser) {
            // User existed, just login
            $resultCheck = $this->service_model->insertUser($fullName, $deviceId);

            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info'] = $resultCheck;
        } else {
            $result['code'] = 3;
            $result['message'] = "User has not logged in";
        }

        echo json_encode($result);
    }

    public function spentPointDonation() {
        $partnerId = $this->input->post('partnerId');
        $donationId = $this->input->post('donationId');

        $resultCheck = $this->service_model->insertSpentPointDonation($partnerId, $donationId);
        $result['code'] = 1;
        $result['message'] = "Success";
        $result['info'] = $resultCheck;

        echo json_encode($result);
    }

    public function spentPointActivity() {
        
    }

    public function saveGame() {
        $userId = $this->input->post('userId');
        $score = $this->input->post('score');
        $conditionId = $this->input->post('conditionId');

        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $resultCheck = $this->service_model->insertScore($userId, $score, $conditionId);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info'] = $resultCheck;
        }
        echo json_encode($result);
    }

    public function getDonationPagination() {
        $pageIndex = $this->input->post('pageIndex');
        $pageSize = $this->input->post('pageSize');

        $result = array();
        $result['code'] = -1;
        $result['message'] = "";
        $result['info'] = array();

        $resultCheck = $this->service_model->getDonationByPageIndex($pageIndex, $pageSize);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
            $result['info'] = $resultCheck;
        }

        echo json_encode($result);
    }

    /*
     * Hung's Services:
     */

    // Get quiz list by category and radom result for the app.
    public function getQuizz() {
        // Get request params:
        $pageNumber = $this->input->post('page_number');
        $pageSize = $this->input->post('page_size');
        $questId = $this->input->post('quest_id');
        $random = $this->input->post('random');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // Get Animation first:
        $virtualQuest = $this->service_model->getVirtualQuestTable($questId);

        // Check if virtualQuest exist:
        if (count($virtualQuest) === 0) {
            $result['code'] = 0;
            $result['message'] = "Quest not found!";
        } else {

            $animationId = $virtualQuest->AnimationId;

            // If animation not defined:
            if (is_null($animationId)) {
                $animationId = 1;
            }

            $animationRaw = $this->service_model->getAnimation($animationId);
            // Create elements like json defined.
            // Check if animation exist:
            if (count($animationRaw) === 0) {
                $result['code'] = 0;
                $result['message'] = "Animation not found";
            } else {
                $animation = array(
                    'id' => $animationRaw->Id,
                    'time' => $animationRaw->time,
                    'hero_anim_walking' => $animationRaw->HeroAnimWalking,
                    'hero_anim_standby' => $animationRaw->HeroAnimStandby,
                    'monster_anim' => $animationRaw->MonsterAnim,
                    'kid_frame' => $animationRaw->KidFrame,
                    'color_R' => $animationRaw->ColorR,
                    'color_G' => $animationRaw->ColorG,
                    'color_B' => $animationRaw->ColorB
                );

                // Then get the quiz list:

                if ($random) {
                    $quizList = $this->service_model->getQuizChoiceListRandom($pageSize);
                } else {
                    // Get the quiz category from quest first.
                    $category = $this->service_model->getQuizCategoryInQuest($questId);
                    $quizList = $this->service_model->getQuizChoiceListRandomCate($pageSize, $category);
                }

                if ($quizList) {
                    $result['code'] = 1;
                    $result['message'] = "Success";
                    $result['animation'] = $animation;
                    $result['quizzes'] = $quizList;
                } else {
                    $result['code'] = 0;
                    $result['message'] = "No result";
                }
            }
        }
        echo json_encode($result);
    }

    // Get quiz list by radom result, without category, for the app.
    public function getQuizzRandom() {
        // Get request params:
        $pageNumber = $this->input->post('page_number');
        $pageSize = $this->input->post('page_size');
        $questId = $this->input->post('quest_id');
        $random = $this->input->post('random');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // Get Animation first:
        $virtualQuest = $this->service_model->getVirtualQuestTable($questId);

        // Check if virtualQuest exist:
        if (count($virtualQuest) === 0) {
            $result['code'] = 0;
            $result['message'] = "Quest not found!";
        } else {

            $animationId = $virtualQuest->AnimationId;

            // If animation not defined:
            if (is_null($animationId)) {
                $animationId = 1;
            }

            $animationRaw = $this->service_model->getAnimation($animationId);
            // Create elements like json defined.
            // Check if animation exist:
            if (count($animationRaw) === 0) {
                $result['code'] = 0;
                $result['message'] = "Animation not found";
            } else {
                $animation = array(
                    'id' => $animationRaw->Id,
                    'time' => $animationRaw->time,
                    'hero_anim_walking' => $animationRaw->HeroAnimWalking,
                    'hero_anim_standby' => $animationRaw->HeroAnimStandby,
                    'monster_anim' => $animationRaw->MonsterAnim,
                    'kid_frame' => $animationRaw->KidFrame,
                    'color_R' => $animationRaw->ColorR,
                    'color_G' => $animationRaw->ColorG,
                    'color_B' => $animationRaw->ColorB
                );

                // Then get the quiz list:
                // Get the quiz category from quest first.
                $category = $this->service_model->getQuizCategoryInQuest($questId);
                $quizList = $this->service_model->getQuizChoiceListRandomCate($pageSize, $category);

                if ($quizList) {
                    $result['code'] = 1;
                    $result['message'] = "Success";
                    $result['animation'] = $animation;
                    $result['quizzes'] = $quizList;
                } else {
                    $result['code'] = 0;
                    $result['message'] = "No result";
                }
            }
        }
        echo json_encode($result);
    }

    // Get leader board of all user.
    public function getLeaderBoard() {

        // Get request params:
        $pageNumber = $this->input->post('page_number');
        $pageSize = $this->input->post('page_size');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // Get data
        $resultCheck = $this->service_model->getLeaderBoard($pageNumber, $pageSize);

        // Get number of user in leader board
        $quantity = $this->service_model->getNumLeaderBoard();

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['leaderboard'] = $resultCheck;
            $result['quantity'] = $quantity;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }
    
    // Get the leader board with facebook account and fb friends.
    public function getLeaderBoardFb() {

        // Get request params:
        $pageNumber = $this->input->post('page_number');
        $pageSize = $this->input->post('page_size');
        $jsonFriends = json_decode($this->input->post('friends_fbid'), TRUE);

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // Generate the facebook id list:
        if (count($jsonFriends['friends_fbid']) > 0) {
            $fbidString = '"0"';
            for ($i = 0; $i < count($jsonFriends['friends_fbid']); $i++) {
                $fbidString .= ',"' . $jsonFriends['friends_fbid'][$i] . '"';
            }
        } else {
            $fbidString = null;
        }

        // Get data
        $resultCheck = $this->service_model->getLeaderBoardFb($pageNumber, $pageSize, $fbidString);


        // NOT IN USE. Because number returned from database is in String, so we need to convert it to integer:
        $leaderboard = array();
        foreach ($resultCheck as $row) {
            $leaderboard[] = array(
                'id' => (int) $row->id,
                'name' => $row->name,
                'mark' => (int) $row->mark,
                'facebook_id' => $row->facebook_id,
                'current_level' => (int) $row->current_level
            );
        }

        // Get number of user in leader board
        $quantity = $this->service_model->getNumLeaderBoard();

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['leaderboard'] = $resultCheck;
            $result['quantity'] = $quantity;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }

    public function getUserRank() {
        $userId = $this->input->post('user_id');
        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        $rank = $this->service_model->getUserRank($userId);

        if ($rank) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['user'] = $rank;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }

    public function getUserMedal() {

        // Get request params:
        $pageNumber = $this->input->post('page_number');
        $pageSize = $this->input->post('page_size');
        $userId = $this->input->post('user_id');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // Get data
        $resultCheck = $this->service_model->getUserMedal($pageNumber, $pageSize, $userId);

        // Get the number of medal
        $quantity = $this->service_model->getNumMedal($userId);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['user_medal'] = $resultCheck;
            $result['quantity'] = $quantity;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }
        echo json_encode($result);
    }

    public function resetPlayer() {
        // Get request params
        $userId = $this->input->post('id');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // Reset
        $resultCheck = $this->service_model->resetPlayer($userId);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }

        echo json_encode($result);
    }
    
    public function deletePlayer() {
        // Get request params
        $userId = $this->input->post('id');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        // Reset
        $resultCheck = $this->service_model->deletePlayer($userId);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }

        echo json_encode($result);
    }

    public function updateAvatar() {
        // Get request params
        $userId = $this->input->post('user_id');
        $avatarId = $this->input->post('avatar_id');

        // To update image from facebook. Input 0 if make no change on them.
        $facebookId = $this->input->post('facebook_id');

        // Initialization Array
        $result = array();

        // Reset
        $resultCheck = $this->service_model->updateAvatar($userId, $avatarId, $facebookId);

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }

        echo json_encode($result);
    }

    public function getAvatar() {
        // Get request params
        $avatarId = $this->input->post('avatar_id');

        // Initialization Array
        $result = array();
        $result['code'] = -1;
        $result['message'] = "";

        if ($avatarId !== FALSE) {
            $resultCheck = $this->service_model->getAvatar($avatarId);
        } else {
            $resultCheck = $this->service_model->getAvatars($avatarId);
        }

        if ($resultCheck) {
            $result['code'] = 1;
            $result['message'] = "Success";
            $result['info'] = $resultCheck;
        } else {
            $result['code'] = 0;
            $result['message'] = "Fail";
        }

        echo json_encode($result);
    }

    /*
     * End of Hung's code
     */
}
