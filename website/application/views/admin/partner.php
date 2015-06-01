<div id="wrapper">

    <div id="page-wrapper">

        <h1>Partner Information</h1>
        <p></p>
        
        <div id="alert_placeholder"></div>
        <div class="col-lg-8">
            <div id="partner-info">
                
            </div>
        </div>



        <div class="col-lg-4 left-border">
            <form class="" role="form">
                <fieldset>

                    <!-- Form Name -->
                    <legend></legend>

                    <!-- Button (Double) -->
                    <div class="form-group">
                        <label class="control-label" for="approve">Approve?</label>
                        <div class="col-md-12" id="approve-partner">
                            <button type="button" id="approve" name="approve" class="btn btn-success" onclick="approvePartner(<?php echo $partnerId ?>, 1);">Yes</button>
                            <button type="button" id="deny" name="deny" class="btn btn-danger" onclick="approvePartner(<?php echo $partnerId ?>, 0)">No</button>
                        </div>
                    </div>
                    
                    <br>
                    
                    <div class="form-group">
                        <label class="control-label" for="approve">Administration</label>
                        <div class="col-md-12" id="edit_partner">
                            <a href="/admin/edit_partner/<?php echo $partnerId ?>">Edit partner information</a>
                        </div>
                    </div>
                    <!-- Button 
                    <div class="form-group">
                        <label class="control-label" for="delete"></label>
                        <div class="col-md-12">
                            <button type="button" id="delete" name="delete" class="btn btn-danger btn-block" onclick="callDelete(<?php echo $partnerId ?>)"> Delete Partner</button>
                        </div>
                    </div> -->

                </fieldset>
            </form>
        </div>



    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->

<script>
    $(function() {
        getPartner(<?php echo $partnerId; ?>);
    });
</script>