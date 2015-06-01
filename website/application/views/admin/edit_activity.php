<div id="wrapper">

    <div id="page-wrapper">

        <h1>Edit Activity</h1>
        <p>Edit activity information.</p>

        <div id="alert_placeholder"></div>
        <div class="col-lg-8">
            <form id="activity-form" class="form-horizontal" onSubmit="updateActivity(<?php echo $activityId?>);
                return false;">
                <fieldset>

                    <!-- Form Name -->
                    <legend></legend>

                    <input type="hidden" name="partner-id" id="partner-id" value="">
                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="title">Title of Activity</label>  
                        <div class="col-md-8">
                            <input id="title" name="title" type="text" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Textarea -->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="description">Description</label>
                        <div class="col-md-8">                     
                            <textarea class="form-control" id="description" name="description"></textarea>
                        </div>
                    </div>

                    <p>
                        What is the action(s) the hero must perform to receive their points? Please check the boxes that apply.
                    </p>

                    <!-- Multiple Checkboxes -->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="check_facebook"></label>

                        <div class="col-md-8">
                            <div class="radio">
                                <label>
                                    <input type="radio" name="action" id="check_facebook" value="1" checked>
                                    Share on their Facebook
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
                                    Sign up for Your news letter
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="newsletter_link"></label>  
                        <div class="col-md-8">
                            <input id="newsletter_link" name="newsletter_link" type="text" placeholder="Please enter a link to your newsletter." class="form-control input-md">

                        </div>
                    </div>

                    <!-- Multiple Checkboxes -->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="check_facebook_page"></label>
                        <div class="col-md-8">
                            <div class="radio">
                                <label>
                                    <input type="radio" name="action" id="check_facebook_page" value="3">
                                    Like our facebook page
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="facebook_page"></label>  
                        <div class="col-md-8">
                            <input id="facebook_page" name="facebook_page" type="text" placeholder="Please enter your facebook page address." class="form-control input-md">

                        </div>
                    </div>

                    <!-- Multiple Checkboxes -->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="check_calendar"></label>
                        <div class="col-md-8">
                            <div class="radio">
                                <label>
                                    <input type="radio" name="action" id="check_calendar" value="4">
                                    Add to User's calendar
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="calendar"></label>  
                        <div class="col-md-8 date input-group" id="datetimepicker">
                            <input id="calendar" name="calendar" type="text" placeholder="Please select a date" class="form-control" data-format="YYYY/MM/DD">
                            <span class="input-group-addon"><span data-icon-element="" class="fa fa-calendar">
                                </span>
                            </span>
                        </div>
                    </div>


                    <legend></legend>
                    <!-- Button -->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="submit"></label>
                        <div class="col-md-8">
                            <button id="submit" name="submit" class="btn btn-primary">Update Activity</button>
                            
                        </div>
                    </div>


                </fieldset>
            </form>
        </div>



        <div class="col-lg-4 left-border">
            <form class="" role="form">
                <fieldset>

                    <!-- Form Name -->
                    <legend></legend>

                    <!-- Select Basic -->
                    <div class="form-group">
                        <label class="control-label" for="point">Bonus Point</label>
                        <div class="col-md-12">
                            <input id="point" name="point" type="number" placeholder="" class="form-control input-md" min="1" max="500">
                        </div>
                    </div>

                    <!-- Button (Double) -->
                    <div class="form-group">
                        <label class="control-label" for="approve">Approve?</label>
                        <div class="col-md-12" id="approve-activity">
                            <button type="button" id="approve" name="approve" class="btn btn-success" onclick="approveActivity(<?php echo $activityId ?>, 1);">Yes</button>
                            <button type="button" id="deny" name="deny" class="btn btn-danger" onclick="approveActivity(<?php echo $activityId ?>, 0)">No</button>
                        </div>
                    </div>
                    <br>
                    <hr class ="hr-blue">
                    <!-- Button -->
                    <div class="form-group">
                        <label class="control-label" for="delete"></label>
                        <div class="col-md-12">
                            <button type="button" id="delete" name="delete" class="btn btn-danger btn-block" onclick="callDeleteAct(<?php echo $activityId ?>)"> Delete Activity</button>
                        </div>
                    </div>

                </fieldset>
            </form>
        </div>



    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->

<script>
            $(function() {
                getActivity(<?php echo $activityId; ?>);
            });
</script>