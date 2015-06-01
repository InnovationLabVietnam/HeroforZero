<div id="wrapper">

    <div id="page-wrapper">


        <h1>Change password</h1>

        <div id="infoMessage"><p><?php echo $message; ?></p></div>

        <form action="" method="post" accept-charset="utf-8" class="form-horizontal">

            <div class="form-group">
                <label class="col-md-4 control-label" for="old">Old password</label>
                <div class="col-md-4">
                    <?php echo form_input($old_password); ?>
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-4 control-label" for="new_password">New password</label>
                <div class="col-md-4">
                    <?php echo form_input($new_password); ?>
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-4 control-label" for="new_confirm">Confirm password</label>
                <div class="col-md-4">
                    <?php echo form_input($new_password_confirm); ?>
                </div>
            </div>

            <?php echo form_input($user_id); ?>
            <!-- Button -->
            <div class="form-group">
                <label class="col-md-4 control-label" for="submit"></label>
                <div class="col-md-4">
                    <button id="submit" name="submit" class="btn btn-block btn-primary">Submit</button>

                </div>

            </div>


        </form>


    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->