// Variable to store your files
var files;
var colorPicker;

$(function() {
    
    var animationId = $('#animation-id').val();
    if (animationId != 0){
        getAnimation(animationId);
    }
    
    colorPicker = $('.color-picker').colorpicker({
            format: "rgb"
    });

    // Add events
    $('input[type=file]').on('change', prepareUpload);
    $('form').on('submit', submitAnimation);

    // Grab the files and set them to our variable
    function prepareUpload(event) {
        files = event.target.files;
    }
    
    function submitAnimation(event){
        if (files && files.length){
            // File attacked
            uploadFiles(event)
        } else {
            // Not file choosen. Just submit bare animation.
            createAnimation("");
        }
    }

});


/*
 * Upload file, then, if successfull will automatically call create Animation function.
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
                createAnimation(fileUrl);
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

function createAnimation(imageUrl) {
    var baseUrl = $("#base-url").attr("href");

    // Get the input data:
    console.log($('#color').val());
    var colors = $('#color').val().match(/(\d+),(\d+),(\d+)/)
    console.log(colors);
    console.log(Number(colors[1]));
    // Make the spining when waiting
    // Disable submit button
    $('#submit').attr('disabled', 'true');
    
    var animationId = parseInt($('#animation-id').val());
    var serviceUrl;
    if (animationId !== 0){
        // Edit 
        serviceUrl = baseUrl + "animation/editAnimation";
    } else {
        // Create new animation
        serviceUrl = baseUrl + "animation/createAnimation";
    }
    
    // Post to api
    $.post(
            serviceUrl,
            {
                id : animationId,
                time: $("#time").val(),
                walking: $("#walking").val(),
                standby: $("#standby").val(),
                monster: $("#monster").val(),
                kid: $("#kid").val(),
                color_red: Number(colors[1]),
                color_green: Number(colors[2]),
                color_blue: Number(colors[3]),
                screenshot_url: imageUrl
            },
            function(data) {
                console.log(data);
                if (data.code == 1) { // Successful

                    // Store session

                    // Check the role and redirect

                    // Redirect to admin page
                    //return false;
                    successfulAlert("Your Animation has been created successfully. ");
                    //window.location.replace(baseUrl + "organization/create_activity");
                    
                    
                    // Reset the form
                    $('#submit').removeAttr("disabled");
                    //$('#animation-form')[0].reset();
                    
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

function getAnimation(animationId) {
    var baseUrl = $("#base-url").attr("href");
    // Make the spining when waiting

    // Post to api
    $.post(
            baseUrl + "animation/getAnimation",
            {
                id: animationId
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    var animation = data.info.animation;
                    $('#time').val(animation.time);
                    $('#walking').val(animation.HeroAnimWalking);
                    $('#standby').val(animation.HeroAnimStandby);
                    $('#monster').val(animation.MonsterAnim);
                    $('#kid').val(animation.KidFrame);
                    $('#color').val('rgb('+animation.ColorR+','+animation.ColorG+','+animation.ColorB+')');
                    
                    // Screenshot
                    $('#screenshot').attr('src', animation.ScreenShotURL);
                    
                } else { // Fail
                    bootstrap_alert.warning("Some error occurred, please try again!");
                    $('#submit').attr('disabled', 'disabled');
                }
            },
            "json"
            ).fail(function() {
                bootstrap_alert.warning("Some error occurred, please try again!");
            $('#submit').attr('disabled', 'disabled');
          });
}

successfulAlert = function(message) {
    var baseUrl = $("#base-url").attr("href");
    $('#alert_placeholder').html('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><span>' + message + '</span> </div>')
}
