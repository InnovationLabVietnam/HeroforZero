<div id="wrapper">

    <div id="page-wrapper">

        <h1>Tạo một câu hỏi</h1>
        <p>Những câu hỏi trắc nghiệm này sẽ xuất hiện trong ứng dụng của người dùng. Câu hỏi của bạn đồng thời cũng cung cấp những thông tin bổ ích cho người dùng nữa.</p>

        
        <div id="alert_placeholder"></div>
        <form id="quiz-form" class="form-horizontal" onSubmit="return false;">
            <fieldset>

                <!-- Form Name -->
                <legend></legend>
                <input type="hidden" name="partner-id" id="partner-id" value="<?php echo $partnerId ?>">

                <!-- Select Basic -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="category">Loại câu hỏi</label>
                    <div class="col-md-8" id="select-category">
                        
                    </div>
                </div>

                <!-- Textarea -->
<div class="form-group">
  <label class="col-md-4 control-label" for="question">Câu hỏi</label>
  <div class="col-md-8">                     
    <textarea class="form-control" id="question" name="question" required="" placeholder="Giới hạn 140 ký tự" maxlength="140"></textarea>
  </div>
</div>
                <!-- File Button --> 
<div class="form-group">
  <label class="col-md-4 control-label" for="userfile"></label>
  <div class="col-md-8">
    <input id="userfile" name="userfile" class="input-file form-control" type="file"><p id="fileLabel">Chọn hình ảnh (nếu có) cho câu hỏi.</p>
  </div>
</div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="answer_a">Phương án A:</label>  
                    <div class="col-md-8">
                        <input id="answer_a" name="answer_a" type="text" placeholder="Giới hạn 50 ký tự" required="" class="form-control input-md" maxlength="50">

                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="answer_b">Phương án B:</label>  
                    <div class="col-md-8">
                        <input id="answer_b" name="answer_b" type="text" placeholder="Giới hạn 50 ký tự"  required="" class="form-control input-md" maxlength="50">

                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="answer_c">Phương án C:</label>  
                    <div class="col-md-8">
                        <input id="answer_c" name="answer_c" type="text" placeholder="Giới hạn 50 ký tự" required=""  class="form-control input-md" maxlength="50">

                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="answer_d">Phương án D:</label>  
                    <div class="col-md-8">
                        <input id="answer_d" name="answer_d" type="text" placeholder="Giới hạn 50 ký tự"  required="" class="form-control input-md" maxlength="50">

                    </div>
                </div>

                <!-- Multiple Radios (inline) -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="answer">Đáp án</label>
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
  <label class="col-md-4 control-label" for="sharing">Thông tin thêm</label>
  <div class="col-md-8">                     
    <textarea class="form-control" id="sharing" placeholder="Những thông tin thêm mà người dùng có thể chia sẻ lên facebook của họ. Giới hạn 140 ký tự." name="sharing" maxlength="140"></textarea>
  </div>
</div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="link">Đường dẫn tìm hiểu thêm</label>  
                    <div class="col-md-8">
                        <input id="link" name="link" type="text" placeholder="Địa chỉ website có thông tin chi tiết." class="form-control input-md">

                    </div>
                </div>

                <!-- Button -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="submit"></label>
                    <div class="col-md-8">
                        <button id="submit" name="submit" class="btn btn-primary">Hoàn tất</button>
                    </div>
                </div>

            </fieldset>
        </form>


    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->