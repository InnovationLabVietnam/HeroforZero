<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 *
 * APP CONFIGUTATION
 *
 **/

// Default App Title
$config['app_title'] = 'Hero for Zero';

// Default "From" for Email library
$config['email_from_name'] = 'Hero for Zero - Do not reply';
$config['email_from_email'] = 'do_not_reply@heroforzero.org';

// Default blocked domains for Email Validation
$config['blocked_domains'] = array(
    'blocked.domain', // always required
    'zoemail.com',
    'emailias.com',
    'spamex.com',
    'spamgourmet.com',
    '2prong.com',
    'e4ward.com',
    'gishpuppy.com',
    'mailinator.com'
);