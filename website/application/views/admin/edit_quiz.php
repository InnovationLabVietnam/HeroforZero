<div id="wrapper">

    <div id="page-wrapper">

        <h1>Edit a Quiz</h1>
        <p>You can edit the Quiz to be more accurate.</p>
        <div id="alert_placeholder"></div>
        <div class="col-lg-8">
            <form id="quiz-form" class="form-horizontal" onsubmit=" return false;">
                <fieldset>

                    <!-- Form Name -->
                    <legend></legend>
                    
                    <input type="hidden" id="quiz_id" value="<?php echo $quizId; ?>">

                    <!-- Select Basic -->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="category">Quest Category</label>
                        <div class="col-md-8" id="select-category">
                            
                        </div>
                    </div>
                    
                    <!-- Textarea -->
<div class="form-group">
  <label class="col-md-4 control-label" for="question">Quest Question</label>
  <div class="col-md-8">                     
    <textarea class="form-control" id="question" name="question"></textarea>
  </div>
</div>
 

                    <!-- File Button --> 
<div class="form-group">
  <label class="col-md-4 control-label" for="userfile"></label>
  <div class="col-md-8">
      <img id="quiz_image" src="" class="img-responsive" alt="">
    <input id="userfile" name="userfile" class="input-file form-control" type="file"><p id="fileLabel">Choose an image for your question</p>
  </div>
</div>
                    

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="answer_a">Answer A:</label>  
                        <div class="col-md-8">
                            <input id="answer_a" name="answer_a" type="text" placeholder="Limits to 50 characters" class="form-control input-md">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="answer_b">Answer B:</label>  
                        <div class="col-md-8">
                            <input id="answer_b" name="answer_b" type="text" placeholder="Limits to 50 characters" class="form-control input-md">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="answer_c">Answer C:</label>  
                        <div class="col-md-8">
                            <input id="answer_c" name="answer_c" type="text" placeholder="Limits to 50 characters" class="form-control input-md">

                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="answer_d">Answer D:</label>  
                        <div class="col-md-8">
                            <input id="answer_d" name="answer_d" type="text" placeholder="Limits to 50 characters" class="form-control input-md">

                        </div>
                    </div>

                    <!-- Multiple Radios (inline) -->
                    <div class="form-group">
                        <label class="col-md-4 control-label" for="answer">Correct Answer</label>
                        <div class="col-md-4"> 
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
    <textarea class="form-control" id="sharing" name="sharing" placeholder="Write down a fact related to the question you would like the user to share. Limit to 140 characters." maxlength="140"></textarea>
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
                            <button id="submit" name="submit" class="btn btn-primary">Update Quiz</button>
                            
                        </div>
                    </div>

                </fieldset>
            </form> <!-- End of form 1 -->
        </div>

        <div class="col-lg-4 left-border">
            <form class="" role="form">
                <fieldset>

                    <!-- Form Name -->
                    <legend></legend>

                    <!-- Select Basic -->
                    <div class="form-group">
                        <label class="control-label" for="point">Point</label>
                        <div class="">
                            <input id="point" name="point" type="number" placeholder="" class="form-control input-md" min="1" max="500">
                        </div>
                    </div>

                    <!-- Button (Double) -->
                    <div class="form-group">
                        <label class=" control-label" for="approve">Approve:</label>
                        <div class="">
                            <button type="button" id="approve" name="approve" class="btn  btn-success" onclick="approveQuiz(<?php echo $quizId ?>, 1);">Yes</button>
                            <button type="button" id="deny" name="deny" class="btn  btn-danger" onclick="approveQuiz(<?php echo $quizId ?>, 0)">No</button>
                        </div>
                    </div>

                    <!-- Text input-->
                    <div class="form-group">
                        <label class=" control-label" for="date">Published on:</label>  
                        <div class="">
                            <input id="date" name="date" type="text" placeholder="YYYY/MM/DD" class="form-control input-md" disabled>

                        </div>
                    </div>

                    <hr class ="hr-blue">
                    <!-- Button -->
                    <div class="form-group">
                        <label class=" control-label" for="delete"></label>
                        <div class="">
                            <button type="button" id="delete" name="delete" class="btn btn-block btn-danger" onclick="callDelete(<?php echo $quizId ?>)">Delete Question</button>
                        </div>
                    </div>

                </fieldset>
            </form>
        </div>


    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->

<script>
    $(function() {
        getQuiz(<?php echo $quizId; ?>);
    });
</script>