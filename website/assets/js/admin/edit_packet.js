function getPacket(packetId) {
    //var baseUrl = window.location.protocol + "//" + window.location.host + "/";
    var baseUrl = $("#base-url").attr("href");
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "packet/getPacket",
            {
                id: packetId
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    
                    // Update the first form
                    $('#packet').val(data.info.packet.Title);
                } else { // Fail

                }
            },
            "json"
            );
}

$(function() {
    // Variable to store your files
    var files;
    var baseUrl = $("#base-url").attr("href");

    // Add events
    $('input[type=file]').on('change', prepareUpload);
    $('form').on('submit', uploadFiles);

    // Grab the files and set them to our variable
    function prepareUpload(event) {
        files = event.target.files;
    }
    
    function uploadFiles(event){
        // Stop stuff happening.
        event.stopPropagation();
        event.preventDefault();
        // Set waiting state to button.
        var button = $('#submit');
        button.button('loading');
        // START A LOADING SPINNER HERE
        
    if($("#userfile").val() == ''){
        // Call function to create packet.
        updatePacket(event, null);
        return;
    }
        // Create a formdata object and add the files.
        var data = new FormData();
        $.each(files, function(key, value){
            data.append('userfile', value);
        });
        
        $.ajax({
            url: baseUrl + "process/upload_s3",
            type: 'POST',
            data: data,
            cache: false,
            dataType: 'json',
            processData: false, // Do not process the file.
            contentType: false, // Set content type to false as jQuery will tell the server its a query string request
            success: function(data){
                if (data.code === 1){
                    // SUCCESS.
                    // Call function to create packet.
                    updatePacket(event, data);
                } else {
                    // Error
                    console.log('ERRORS: '+ data.error);
                }
            },
            error: function(jqXHR, textStatus, errorThrown){
                console.log("ERRORS: " + textStatus);
                
                // STOP LOADING SPINNER
            }
        });
    }
});

function updatePacket(event, data){
    var baseUrl = $("#base-url").attr("href");
    var title = $('#packet').val();
    var packet_id = $('#packet_id').val();
    if (data !== null){
        var image_url = data.info.file_name;
    } else {
        var image_url = null;
    }
    var button = $('#submit');
    
    // Post to api
    $.post(
            baseUrl + "packet/updatePacket",
            {
                id: packet_id,
                title: title,
                image_url:image_url,
                partner_id:1
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    
                    window.location.replace(baseUrl + "admin/packet");
                    
                    button.button('reset');
                } else { // Fail
                    button.button('reset');
                }
            },
            "json"
        );
}