<div class="navbar-nav" role="navigation">
    <div class="container">
        <button type="button" class="navbar-toggle btn-primary" id="navbar-btn" data-toggle="collapse" data-target="#hero-side-nav">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>Menu
      </button>
        <div class="collapse navbar-collapse" id="hero-side-nav">
            <ul class="nav navbar-nav side-nav">
                <li><div class="navbar-pad-left nav-header header-image"><a class="navbar-brand" href="<?php echo site_url('admin/index') ?>">
                        <img src="<?php echo "http://pcura.com/_content/admin_login.gif" ?>" alt="Your logo" width="139" height="29">
                    </a></div></li>
                    <br>
                    <hr class="hr-light-blue">
                <div class="navbar-pad-left <?php echo ($current_section == 'quest') ? 'active' : '' ?>">
                    <a href="<?php echo site_url('admin/create_quest') ?>"><img id="create-quest-btn"src="<?php echo base_url() ?>assets/img/create_quest_btn.png" alt="Create Quest"></a>
                </div>       
                <li class="<?php echo ($current_section == 'home') ? 'active' : '' ?>"><a id="base-url" href="<?php echo site_url() ?>"><i class="fa fa-home"></i>  Home</a></li>
                <li class="<?php echo ($current_section == 'packet') ? 'active' : '' ?>"><a href="<?php echo site_url('admin/packet'); ?>"><i class="fa fa-folder"></i>  Packet</a></li>
                <li class="<?php echo ($current_section == 'partners') ? 'active' : '' ?>"><a href="<?php echo site_url('admin/partners'); ?>"><i class="fa fa-group"></i>  Partners</a></li>
                
                <li class="<?php echo ($current_section == 'players') ? 'active' : '' ?> "><a href="<?php echo site_url('admin/players') ?>"><i class="fa fa-puzzle-piece"></i>  Players</a></li>
                <li class="<?php echo ($current_section == 'notification') ? 'active' : '' ?> disable"><a href="<?php echo site_url('admin/under_construction') ?>" TITLE="Function under construction"><i class="fa fa-bell"></i><span class="badge pull-right badge-green"></span>  Notifications</a></li>
                <li class="<?php echo ($current_section == 'stat') ? 'active' : '' ?> disable"><a href="<?php echo site_url('admin/under_construction') ?>" TITLE="Function under construction"><i class="fa fa-bar-chart-o"></i></span>  Statistics</a></li>
                
            </ul>
            <ul class="nav navbar-nav side-nav bottom-left-nav">
                
               
                <li class="<?php echo ($current_section == 'change_pass') ? 'active' : '' ?>"><a href="<?php echo site_url('admin/change_password') ?>"><i class="fa fa-edit"></i>Change Password</a></li>
                <li class="<?php echo ($current_section == 'signout') ? 'active' : '' ?>"><a href="<?php echo site_url('logout') ?>"><i class="fa fa-power-off"></i>  Sign me out</a></li>
            </ul>
        </div>
    </div>
</div>
<div id="watermark">
    
</div>
