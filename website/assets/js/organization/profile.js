// Variable to store your files
var files;
var logoUrl;
var iconUrl;

var logoFile;
var iconFile;

$(function() {
    
    getProfile();
    
    // Add events
    $('input[type=file]').on('change', prepareUpload);
    
    $('form').on('submit', submitProfile);

    // Grab the files and set them to our variable
    function prepareUpload(event) {
        files = event.target.files;
    }
    
    function submitProfile(event){
        if (files && files.length){
            // File attached
            uploadFiles(event);
        } else {
            // Not file choosen. Just submit bare quiz.
            updateProfile();
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
    var logoFile = new FormData();
    var iconFile = new FormData();
    logoFile.append('userfile', $('#logo_image')[0].files[0]);
    iconFile.append('userfile', $('#icon_image')[0].files[0]);
//    $.each(files, function(key, value) {
//        //data.append('userfile', value);
//        data.append('userfile', $('#logo_image')[0].files[0]);
//    });

    uploadLogo();
}

function uploadLogo(){
    var baseUrl = $("#base-url").attr("href");

    // START A LOADING SPINNER HERE

    // Create a formdata object and add the files.
    var logoFile = new FormData();
    logoFile.append('userfile', $('#logo_image')[0].files[0]);
//    $.each(files, function(key, value) {
//        //data.append('userfile', value);
//        data.append('userfile', $('#logo_image')[0].files[0]);
//    });
    $.ajax({
        url: baseUrl + "process/upload",
        type: 'POST',
        data: logoFile,
        cache: false,
        dataType: 'json',
        processData: false, // Do not process the file.
        contentType: false, // Set content type to false as jQuery will tell the server its a query string request
        success: function(data) {
            if (data.code === 1) {
                // SUCCESS.
                // Call function to create packet.
                var fileUrl = data.info.file_name;
                logoUrl = fileUrl;
            } else {
                // Error
                //console.log('ERRORS: ' + data.error);
            }
            uploadIcon();
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.log("ERRORS: " + textStatus);

            // STOP LOADING SPINNER
        }
    });
}
function uploadIcon(){
    var baseUrl = $("#base-url").attr("href");

    // START A LOADING SPINNER HERE

    // Create a formdata object and add the files.
    var iconFile = new FormData();
    iconFile.append('userfile', $('#icon_image')[0].files[0]);
//    $.each(files, function(key, value) {
//        //data.append('userfile', value);
//        data.append('userfile', $('#logo_image')[0].files[0]);
//    });
    $.ajax({
        url: baseUrl + "process/upload",
        type: 'POST',
        data: iconFile,
        cache: false,
        dataType: 'json',
        processData: false, // Do not process the file.
        contentType: false, // Set content type to false as jQuery will tell the server its a query string request
        success: function(data) {
            if (data.code === 1) {
                // SUCCESS.
                // Call function to create packet.
                iconUrl = data.info.file_name;
            } else {
                // Error
                //console.log('ERRORS: ' + data.error);
            }
            updateProfile();
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.log("ERRORS: " + textStatus);

            // STOP LOADING SPINNER
        }
    });
}

function updateProfile() {
    //var baseUrl = window.location.protocol + "//" + window.location.host + "/";
    var baseUrl = $("#base-url").attr("href");
    
    // Get the input data:
    // TODO : partner ID
    var partner_id = $("#partner-id").val();
    var name = $("#name").val();
    var logo_image = logoUrl;
    var icon_image = iconUrl;
    var admin_name = $("#admin_name").val();
    var email = $("#email").val();
    var address = $("#address").val();
    var phone = $('#phone').val();
    var website = $("#website").val();
    var type = $("#type").val();
    var description = $("#description").val();
    
    var fanpage = $("#fanpage").val();
    var message = $("#donation_message").val();
    var link = $("#donation_web").val();
    var paypal = $("#donation_paypal").val();
    var donation_address = $("#donation_address").val();
    
    // Make the spining when waiting
    // Disable submit button
    $('#submit').attr('disabled', 'true');
    
    // Post to api
    $.post(
            baseUrl + "partner/updatepartner",
            {
                partner_id: partner_id,
                name: name,
                logo_image: logo_image,
                icon_image: icon_image,
                admin_name: admin_name,
                email: email,
                address: address,
                phone: phone,
                website: website,
                type: type,
                description: description
            },
            function(data) {
                console.log(data);
                if (data.code == 1) { // Successful

                    // Store session

                    // Check the role and redirect

                    // Redirect to admin page
                    //return false;
                    successfulAlert("Your Profile has been updated successfully. ");
                    //window.location.replace(baseUrl + "organization/create_activity");
                    
                    
                    // Reset the form
                    $('#submit').removeAttr("disabled");
                    $('html, body').animate({ scrollTop: 0 }, 'fast');
                    return false;
                } else { // Fail
                    bootstrap_alert.warning("Some error occurred, please try again!");
                    $('#submit').removeAttr("disabled");
                }
            },
            "json"
        );
        
    // Post to api
    $.post(
            baseUrl + "partner/updatepartnerext",
            {
                partner_id: partner_id,
                fanpage: fanpage,
                donation_message: message,
                donation_link: link,
                donation_paypal: paypal,
                donation_address: donation_address
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
    $('#alert_placeholder').html('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><span>' + message + '</span></div>')
}

function getProfile(){
    var baseUrl = $("#base-url").attr("href");
    
    var partnerId = $('#partner-id').val();
    
    // Post to api
    $.post(
            baseUrl + "partner/getpartner",
            {
                id: partnerId
            },
            function(data) {
                console.log(data);
                if (data.code == 1) { // Successful
                    var partner = data.info.partner;
                    
                    $('#username').text(partner.UserName);
                    $('#name').val(partner.PartnerName);
                    $('#logo_image_set').attr('src', partner.LogoURL);
                    logoUrl = partner.LogoURL;
                    $('#icon_image_set').attr('src', partner.IconURL);
                    iconUrl = partner.IconURL;
                    $('#admin_name').val(partner.AdminName);
                    $('#email').val(partner.Email);
                    $('#address').val(partner.Address);
                    $('#phone').val(partner.phone);
                    $('#website').val(partner.WebsiteURL);
                    $('#type').val(partner.OrganizationTypeId);
                    $('#description').val(partner.Description);
                } else { // Fail
                    
                }
            },
            "json"
        );
    
    // Post to api
    $.post(
            baseUrl + "partner/getpartnerext",
            {
                partner_id: partnerId
            },
            function(data) {
                console.log(data);
                if (data.code == 1) { // Successful
                    var partner = data.info.partner_ext;
                    
                    $('#fanpage').val(partner.fanpage);
                    $('#donation_message').val(partner.donation_message);
                    $('#donation_web').val(partner.donation_link);
                    $('#donation_paypal').val(partner.donation_paypal);
                    $('#donation_address').val(partner.donation_address);
                } else { // Fail
                    
                }
            },
            "json"
        );
}
