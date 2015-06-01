// global variable:
var approve = 0;
var partnerId = 0;

function getDonation(donationId) {
    //var baseUrl = window.location.protocol + "//" + window.location.host + "/";
    var baseUrl = $("#base-url").attr("href");
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "donation/getDonation",
            {
                id: donationId
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    
                    // Update the first form
                    partnerId = (data.info.donation.PartnerId);
                    $('#title').val(data.info.donation.Title);
                    $('#description').val(data.info.donation.Description);
                    
                    
                    $('#point').val(data.info.donation.RequiredPoint);
                    
                    if (data.info.donation.IsApproved == 1){
                        $('div#approve-donation').html('Yes');
                        approve = 1;
                    }
                } else { // Fail

                }
            },
            "json"
            );
}


function updateDonation(donationId){
    //var baseUrl = window.location.protocol + "//" + window.location.host + "/";
    var baseUrl = $("#base-url").attr("href");

    // Get the input data:
    var title = $("#title").val();
    var description = $("#description").val();
    var point= $("#point").val();
    
    // Make the spining when waiting
    
    // Post to api
    $.post(
            baseUrl + "donation/updateDonation",
            {
                id: donationId,
                partner_id: partnerId,
                title: title,
                description: description,
                approve: approve,
                point: point
            },
            function(data) {
                console.log(data);
                if (data.code == 1) { // Successful

                    //return false;
                    successfulAlert("Your donation has been updated");
                    $('html, body').animate({ scrollTop: 0 }, 'fast');
                    return false;
                } else { // Fail
                    bootstrap_alert.warning("Some error occurred, please try again!");
                }
            },
            "json"
        );
    return false;
}

function callDeleteAct(donationId){
    bootbox.confirm(
            "Are you sure you want to delete this Donation. The action cannot be undone!",
            function(result){
                if (result){
                    deleteDonation(donationId);
                }
            }
        );
}

function deleteDonation(donationId){
    var baseUrl = $("#base-url").attr("href");
    console.log("Deleting");
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "donation/deleteDonation",
            {
                id: donationId,
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    bootbox.alert("Delete successfuly! Come back to home page!", 
                        function(){
                            window.location.replace(baseUrl + "admin/index");
                        });
                } else { // Fail
                    bootbox.alert("Some error happened that we cannot delete. Please try again later.", 
                        function(){
                            
                        });
                }
            },
            "json"
            );
}

function approveDonation(donationId, state){
    var baseUrl = $("#base-url").attr("href");
    
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "donation/updateIsApproved",
            {
                id: donationId,
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


successfulAlert = function(message) {
    var baseUrl = $("#base-url").attr("href");
    $('#alert_placeholder').html('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><span>' + message + '</span> </div>')
}