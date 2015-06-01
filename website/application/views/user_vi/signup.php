<!DOCTYPE html>
<html lang='en'>
    <head>
        <meta name="viewport" content='width=device-width, initial-scale=1'>
        <meta charset="utf-8">
        <title>Đăng ký</title>

        <link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/css/bootstrap.min.css" media="screen" />
        <link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/css/login.css" media="screen" />
        <link rel="shortcut icon" href="<?php echo base_url(); ?>assets/img/favicon.ico" type="image/x-ico">
        
        <script type="text/javascript" src="<?php echo base_url(); ?>assets/js/jquery-1.9.1.min.js"></script>
        
        <script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-49504439-1', 'heroforzero.be');
  ga('send', 'pageview');

</script>
        
    </head>
    <body>
        <div class="container">
        <div class='content-center'>

            <form class="form-horizontal" method='POST' enctype="multipart/form-data">
                <fieldset>

                    <img src='<?php echo base_url(); ?>assets/img/sign_up_logo.png' class='img-responsive img-center' alt='Hero For Zero'>
                    <p class='col-md-12 img-center'>
                        Hoàn thành các thông tin của tổ chức bạn để tham gia đóng góp vào chương trình "Hero for Zero".
                        <br>
                        Nếu bạn đã đăng ký, <a href='<?php echo base_url(); ?>login'> Đăng nhập tại đây </a>
                        <br>
                        Chọn ngôn ngữ: 
                        <select id="language" name="language" class=""
                                onchange="var href=this[this.selectedIndex].value; if (href!=''){window.location.href =href};"
                                style="background-color: black; color: white;">
                            
                        </select>
                        
                    </p>
                    <br><br><br><br>
                    <div class='row img-center'>
                        <div class="col-md-8 col-md-offset-2">
                            <?php echo validation_errors('<div class="alert alert-danger">', '</div>'); ?>
                        </div>
                    </div>
                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="username">Tên đăng nhập</label>  
                        <div class="col-md-4">
                            <input id="username" name="username" type="text" value="<?php echo set_value('username'); ?>" placeholder="Tối thiểu 6 ký tự" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Password input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="password">Mật khẩu</label>
                        <div class="col-md-4">
                            <input id="password" name="password" type="password" value="<?php echo set_value('password'); ?>" placeholder="Hãy ghi nhớ mật khẩu của bạn" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Password confirm input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="passconf">Xác nhận mật khẩu</label>
                        <div class="col-md-4">
                            <input id="passconf" name="passconf" type="password" value="<?php echo set_value('passconf'); ?>" placeholder="Nhập lại mật khẩu vừa rồi." class="form-control input-md" required="">

                        </div>
                    </div>


                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="name">Tên tổ chức</label>  
                        <div class="col-md-4">
                            <input id="name" name="name" type="text" value="<?php echo set_value('name'); ?>" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>
                    
                    <!-- File Button --> 
<div class="form-group">
  <label class="col-md-4 control-label" for="logo_image">Logo của tổ chức</label>
  <div class="col-md-4">
      <input id="logo_image" name="logo_image" class="input-file form-control" type="file">Kích thước 139x29px
  </div>
</div>

<!-- File Button --> 
<div class="form-group">
  <label class="col-md-4 control-label" for="icon_image">Biểu tượng</label>
  <div class="col-md-4">
      <input id="icon_image" name="icon_image" class="input-file form-control" type="file">Kích thước 78x78px
  </div>
</div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="admin_name">Người điều hành</label>  
                        <div class="col-md-4">
                            <input id="admin_name" name="admin_name" type="text" value="<?php echo set_value('admin_name'); ?>" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="email">Địa chỉ Email</label>  
                        <div class="col-md-4">
                            <input id="email" name="email" type="email" value="<?php echo set_value('email'); ?>" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="address">Địa chỉ liên lạc</label>  
                        <div class="col-md-4">
                            <input id="address" name="address" type="text" value="<?php echo set_value('address'); ?>" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="phone">Số điện thoại</label>  
                        <div class="col-md-4">
                            <input id="phone" name="phone" type="tel" value="<?php echo set_value('phone'); ?>" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="website">Website (nếu có)</label>  
                        <div class="col-md-4">
                            <input id="website" name="website" type="text" value="<?php echo set_value('website'); ?>" placeholder="" class="form-control input-md">

                        </div>
                    </div>

                    <!-- TODO : Load dynamically this type -->
                    <!-- Select Basic -->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="type">Loại hình tổ chức</label>
                        <div class="col-md-4">
                            <select id="type" name="type" class="form-control">
                                <option value="1" <?php echo set_select('type', '1', TRUE); ?> >Tổ chức phi lợi nhuận trong nước</option>
                                <option value="2" <?php echo set_select('type', '2'); ?> >Tổ chức phi lợi nhuận quốc tế</option>
                                <option value="3" <?php echo set_select('type', '3'); ?> >Trung tâm chăm sóc trẻ em</option>
                                <option value="4" <?php echo set_select('type', '4'); ?> >Tổ chức cộng đồng</option>
                                <option value="5" <?php echo set_select('type', '4'); ?> >Tổ chức tôn giáo</option>
                            </select>
                        </div>
                    </div>

                    
                    <!-- Textarea -->
<div class="form-group">
  <label class="col-md-4 control-label" for="description">Sứ mệnh</label>
  <div class="col-md-4">                     
    <textarea class="form-control" id="description" name="description" required=""><?php echo set_value('description'); ?></textarea>
  </div>
</div>

                    <!-- Button -->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="submit"></label>
                        <div class="col-md-4">
                            <button id="submit" name="submit" class="btn btn-block btn-primary">Đăng ký</button>
                            <div id="ack"></div>
                        </div>
                    </div>

                </fieldset>
            </form>


        </div>
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

    </body>
</html>

