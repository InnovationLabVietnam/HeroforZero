<div id="wrapper">

    <div id="page-wrapper">

        <h1>Create a Quiz</h1>
        <p>To Create a Quiz please fill out the information below.</p>

        
        <div id="alert_placeholder"></div>
        <form id="quiz-form" class="form-horizontal" onSubmit="return false;">
            <fieldset>

                <!-- Form Name -->
                <legend></legend>
                <input type="hidden" name="partner-id" id="partner-id" value="<?php echo $partnerId ?>">

                <!-- Select Basic -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="category">Quiz Category</label>
                    <div class="col-md-8" id="select-category">
                        
                    </div>
                </div>

                <!-- Textarea -->
<div class="form-group">
  <label class="col-md-4 control-label" for="question">Quiz Question</label>
  <div class="col-md-8">                     
    <textarea class="form-control" id="question" name="question" required=""  placeholder="Limits to 140 characters" maxlength="140"></textarea>
  </div>
</div>
                
                <!-- File Button --> 
<div class="form-group">
  <label class="col-md-4 control-label" for="userfile"></label>
  <div class="col-md-8">
    <input id="userfile" name="userfile" class="input-file form-control" type="file"><p id="fileLabel">Choose an image for your question</p>
  </div>
</div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="answer_a">Answer A:</label>  
                    <div class="col-md-8">
                        <input id="answer_a" name="answer_a" type="text" placeholder="Limits to 50 characters" required="" class="form-control input-md" maxlength="50">

                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="answer_b">Answer B:</label>  
                    <div class="col-md-8">
                        <input id="answer_b" name="answer_b" type="text" placeholder="Limits to 50 characters"  required="" class="form-control input-md" maxlength="50">

                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="answer_c">Answer C:</label>  
                    <div class="col-md-8">
                        <input id="answer_c" name="answer_c" type="text" placeholder="Limits to 50 characters"  required="" class="form-control input-md" maxlength="50">

                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="answer_d">Answer D:</label>  
                    <div class="col-md-8">
                        <input id="answer_d" name="answer_d" type="text" placeholder="Limits to 50 characters"  required="" class="form-control input-md" maxlength="50">

                    </div>
                </div>

                <!-- Multiple Radios (inline) -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="answer">Correct Answer</label>
                    <div class="col-md-8"> 
                        <label class="radio-inline" for="answer-0">
                            <input type="radio" name="answer" id="answer-0" value="0" checked="checked">
                            A
                        </label> 
                        <label class="radio-inline" for="answer-1">
                            <input type="radio" name="answer" id="answer-1" value="1">
                            B
                        </label> 
                        <label class="radio-inline" for="answer-2">
                            <input type="radio" name="answer" id="answer-2" value="2">
                            C
                        </label> 
                        <label class="radio-inline" for="answer-3">
                            <input type="radio" name="answer" id="answer-3" value="3">
                            D
                        </label>
                    </div>
                </div>

                <!-- Textarea -->
<div class="form-group">
  <label class="col-md-4 control-label" for="sharing">Sharing Information</label>
  <div class="col-md-8">                     
    <textarea class="form-control" id="sharing" placeholder="Write down a fact related to the question you would like the user to share. Limit to 140 characters." name="sharing" maxlength="140"></textarea>
  </div>
</div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="link">More Link URL</label>  
                    <div class="col-md-8">
                        <input id="link" name="link" type="text" placeholder="Website URL for learning more" class="form-control input-md">

                    </div>
                </div>

                <!-- Button -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="submit"></label>
                    <div class="col-md-8">
                        <button id="submit" name="submit" class="btn btn-primary">Submit Quiz</button>
                    </div>
                </div>

            </fieldset>
        </form>


    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->