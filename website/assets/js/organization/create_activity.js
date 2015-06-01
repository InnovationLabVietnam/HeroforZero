function createActivity() {
    //var baseUrl = window.location.protocol + "//" + window.location.host + "/";
    var baseUrl = $("#base-url").attr("href");

    // Get the input data:
    var partner_id = $("#partner-id").val();
    var title = $("#title").val();
    var description = $("#description").val();
    var actionId = parseInt($("input[name='action']:checked", '#activity-form').val());
    var actionContent='';
    switch (parseInt(actionId)){
        case 1:
            actionContent = $('#facebook_share').val();
            // Check if content is not empty:
            if (!actionContent || actionContent.length === 0){
                $('#facebook_share').focus();
                $('#facebook_share').attr("placeholder", "Please enter this field");
                $('#newsletter_link').attr("placeholder", "");
                $('#facebook_page').attr("placeholder", "");
                $('#calendar').attr("placeholder", "");
                return false;
            }
            break;
        case 2:
            actionContent = $('#newsletter_link').val();
            // Check if content is not empty:
            if (!actionContent || actionContent.length === 0){
                $('#newsletter_link').focus();
                $('#facebook_share').attr("placeholder", "");
                $('#newsletter_link').attr("placeholder", "Please enter this field");
                $('#facebook_page').attr("placeholder", "");
                $('#calendar').attr("placeholder", "");
                return false;
            }
            break;
        case 3:
            actionContent = $('#facebook_page').val();
            // Check if content is not empty:
            if (!actionContent || actionContent.length === 0){
                $('#facebook_page').focus();
                $('#facebook_share').attr("placeholder", "");
                $('#newsletter_link').attr("placeholder", "");
                $('#facebook_page').attr("placeholder", "Please enter this field");
                $('#calendar').attr("placeholder", "");
                return false;
            }
            break;
        case 4:
            actionContent = $('#calendar').val();
            // Check if content is not empty:
            if (!actionContent || actionContent.length === 0){
                $('#calendar').focus();
                $('#facebook_share').attr("placeholder", "");
                $('#newsletter_link').attr("placeholder", "");
                $('#facebook_page').attr("placeholder", "");
                $('#calendar').attr("placeholder", "Please enter this field");
                return false;
            }
            break;
        default:
            actionContent = $('#facebook_share').val();
            // Check if content is not empty:
            if (!actionContent || actionContent.length === 0){
                $('#facebook_share').focus();
                $('#facebook_share').attr("placeholder", "Please enter this field");
                $('#newsletter_link').attr("placeholder", "");
                $('#facebook_page').attr("placeholder", "");
                $('#calendar').attr("placeholder", "");
                return false;
            }
    }
    
    // Make the spining when waiting
    // Disable submit button
    $('#submit').attr('disabled', 'true');
    
    // Post to api
    $.post(
            baseUrl + "activity/insertActivity",
            {
                partner_id: partner_id,
                title: title,
                description: description,
                action_id: actionId,
                action_content: actionContent
            },
            function(data) {
                console.log(data);
                if (data.code == 1) { // Successful

                    // Store session

                    // Check the role and redirect

                    // Redirect to admin page
                    //return false;
                    successfulAlert("Your activity has been created successfully. ");
                    //window.location.replace(baseUrl + "organization/create_activity");
                    
                    // Reset the form
                    $('#submit').removeAttr("disabled");
                    $('#activity-form')[0].reset();
                    
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
    $('#alert_placeholder').html('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><span>' + message + '</span> <a href="'+baseUrl+'organization/create_activity">Create another Activity</a></div>')
}

$(function () {
    $('#datetimepicker').datetimepicker({
        icons: {
            time: "fa fa-clock-o",
            date: "fa fa-calendar",
            up: "fa fa-arrow-up",
            down: "fa fa-arrow-down"
        },
        pickTime: false,
        useStrict: true,
    });
});
