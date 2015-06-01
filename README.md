# HeroforZero
The opensource repository for the UNICEF Vietnam backed HeroforZero app!

Here we will have the information for setting up HEROforZERO for a developer: 

##HEROforZERO project Documentation
###HEROforZERO
HEROforZERO is a project which consists of a game on iOS and a web-based control panel to manage content.
###License

###Installation
Download the latest version: https://github.com/InnovationLabVietnam/HeroforZero.git
The packet include:

1. Website: built based on CodeIgniter framework.
2. iOS project

...
####Install Web
  This is a CodeIgniter PHP framework project, so you can simply install it on any PHP server (Apache or nginx…). You can reference to CodeIgniter here: https://github.com/bcit-ci/CodeIgniter
Please follow this installation instructions: http://www.codeigniter.com/user_guide/installation/index.html 
  This project also use CodeIgniter-Template template library to build view (https://github.com/philsturgeon/codeigniter-template). Please refer to this for better understanding the structure of website.
  **Some things that you need to configure:**
  
  1. We use .htaccess file to control access to the web (on Apache server only):
```
RewriteEngine on
RewriteCond $1 !^(index\.php|images|robots\.txt|assets)
RewriteRule ^(.*)$ /index.php/$1 [L]
```
  The second row is for allowing direct access from url, other request will be process by the CodeIgniter controller.
  
  To run on Local host, for example my site url in local host is: localhost/heroforzero/index.php, I have to change the 3nd row into: *“RewriteRule ^(.*)$ /heroforzero/index.php/$1 [L]”*
  
  The .htaccess do not work on nginx server, so you may have to find the nginx.conf and write 
```
server {
    location / {try_files $uri $uri/ /index.php;}
}
```

  2 . Database sql file stored in /website/sql/heroforzero.sql. You can easily import this file to a MySQL tool and start using. Some notes:
  
    * This SQL create some Stored procedure.
    ```
    CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_allquestofuseraccept` (IN iUserId INT)
    ```
    You may need to change the “DEFINER=your_user@your_host “ to fit with your MySQL database.
    
  3 . All the configuration thing should be in the folder: /application/config. You can change the base url, website name, or database config inside that folder. For example, set you base URL in application/config/config.php file with: “$config['base_url'] = 'http://example.com/'";


####Install iOS project
Check out the source code at the URL: https://github.com/InnovationLabVietnam/HeroforZero.git

Open the project with Xcode, hit debug button

To edit the sprite data we use SpriteBuilder, you can download the software at http://

Config info to connect Webservice server

**Technical Support **

We used platform and tools:

Engine Xcode - it’s free: [https://developer.apple.com/xcode/downloads/]

SpriteBuilder: [http://www.spritebuilder.com/]

Facebook SDK Framework: [https://developers.facebook.com/docs/ios]

CFNetwork Framework

ASIHTTPRequest Library - download and referent this link: [http://allseeing-i.com/ASIHTTPRequest/Setup-instructions]

JSON

Cocos2d-ios Framework: [http://cocos2d.spritebuilder.com/download]

	
Get the Code
 Either clone this repository or fork it on GitHub and clone your fork:
“
git clone https://github.com/InnovationLabVietnam/HeroforZero.git
”
Get data from Server
 Our application used get data from backend server to show informations and we used JSON (JavaScript Object Notation) structure to read and write data.


### Develop it
####Website
1. API Documentation
  *[Wiki link]
  *You should use this document as a reference, the real response of the API may vary and change base on the data.
2. Things to do

There are still way more things need to improve/implement in this project:

All the current API are coded inside normal Controller. Better to convert all the API to RESTful API. Consider using: https://github.com/chriskacerguis/codeigniter-restserver 

Implement the API_KEY function for secure the API.

