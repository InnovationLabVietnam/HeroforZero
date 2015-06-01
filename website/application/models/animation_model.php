<?php

/* 
 * Code written by Nguyen Van Hung at @imrhung
 * Feel free to re-use or share it.
 * Happy code!!!
 */

class Animation_Model extends CI_Model {

    public static $ActivityId = array();

    public function __construct() {
        parent:: __construct();
    }
    
    public function getAnimationList($pageSize, $pageNumber){
        
        if ($pageSize == 0){
            $result = $this->db->get('animation');
        } else {
            $result = $this->db->get('animation', $pageSize, $pageNumber*$pageSize);
        }
        
        return $result->result();
    }
    
    public function getAnimation($id){
        $result = $this->db->get_where('animation', array('Id' => $id));
        return $result->row();
    }
    
    public function getNumAnimation(){
        return $this->db->count_all('animation');
    }
    
    public function insertAnimation($time, $walking, $standby, $monster, $kid, $red, $green, $blue, $screenshot){
        $data = array(
            'time' => $time,
            'HeroAnimWalking' => $walking,
            'HeroAnimStandby' => $standby,
            'MonsterAnim' => $monster,
            'KidFrame' => $kid,
            'ColorR' => $red,
            'ColorG' => $green,
            'ColorB' => $blue,
            'ScreenShotURL' => $screenshot
        );
        
        $this->db->insert('animation', $data);
        
        return $this->db->insert_id();
    }
    
    public function updateAnimation($id, $time, $walking, $standby, $monster, $kid, $red, $green, $blue, $screenshot){
        $data = array(
            'time' => $time,
            'HeroAnimWalking' => $walking,
            'HeroAnimStandby' => $standby,
            'MonsterAnim' => $monster,
            'KidFrame' => $kid,
            'ColorR' => $red,
            'ColorG' => $green,
            'ColorB' => $blue
        );
        if (strlen($screenshot) !== 0){
            $data['ScreenShotURL'] = $screenshot;
        }
        $this->db->where('id', $id);
        $this->db->update('animation', $data);
        
        return TRUE;
    }
    
    public function delete($id){
        $this->db->delete('animation', array('Id' => $id));
        return TRUE;
    }
}