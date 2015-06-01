<div id="wrapper">

    <div id="page-wrapper">
        <h1>Tạo hoạt động</h1>
        <p>Điền vào thông tin bên dưới.</p>
        
        <div id="alert_placeholder"></div>

        <form id="activity-form" class="form-horizontal" onSubmit="createActivity(); return false;">
            <fieldset>

                <!-- Form Name -->
                <legend></legend>

                <input type="hidden" name="partner-id" id="partner-id" value="<?php echo $partnerId ?>">
                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="title">Tên hoạt động</label>  
                    <div class="col-md-8">
                        <input id="title" name="title" type="text" placeholder="" class="form-control input-md" required="">

                    </div>
                </div>

                <!-- Textarea -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="description">Mô tả</label>
                    <div class="col-md-8">                     
                        <textarea class="form-control" id="description" name="description" required=""></textarea>
                    </div>
                </div>

                <p>
                    Hãy chọn một hoạt động trong số 4 hoạt động dưới đây mà người chơi phải làm để đạt được điểm thưởng.
                </p>

                <!-- Multiple Checkboxes -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="check_facebook"></label>

                    <div class="col-md-8">
                        <div class="radio">
                            <label>
                                <input type="radio" name="action" id="check_facebook" value="1" checked>
                                Người dùng chia sẻ lên facebook
                            </label>
                        </div>
                    </div>
                </div>


                <!-- Textarea -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="facebook_share"></label>
                    <div class="col-md-8">                     
                        <textarea class="form-control" id="facebook_share" name="facebook_share"></textarea>
                    </div>
                </div>

                <!-- Multiple Checkboxes -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="check_newsletter"></label>
                    <div class="col-md-8">
                        <div class="radio">
                            <label>
                                <input type="radio" name="action" id="check_newsletter" value="2">
                                Đăng ký nhận email tin tức
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="newsletter_link"></label>  
                    <div class="col-md-8">
                        <input id="newsletter_link" name="newsletter_link" type="text" placeholder="Địa chỉ trang web để người dùng đăng ký nhận tin." class="form-control input-md">

                    </div>
                </div>

                <!-- Multiple Checkboxes -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="check_facebook_page"></label>
                    <div class="col-md-8">
                        <div class="radio">
                            <label>
                                <input type="radio" name="action" id="check_facebook_page" value="3">
                                "Thích" Facebook fanpage của bạn
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="facebook_page"></label>  
                    <div class="col-md-8">
                        <input id="facebook_page" name="facebook_page" type="text" placeholder="Địa chỉ trang Facebook của tổ chức." class="form-control input-md">

                    </div>
                </div>

                <!-- Multiple Checkboxes -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="check_calendar"></label>
                    <div class="col-md-8">
                        <div class="radio">
                            <label>
                                <input type="radio" name="action" id="check_calendar" value="4">
                                Thêm hoạt động của bạn vào lịch của người dùng
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="calendar"></label>  
                    <div class="col-md-8 date input-group" id="datetimepicker">
                        <input id="calendar" name="calendar" type="text" placeholder="Chọn thời gian" class="form-control" data-format="YYYY/MM/DD">
                        <span class="input-group-addon"><span data-icon-element="" class="fa fa-calendar">
                            </span>
                        </span>
                    </div>
                </div>

                <!-- Button -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="submit"></label>
                    <div class="col-md-8">
                        <button id="submit" name="submit" class="btn btn-primary">Hoàn tất</button>
                        
                    </div>
                </div>

            </fieldset>
        </form>




    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->