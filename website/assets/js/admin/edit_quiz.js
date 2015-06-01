$(function (){
    //drawSelectCategory();
});

// Variable to store your files
var files;
var imageUrl = "";

$(function() {
    
    drawSelectCategory();
    
    
    

    // Add events
    $('input[type=file]').on('change', prepareUpload);
    $('form').on('submit', submitQuiz);

    // Grab the files and set them to our variable
    function prepareUpload(event) {
        files = event.target.files;
    }
    
    function submitQuiz(event){
        if (files && files.length){
            // File attacked
            uploadFiles(event)
        } else {
            // Not file choosen. Just submit bare quiz.
            updateQuiz(imageUrl);
        }
    }

});


/*
 * Upload file, then, if successfull will automatically call create Quiz function.
 */
function uploadFiles(event) {
    var baseUrl = $("#base-url").attr("href");
    
    // Stop stuff happening.
    event.stopPropagation();
    event.preventDefault();

    // START A LOADING SPINNER HERE

    // Create a formdata object and add the files.
    var data = new FormData();
    $.each(files, function(key, value) {
        data.append('userfile', value);
    });

    $.ajax({
        url: baseUrl + "process/upload",
        type: 'POST',
        data: data,
        cache: false,
        dataType: 'json',
        processData: false, // Do not process the file.
        contentType: false, // Set content type to false as jQuery will tell the server its a query string request
        success: function(data) {
            if (data.code === 1) {
                // SUCCESS.
                // Call function to create packet.
                var fileUrl = data.info.file_name;
                updateQuiz(fileUrl);
            } else {
                // Error
                console.log('ERRORS: ' + data.error);
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.log("ERRORS: " + textStatus);

            // STOP LOADING SPINNER
        }
    });
}

function getQuiz(quizId) {
    //var baseUrl = window.location.protocol + "//" + window.location.host + "/";
    var baseUrl = $("#base-url").attr("href");
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "quiz/getQuiz",
            {
                id: quizId
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    
                    // Update the first form
                    $('#category').val(parseInt(data.info.quiz.CategoryId));
                    $('#question').val(data.info.quiz.Content);
                    
                    // Quiz Image
                    $('#quiz_image').attr('src', data.info.quiz.ImageURL);
                    imageUrl = data.info.quiz.ImageURL;
                    
                    $('#answer_a').val(data.info.choice[0].answerContent);
                    $('#answer_b').val(data.info.choice[1].answerContent);
                    $('#answer_c').val(data.info.choice[2].answerContent);
                    $('#answer_d').val(data.info.choice[3].answerContent);
                    // Set the correct answer:
                    var $radios = $('input:radio[name=answer]');
                    switch (parseInt(data.info.quiz.CorrectChoiceId)) {
                        case parseInt(data.info.choice[0].Id):
                            $radios.filter('[value=0]').prop('checked', true);
                            break;
                        case parseInt(data.info.choice[1].Id):
                            $radios.filter('[value=1]').prop('checked', true);
                            break;
                        case parseInt(data.info.choice[2].Id):
                            $radios.filter('[value=2]').prop('checked', true);
                            break;
                        case parseInt(data.info.choice[3].Id):
                            $radios.filter('[value=3]').prop('checked', true);
                            break;
                        default:
                            $radios.filter('[value=0]').prop('checked', true);
                    }
                    $('#sharing').val(data.info.quiz.SharingInfo);
                    $('#link').val(data.info.quiz.LearnMoreURL);
                    
                    // Update the second form:
                    $('#point').val(data.info.quiz.BonusPoint);
                    $('#date').val(data.info.quiz.CreatedDate);
                    if (parseInt(data.info.quiz.IsApproved ===1)){
                        $('#approve').attr('disabled', 'true');
                        $('#deny').removeAttr("disabled");
                    } else {
                        $('#deny').attr('disabled', 'true');
                        $('#approve').removeAttr("disabled");
                    }
                } else { // Fail

                }
            },
            "json"
            );
}


