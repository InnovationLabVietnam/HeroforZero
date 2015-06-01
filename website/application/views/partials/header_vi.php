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
                <li><div class="navbar-pad-left nav-header header-image"><a class="navbar-brand" href="<?php echo site_url('organization/index') ?>">
                        <img src="<?php echo $logo_url ?>" alt="Your logo" width="139" height="29">
                    </a>
                    
                    </div></li>
                    <br>
                    <hr class="hr-light-blue">
                
                <!-- Create button -->
                <li class="<?php echo ($current_section == 'quiz') ? 'active' : '' ?> list-background disabled disable" id="list-background-top"><a href="#"><i class="fa fa-question-circle"></i>  Tạo câu hỏi</a></li>
                <li class="<?php echo ($current_section == 'activity') ? 'active' : '' ?> list-background"><a href="<?php echo site_url('organization/create_activity') ?>"><i class="fa fa-calendar"></i>  Tạo hoạt động</a></li>
                <li class="<?php echo ($current_section == 'donation') ? 'active' : '' ?> list-background" id="list-background-bottom"><a href="<?php echo site_url('organization/create_donation') ?>"><i class="fa fa-gift"></i>  Tạo đóng góp</a></li>
                
                <!-- Management button -->
                <li class="<?php echo ($current_section == 'home') ? 'active' : '' ?>"><a id="base-url" href="<?php echo site_url('') ?>"><i class="fa fa-home"></i>  Trang chủ</a></li>
                <li class="<?php echo ($current_section == 'profile') ? 'active' : '' ?> "><a href="<?php echo site_url('organization/profile') ?>"><i class="fa fa-pencil"></i>  Hồ sơ</a></li>
                <li class="<?php echo ($current_section == 'noti') ? 'active' : '' ?>  disable"><a href="<?php echo site_url('organization/under_construction') ?>" TITLE="Function under construction"><i class="fa fa-bell"></i><span class="badge pull-right badge-green"></span>  Thông báo</a></li>
                <li class="<?php echo ($current_section == 'stat') ? 'active' : '' ?> disable"><a href="<?php echo site_url('organization/under_construction') ?>" TITLE="Function under construction"><i class="fa fa-bar-chart-o"></i></span>  Thống kê</a></li>
                
            </ul>
            
            <!-- Buttom button -->
            <ul class="nav navbar-nav side-nav bottom-left-nav">
                <li class="<?php echo ($current_section == 'help') ? 'active' : '' ?>"><a href="<?php echo site_url('organization/help') ?>"><i class="fa fa-question"></i>  Giúp đỡ</a></li>
                <li class="<?php echo ($current_section == 'signout') ? 'active' : '' ?>"><a href="<?php echo site_url('logout') ?>"><i class="fa fa-power-off"></i> Thoát</a></li>
                <li style="padding-left: 50px;">
                    <select id="language" name="language" class="" onchange="var href=this[this.selectedIndex].value; if (href!=''){window.location.href =href};">
                        
                    </select></li>
            </ul>
        </div>
    </div>
</div>
<div id="watermark">
    
</div>

<script>
    var select = document.getElementById('language');
        
    opt = document.createElement("option");
    opt.value = '/home/lang/vi?redirect='+location.href;
    opt.textContent = 'Tiếng Việt';
    select.appendChild(opt);
    opt = document.createElement("option");
    opt.value = '/home/lang/en?redirect='+location.href;
    opt.textContent = 'English';
    select.appendChild(opt);
</script>