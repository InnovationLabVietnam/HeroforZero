<div id="wrapper">

    <div id="page-wrapper">

        <h1>Tạo Đóng góp</h1>
        <p>Người dùng sẽ phải đóng góp một phần số điểm họ có cho hoạt động này.</p>

        <div id="alert_placeholder"></div>
        <form id="donation-form" class="form-horizontal" onSubmit="createDonation(); return false;">
            <fieldset>
                
                <!-- Form Name -->
                <legend></legend>

                <input type="hidden" name="partner-id" id="partner-id" value="<?php echo $partnerId ?>">
                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="title">Tên Đóng góp</label>  
                    <div class="col-md-8">
                        <input id="title" name="title" type="text" placeholder="" class="form-control input-md" required="">

                    </div>
                </div>

                 <!-- Textarea -->
<div class="form-group">
  <label class="col-md-4 control-label" for="description">Mô tả</label>
  <div class="col-md-8">                     
    <textarea class="form-control" id="description" name="description"></textarea>
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