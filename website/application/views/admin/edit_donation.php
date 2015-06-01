<div id="wrapper">

    <div id="page-wrapper">

        <h1>Edit Donation</h1>
        <p>Edit donation information.</p>

        <div id="alert_placeholder"></div>
        <div class="col-lg-8">
            <form id="donation-form" class="form-horizontal" onSubmit="updateDonation(<?php echo $donationId?>);
                    return false;">
                <fieldset>

                    <!-- Form Name -->
                    <legend></legend>
                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="title">Title of Donation</label>  
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

                    <!-- Button -->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="submit"></label>
                        <div class="col-md-8">
                            <button id="submit" name="submit" class="btn btn-primary">Update Donation</button>
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
                        <div class="col-md-12" id="approve-donation">
                            <button type="button" id="approve" name="approve" class="btn btn-success" onclick="approveDonation(<?php echo $donationId ?>, 1);">Yes</button>
                            <button type="button" id="deny" name="deny" class="btn btn-danger" onclick="approveDonation(<?php echo $donationId ?>, 0)">No</button>
                        </div>
                    </div>
                    <br>
                    <hr class ="hr-blue">
                    <!-- Button -->
                    <div class="form-group">
                        <label class="control-label" for="delete"></label>
                        <div class="col-md-12">
                            <button type="button" id="delete" name="delete" class="btn btn-danger btn-block" onclick="callDeleteAct(<?php echo $donationId ?>)"> Delete Donation</button>
                        </div>
                    </div>

                </fieldset>
            </form>
        </div>



    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->

<script>
    $(function() {
        getDonation(<?php echo $donationId; ?>);
    });
</script>