<div id="wrapper">

    <div id="page-wrapper">

        <h1>Edit Packet</h1>
        <p>Change image as you like.</p>


        <form class='form-horizontal' role ='form' onsubmit="return false;">
            <fieldset>
                <!-- Form Name -->
                <legend></legend>
                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="packet">Packet's Name</label>  
                    <div class="col-md-8">
                        <input id="packet" name="packet" type="text" placeholder="Write the packet's name" class="form-control input-md" required="">

                    </div>
                </div>

                <input type="hidden" id ="packet_id" name="packet_id" value="<?php echo $packetId ?>">
                <!-- File Button --> 
                <div class="form-group">
                    <label class="col-md-4 control-label" for="userfile">Background</label>
                    <div class="col-md-8">
                        <input id="userfile" name="userfile" class="input-file form-control" type="file">
                    </div>
                </div>
                <!-- Button -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="submit"></label>
                    <div class="col-md-8">
                        <button id="submit" type='submit' class='btn btn-block btn-primary' data-loading-text="Saving...">Update</button>
                    </div>
                </div>
            </fieldset>
        </form>

    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->

<script>
    $(function() {
        getPacket(<?php echo $packetId; ?>);
    });
</script>
