function createDonation() {
    //var baseUrl = window.location.protocol + "//" + window.location.host + "/";
    var baseUrl = $("#base-url").attr("href");

    // Get the input data:
    var partner_id = $("#partner-id").val();
    var title = $("#title").val();
    var description = $("#description").val();
    
    // Make the spining when waiting
    // Disable submit button
    $('#submit').attr('disabled', 'true');
    
    // Post to api
    $.post(
            baseUrl + "donation/insertDonation",
            {
                partner_id: partner_id,
                title: title,
                description: description
            },
            function(data) {
                console.log(data);
                if (data.code == 1) { // Successful

                    // Store session

                    // Check the role and redirect

                    // Redirect to admin page
                    //return false;
                    successfulAlert("Your donation has been created successfully. ");
                    //window.location.replace(baseUrl + "organization/create_activity");
                    
                    // Reset the form
                    $('#submit').removeAttr("disabled");
                    $('#donation-form')[0].reset();
                    
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
    $('#alert_placeholder').html('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><span>' + message + '</span> <a href="'+baseUrl+'organization/create_donation">Create another Donation</a></div>')
}
