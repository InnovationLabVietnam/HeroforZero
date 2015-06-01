/**
 * This javascript file load the table of partners.
 */

/*
 * Partner Table
 */

var partnersTable;

$(document).ready(function() {
    $('#partners').html('<table cellpadding="0" cellspacing="0" border="0" class="display table table-striped table-bordered" id="partners-table"></table>');
    partnersTable = $('#partners-table').dataTable({
        "aoColumns": [
            {"sTitle": "Organization"},
            {"sTitle": "Description"},
            {"sTitle": "Approve?", "sClass": "center"},
            {"sTitle": "Action", "sClass": "center"}
        ],
        "sPaginationType": "bootstrap",
        "bSort": false
    });
    loadPartnersTable();
});

function loadPartnersTable() {
    var baseUrl = $("#base-url").attr("href");

    // Make the spining when waiting

    // Post to api
    $.post(
            baseUrl + "partner/getPartnerList",
            {
                pageSize: 0,
                pageNumber: 0
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    var partnersArray = data.info.partners;
                    var tableData = new Array();
                    var partner;
                    var isApproved;
                    var action;
                    for (var i = 0; i < partnersArray.length; i++) {
                        partner = partnersArray[i];
                        if (partner.IsApproved === '1') {
                            isApproved = "Yes";
                        } else {
                            isApproved = 'No';
                        }
                        
                        action = '<div style="float: left;"><a style="color: blue;" href="' + baseUrl + 'admin/partner/' + partner.Id + '">View</a></div>  <div style="float: right; font-size:11px"><a style="color: red;" onclick="callDelete('+partner.Id+')" href="javacript:void(0);">Delete</a></div>';
                        tableData.push([
                            '<strong>'+partner.PartnerName+'</strong>',
                            partner.Description,
                            isApproved,
                            action
                        ]);
                    }
                    partnersTable.fnClearTable();
                    partnersTable.fnAddData(tableData);
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
                partner_id: partnerId
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