function updateQuiz(imageUrl){
    var baseUrl = $("#base-url").attr("href");
    
    var quizId = $("#quiz_id").val();
    var category = $("#category").val();
    var question = $("#question").val();
    var answer_a = $("#answer_a").val();
    var answer_b = $("#answer_b").val();
    var answer_c = $("#answer_c").val();
    var answer_d = $("#answer_d").val();
    var correct_answer = $("input[name='answer']:checked", '#quiz-form').val();
    var sharing = $("#sharing").val();
    var link = $("#link").val();
    
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "quiz/updateQuiz",
            {
                id: quizId,
                category: category,
                question: question,
                image_url: imageUrl,
                answer_a: answer_a,
                answer_b: answer_b,
                answer_c: answer_c,
                answer_d: answer_d,
                correct_answer: correct_answer,
                sharing: sharing,
                link: link
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    
                    // Update form from server data
                    /*
                    // Update the first form
                    $('#category').val(data.info.quiz.CategoryId);
                    $('#question').val(data.info.quiz.Content);
                    $('#answer_a').val(data.info.quiz.AnswerA);
                    $('#answer_b').val(data.info.quiz.AnswerB);
                    $('#answer_c').val(data.info.quiz.AnswerC);
                    $('#answer_d').val(data.info.quiz.AnswerD);
                    // Set the correct answer:
                    var $radios = $('input:radio[name=answer]');
                    switch (data.info.quiz.CorrectChoiceId) {
                        case data.info.quiz.AnswerAId:
                            $radios.filter('[value=0]').prop('checked', true);
                            break;
                        case data.info.quiz.AnswerBId:
                            $radios.filter('[value=1]').prop('checked', true);
                            break;
                        case data.info.quiz.AnswerCId:
                            $radios.filter('[value=2]').prop('checked', true);
                            break;
                        case data.info.quiz.AnswerDId:
                            $radios.filter('[value=3]').prop('checked', true);
                            break;
                        default:
                            $radios.filter('[value=0]').prop('checked', true);
                    }
                    $('#sharing').val(data.info.quiz.SharingInfo);
                    $('#link').val(data.info.quiz.LearnMoreURL);
                    
                    // Update the second form:
                    $('#packet').val(data.info.quiz.PacketId);
                    $('#point').val(data.info.quiz.BonusPoint);
                    $('#date').val(data.info.quiz.PublishedDate);
                    */
                   
                   /*
                    * Just simple left the form unchange.
                    */
                   successfulAlert("Your Quiz has been updated!");
                   $('html, body').animate({ scrollTop: 0 }, 'fast');
                } else { // Fail

                }
            },
            "json"
            );
    // Update point also :D
    var point = $('#point').val();
    updatePoint(quizId, point);
}

successfulAlert = function(message) {
    var baseUrl = $("#base-url").attr("href");
    $('#alert_placeholder').html('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><span>' + message + '</span> </div>')
}

// Not used
function updatePacket(quizId, packetId){
    var baseUrl = $("#base-url").attr("href");
    
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "admin/testapi",
            {
                id: quizId,
                packet_id: packetId
            },
            function(data) {
                console.log("updatePacket");
                if (data.code === 1) { // Successful
                    
                    // Update the first form
                    $('#packet').val(data.info.packet_id);
                } else { // Fail

                }
            },
            "json"
            );
}

function updatePoint(quizId, point){
    var baseUrl = $("#base-url").attr("href");
    
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "quiz/updateBonusPoint",
            {
                id: quizId,
                point: point
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    
                    // Update the first form
                } else { // Fail

                }
            },
            "json"
            );
}

function approveQuiz(quizId, state){
    var baseUrl = $("#base-url").attr("href");
    
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "quiz/updateIsApproved",
            {
                id: quizId,
                is_approved: state
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    successfulAlert("Approve successfully!");
                } else { // Fail

                }
            },
            "json"
            );
}

function callDelete(quizId){
    bootbox.confirm(
            "Are you sure you want to delete this question. The action cannot be undone!",
            function(result){
                if (result){
                    deleteQuiz(quizId);
                }
            }
        );
}

function deleteQuiz(quizId){
    var baseUrl = $("#base-url").attr("href");
    console.log("Deleting");
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "quiz/deleteQuiz",
            {
                id: quizId,
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    bootbox.alert("Delete successfuly! Come back to home page!", 
                        function(){
                            window.location.replace(baseUrl + "admin/index");
                        });
                } else { // Fail
                    bootbox.alert("Some error happened that we cannot delete the quest. Please try again later.", 
                        function(){
                            
                        });
                }
            },
            "json"
            );
}

function drawSelectCategory(){
    var baseUrl = $("#base-url").attr("href");
    
    // Post to api
    $.post(
            baseUrl + "quizcategory/getQuizCategoryList",
            {
                pageSize: 0,
                pageNumber: 0
            },
            function(data) {
                console.log(data);
                if (data.code == 1) { // Successful
                    var category = data.info.category;
                    var select = $('<select id="category" name="category" class="form-control">').appendTo('#select-category');
                    //select.append($("<option>").attr('value', 0).text('Please select a category'));
                    for (var i=0; i<category.length; i++){
                        select.append($("<option>").attr('value', category[i].Id).text(category[i].CategoryName));
                    }
                } else { // Fail
                    
                }
            },
            "json"
        );
}
