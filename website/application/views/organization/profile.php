<div id="wrapper">


    <div id="page-wrapper">

        <h1><b>Edit Profile in Hero for Zero.</b></h1>
        <p></p>

        <!--Main form on organization information.-->
        <div> 
            <form class="form-horizontal" onSubmit=" return false;">
                <fieldset>

                    <h3>
                        You can edit you organization's information below.
                    </h3>
                    <div id="alert_placeholder"></div>
                    <hr>
                    
                    <input type="hidden" name="partner-id" id="partner-id" value="<?php echo $partnerId ?>">

                    <div class="form-group">
                        <label class="col-md-4 control-label" for="username">Username</label>  
                        <div class="col-md-4">
                            <p id='username'></p>

                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-4 control-label" for="password">Password</label>
                        <div class="col-md-4">
                            <?php if (!$admin) : ?>
                            <a href="<?php echo site_url('organization/change_password') ?>">Change Password</a>
                            <?php endif ?>
                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="name">Organization's Name</label>  
                        <div class="col-md-4">
                            <input id="name" name="name" type="text" value="" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- File Button --> 
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="logo_image">Organization's Logo</label>
                        <div class="col-md-4">
                            <img id="logo_image_set" src="" class="img-responsive" alt="">
                            <input id="logo_image" name="userfile[]" class="input-file form-control" type="file">Keep size to 139x29px
                        </div>
                    </div>

                    <!-- File Button --> 
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="icon_image">Organization's Icon</label>
                        <div class="col-md-4">
                            <img id="icon_image_set" src="" class="img-responsive" alt="">
                            <input id="icon_image" name="userfile[]" class="input-file form-control" type="file">Keep size to 78x78px
                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="admin_name">Administrator Name</label>  
                        <div class="col-md-4">
                            <input id="admin_name" name="admin_name" type="text" value="" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="email">Contact Email</label>  
                        <div class="col-md-4">
                            <input id="email" name="email" type="email" value="" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="address">Organization's Address</label>  
                        <div class="col-md-4">
                            <input id="address" name="address" type="text" value="" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="phone">Phone Number</label>  
                        <div class="col-md-4">
                            <input id="phone" name="phone" type="tel" value="" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="website">Website (if applicable)</label>  
                        <div class="col-md-4">
                            <input id="website" name="website" type="text" value="" placeholder="" class="form-control input-md">

                        </div>
                    </div>

                    <!-- TODO : Load dynamically this type -->
                    <!-- Select Basic -->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="type">Organization Type</label>
                        <div class="col-md-4">
                            <select id="type" name="type" class="form-control">
                                <option value="1" >Local Non-profit organization</option>
                                <option value="2" >International Non-profit organization</option>
                                <option value="3" >Child Care Center or Shelter</option>
                                <option value="4" >Mass Organization</option>
                                <option value="5" >Religious Organization</option>
                            </select>
                        </div>
                    </div>


                    <!-- Textarea -->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="description">Description/Mission</label>
                        <div class="col-md-4">                     
                            <textarea class="form-control" id="description" name="description" required=""></textarea>
                        </div>
                    </div>


                    <hr>
                    <h3 id="additional_information">
                        Additional information.
                    </h3>
                    <p>
                        Please add your donation information.
                    </p>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="fanpage">Facebook Fanpage</label>  
                        <div class="col-md-4">
                            <input id="fanpage" name="fanpage" type="text" placeholder="https://www.facebook.com/[yourfanpage]" class="form-control input-md">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="donation_message">Danation Message</label>  
                        <div class="col-md-4">
                            <textarea class="form-control" id="donation_message" name="donation_message"></textarea>

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="donation_web">Donation web link</label>  
                        <div class="col-md-4">
                            <input id="donation_web" name="donation_web" type="text" placeholder="" class="form-control input-md">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="donation_paypal">Donation Paypal</label>  
                        <div class="col-md-4">
                            <input id="donation_paypal" name="donation_paypal" type="text" placeholder="" class="form-control input-md">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="donation_address">Donation physical address</label>  
                        <div class="col-md-4">
                            <input id="donation_address" name="donation_address" type="text" placeholder="" class="form-control input-md">

                        </div>
                    </div>

                    <!------------ Button --------->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="submit"></label>
                        <div class="col-md-4">
                            <button id="submit" name="submit" class="btn btn-block btn-primary">Submit Information</button>

                        </div>
                    </div>


                </fieldset>
            </form>

        </div> <!--End of main form.-->



    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->