<?php
/*
 * Reference from this: 
 * http://ellislab.com/forums/viewthread/172415/
 */

// save as application/libraries/MY_Session
class App_Session extends CI_Session {
   /*
    * Do not update an existing session on ajax calls
    *
    * @access    public
    * @return    void
    */
    public function sess_update()
    {
        if ( ! IS_AJAX)
        {
            parent::sess_update();
        }
    }

    function sess_destroy()
    {
        parent::sess_destroy();

        $this->userdata = array();
    }
} 