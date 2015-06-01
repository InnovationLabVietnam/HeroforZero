<div id="wrapper">

    <div id="page-wrapper">

        <h1>Create a Quest</h1>
        <p>Please select the fields below to create a quest.</p>

        <div id="alert_placeholder"></div>
        <div class="col-lg-8">
        <form id="quest-form" class="form-horizontal" role="form" onsubmit="return false;">
            <fieldset>

                <!-- Form Name -->
                <legend></legend>

                <input type="hidden" name="partner-id" id="partner-id" value="<?php echo $partnerId ?>">
                <input type="hidden" name="quest-id" id="quest-id" value="<?php echo $questId ?>">
                <!-- Select Basic -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="packet">Choose Quest Packet</label>
                    <div class="col-md-8" id="select-packet">
                        <select id="packet" name="packet" class="form-control">
                            
                        </select>
                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="name">Name</label>  
                    <div class="col-md-8">
                        <input id="name" name="name" type="text" placeholder="Title for the quest" class="form-control input-md" required="">

                    </div>
                </div>
                
                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="unlock">Unlock Point</label>  
                    <div class="col-md-8">
                        <input id="unlock" name="unlock" type="text" placeholder="Amount of points user must have to unlock this quest." class="form-control input-md" required="">
                        
                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="point">Point to Advance</label>  
                    <div class="col-md-8">
                        <input id="point" name="point" type="text" placeholder="Amount of points user must earn to complete the quest." class="form-control input-md" required="">
                        
                    </div>
                </div>
                
                <!-- Select Basic -->
<div class="form-group">
  <label class="col-md-4 control-label" for="animation">Animation</label>
  <div class="col-md-8" id="select-animation">
   
  </div>
</div>
                <!-- Select Basic -->
<div class="form-group">
  <label class="col-md-4 control-label" for="character">Quest character</label>
  <div class="col-md-8">
    <select id="character" name="character" class="form-control">
        <option data-img-src="<?php echo base_url() ?>assets/img/quest/training-sword.png" value="<?php echo base_url() ?>assets/img/quest/training-sword.png">Sword</option>
        <option data-img-src="<?php echo base_url() ?>assets/img/quest/training-shield.png" value="<?php echo base_url() ?>assets/img/quest/training-shield.png">Shield</option>
        <option data-img-src="<?php echo base_url() ?>assets/img/quest/training-cape.png" value="<?php echo base_url() ?>assets/img/quest/training-cape.png">Cape</option>
        <option data-img-src="<?php echo base_url() ?>assets/img/quest/nutrition-minority.png" value="<?php echo base_url() ?>assets/img/quest/nutrition-minority.png">My</option>
        <option data-img-src="<?php echo base_url() ?>assets/img/quest/nutrition-buddist.png" value="<?php echo base_url() ?>assets/img/quest/nutrition-buddist.png">Tieu</option>
        <option data-img-src="<?php echo base_url() ?>assets/img/quest/nutrition-streetkid.png" value="<?php echo base_url() ?>assets/img/quest/nutrition-streetkid.png">Ty</option>
        <option data-img-src="<?php echo base_url() ?>assets/img/quest/education-lottogirl.png" value="<?php echo base_url() ?>assets/img/quest/education-lottogirl.png">Mai</option>
        <option data-img-src="<?php echo base_url() ?>assets/img/quest/education-minority.png" value="<?php echo base_url() ?>assets/img/quest/education-minority.png">Han</option>
        <option data-img-src="<?php echo base_url() ?>assets/img/quest/education-streetworker.png" value="<?php echo base_url() ?>assets/img/quest/education-streetworker.png">Nam</option>
        <option data-img-src="<?php echo base_url() ?>assets/img/quest/protection-abused.png" value="<?php echo base_url() ?>assets/img/quest/protection-abused.png">Thao</option>
        <option data-img-src="<?php echo base_url() ?>assets/img/quest/protection-cripple.png" value="<?php echo base_url() ?>assets/img/quest/protection-cripple.png">Uy</option>
        <option data-img-src="<?php echo base_url() ?>assets/img/quest/health-sick.png" value="<?php echo base_url() ?>assets/img/quest/health-sick.png">Ba</option>
        
      
    </select>
  </div>
</div>
                

                <!-- Select Basic -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="category">Quiz Category</label>
                    <div class="col-md-8" id="select-category">
                    </div>
                </div>

                <!-- Select Basic -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="activity_1">Choose the Activity</label>
                    <div class="col-md-8" id="select-activity-1">
                    </div>
                </div>

                <!-- Select Basic -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="activity_2"></label>
                    <div class="col-md-8" id="select-activity-2">
                    </div>
                </div>

                <!-- Select Basic -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="activity_3"></label>
                    <div class="col-md-8" id="select-activity-3">
                    </div>
                </div>

                <!-- Select Basic -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="donation_1">Choose Donation</label>
                    <div class="col-md-8" id="select-donation-1">
                    </div>
                </div>

                <!-- Select Basic -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="donation_2"></label>
                    <div class="col-md-8" id="select-donation-2">
                    </div>
                </div>

                <!-- Select Basic -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="donation"></label>
                    <div class="col-md-8" id="select-donation-3">
                    </div>
                </div>

                <!-- Button -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="submit"></label>
                    <div class="col-md-8">
                        <button id="submit" name="submit" class="btn btn-primary">Submit</button>
                        
                    </div>
                </div>

            </fieldset>
        </form>
        </div>
        
        <?php if ($edit_quest) : ?>
            <div class="col-lg-4 left-border">
            <form class="" role="form">
                <fieldset>

                    <!-- Form Name -->
                    <legend></legend>

                    <!-- Button -->
                    <div class="form-group">
                        <label class="control-label" for="delete"></label>
                        <div class="col-md-12">
                            <button type="button" id="delete" name="delete" class="btn btn-danger btn-block" onclick="callDeleteQuest(<?php echo $questId ?>)" disabled="disabled"> Delete Quest</button>
                        </div>
                    </div>

                </fieldset>
            </form>
        </div>
        <?php endif; ?>


    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->