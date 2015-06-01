/**
 * This file load information of one partner
 */
var email;

function getPartner(partnerId) {
    //var baseUrl = window.location.protocol + "//" + window.location.host + "/";
    var baseUrl = $("#base-url").attr("href");
    // Make the spining when waiting
    // Disable submit button

    var partnerInfo ='';
    // Post to api
    $.post(
            baseUrl + "partner/getPartner",
            {
                id: partnerId
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    partnerInfo += '<table class="table table-striped table-bordered table-hover">';
                    partnerInfo += '<tr><td>Organizations name </td><td>'+data.info.partner.PartnerName+'</td></tr>';
                    partnerInfo += '<tr><td>Login id </td><td>'+data.info.partner.UserName+'</td></tr>';
                    partnerInfo += '<tr><td>Address </td><td>'+data.info.partner.Address+'</td></tr>';
                    partnerInfo += '<tr><td>Phone Number </td><td>'+data.info.partner.PhoneNumber+'</td></tr>';
                    partnerInfo += '<tr><td>Email </td><td>'+data.info.partner.Email+'</td></tr>';
                    partnerInfo += '<tr><td>Website </td><td>'+data.info.partner.WebsiteURL+'</td></tr>';
                    partnerInfo += '<tr><td>Description </td><td>'+data.info.partner.Description+'</td></tr>';
                    partnerInfo += '<tr><td>Is Approved? </td><td>';
                    partnerInfo += data.info.partner.IsApproved === '1' ? 'Yes': 'No'+'</td></tr>';
                    partnerInfo += '</table>';
                    $('#partner-info').html(partnerInfo);
                    
                    email = data.info.partner.Email;
                } else { // Fail

                }
            },
            "json"
            );
}

function callDelete(partnerId) {
    bootbox.confirm(
            "Are you sure you want to delete this partner. The action cannot be undone!",
            function(result) {
                if (result) {
                    deletePartner(partnerId);
                }
            }
    );
}

function deletePartner(partnerId) {
    var baseUrl = $("#base-url").attr("href");
    console.log("Deleting");
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "partner/deletePartner",
            {
                id: partnerId
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    loadPartnersTable();
                } else { // Fail
                    bootbox.alert("Some error happened that we cannot delete the partner. Please try again later.",
                            function() {

                            });
                }
            },
            "json"
            );
}

function approvePartner(partnerId, state){
    var baseUrl = $("#base-url").attr("href");
    
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "partner/updateIsApproved",
            {
                id: partnerId,
                is_approved: state
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    successfulAlert('Approve successfully!');
                } else { // Fail

                }
            },
            "json"
            );
    
    // Send mail confirm
    /* But not in use yet.
    $.post(
            baseUrl + "user/sendApproveMail",
            {
                email: email,
                is_approved: state
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    
                } else { // Fail

                }
            },
            "json"
            );
    */
}


successfulAlert = function(message) {
    var baseUrl = $("#base-url").attr("href");
    $('#alert_placeholder').html('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><span>' + message + '</span> </div>')
}