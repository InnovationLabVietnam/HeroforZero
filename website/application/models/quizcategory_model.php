<?php

/* Tan - Last 18-March-2014 */

class QuizCategory_Model extends CI_Model {

    public function __construct() {
        parent:: __construct();
    }

    /*     * ***SELECT**** */
    /* Last 18-March-2014 */
    /* 	Get QuizCategory list function from databases */

    public function getQuizCategoryList($currentPage, $pageSize) {

        $currentPage = (int) $currentPage;
        $pageSize = (int) $pageSize;

        $sql = 'CALL sp_Get_QuizCategoryList(?, ?)';
        $result = $this->db->query($sql, array($currentPage, $pageSize));

        return $result->result();
    }
    
    public function getQuizCategoryCountList(){
        $result = array();
        $query = $this->db->get('quizcategory');
        foreach ($query->result() as $row){
            $row->quiz_count = $this->countQuizCategory($row->Id);
            $result[] = $row;
        }
        return $result;
    }

    /*     * ***INSERT**** */
    /* Last 18-March-2014 */
    /* 	Packet insert function */

    public function insertQuizCategory($category) {

        try {
            $sql = 'CALL sp_Insert_QuizCategory(?)';
            $result = $this->db->query($sql, array($category));
            return 'Success';
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }
    
    public function updateQuizCategory($id, $category){
        $data = array(
            'CategoryName' => $category
        );
        
        $query = $this->db->get_where('quizcategory', array('Id'=>$id));
        
        if ($query->row_array()){
            $this->db->where('Id', $id);
            return $this->db->update('quizcategory', $data);
        } else {
            return $this->createQuizCategory($id, $category);
        }
    }
    
    public function createQuizCategory($id, $category){
        $data = array(
            'Id' => $id,
            'CategoryName' => $category
        );
        return $this->db->insert('quizcategory', $data);      
    }
    
    /*
     * Delete and update the category of the quizs to 0
     */
    public function deleteCategory($id){
        try {
            // Change quiz category to 0 first
            $data = array(
               'CategoryId' => 0
            );
            $this->db->where('CategoryId', $id);
            $this->db->update('quiz', $data);
            // Now delete
            $result = $this->db->delete('quizcategory', array('Id'=>$id));
            if ($this->db->affected_rows() == 0){
                return FALSE;
            }
            return $result;
        } catch (Exception $e){
            echo "error";
        }
    }
    
    private function countQuizCategory($id){
        $this->db->where("CategoryId", $id);
        if ((int) $id == 0){
            $this->db->or_where('CategoryId IS NULL');
            $this->db->or_where('TRIM(CategoryId) = ""');
        }
        $this->db->from('quiz');
        return (int) $this->db->count_all_results();
    }
}

?>	