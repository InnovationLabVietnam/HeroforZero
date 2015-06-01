// Variable to store your files
var files;

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
            createQuiz("");
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
                createQuiz(fileUrl);
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

function createQuiz(imageUrl) {
    //var baseUrl = window.location.protocol + "//" + window.location.host + "/";
    var baseUrl = $("#base-url").attr("href");

    // Get the input data:
    // TODO : partner ID
    var partner_id = $("#partner-id").val();
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
    $('#submit').attr('disabled', 'true');
    
    // Post to api
    $.post(
            baseUrl + "quiz/insertQuiz",
            {
                partner_id: partner_id,
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
                if (data.code == 1) { // Successful

                    // Store session

                    // Check the role and redirect

                    // Redirect to admin page
                    //return false;
                    successfulAlert("Your Quiz has been created successfully. ");
                    //window.location.replace(baseUrl + "organization/create_activity");
                    
                    
                    // Reset the form
                    $('#submit').removeAttr("disabled");
                    $('#quiz-form')[0].reset();
                    
                    return false;
                } else { // Fail
                    bootstrap_alert.warning("Some error occurred, please try again!");
                    $('#submit').removeAttr("disabled");
                }
            },
            "json"
        );
    return false;
}

successfulAlert = function(message) {
    var baseUrl = $("#base-url").attr("href");
    $('#alert_placeholder').html('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><span>' + message + '</span> <a href="'+baseUrl+'organization/create_quiz">Create another Quiz</a></div>')
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
                    select.append($("<option>").attr('value', 0).text('Please select a category'));
                    for (var i=0; i<category.length; i++){
                        select.append($("<option>").attr('value', category[i].Id).text(category[i].CategoryName));
                    }
                } else { // Fail
                    
                }
            },
            "json"
        );
}
