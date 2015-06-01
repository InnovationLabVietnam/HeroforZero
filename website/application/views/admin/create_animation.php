<div id="wrapper">

    <div id="page-wrapper">

        <h1>Create a Animation</h1>
        <p>Fill in the animation's index.</p>

        <div id="alert_placeholder"></div>
            <form id="animation-form" class="form-horizontal" role="form" onsubmit="return false;">
                <fieldset>

                    <!-- Form Name -->
                    <legend></legend>
                    
                    <input type="hidden" name="animation-id" id="animation-id" value="<?php echo $animation_id ?>">

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="time">Time</label>  
                        <div class="col-md-4">
                            <input id="time" name="time" type="number" placeholder="Time in second" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="walking">Hero Animation Walking</label>  
                        <div class="col-md-4">
                            <input id="walking" name="walking" type="text" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="standby">Hero Animation Standby</label>  
                        <div class="col-md-4">
                            <input id="standby" name="standby" type="text" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="monster">Monster Animation</label>  
                        <div class="col-md-4">
                            <input id="monster" name="monster" type="text" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="kid">Kid Frame</label>  
                        <div class="col-md-4">
                            <input id="kid" name="kid" type="text" placeholder="" class="form-control input-md" required="">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="color">Background Color</label>  
                        <div class="col-md-4">
                            <input id="color" name="color" type="text" placeholder="" class="form-control input-md color-picker" value = 'rgb(0,0,0)' required="">

                        </div>
                    </div>

                    <!-- File Button --> 
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="userfile">Screenshot</label>
                        <div class="col-md-4">
                            <img id="screenshot" src="" class="img-responsive" alt="">
                            <input id="userfile" name="userfile" class="input-file" type="file">
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



    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->