$(document).ready(function(){
    drawSelectPacket();
    drawSelectCategory();
    drawSelectActivity();
    drawSelectDonation();
    drawSelectAnimation();
    
    // Bind to function
    $('form').on('submit', createQuest);
    
    // Image picker init.
    
    $('#character').imagepicker({
        hide_select: false
    });
    
    // Masonry image control init.
    // Try Masonry but not successful. :)
//    var $container = $('.image_picker_selector');
//    $container.imagesLoaded(function(){
//        $container.masonry({
//            // option
//            columnWidth: 50,
//            itemSelector: '.thumbnail'
//        });
});

function drawSelectPacket(){
    var baseUrl = $("#base-url").attr("href");
    // Post to api
    $.post(
            baseUrl + "packet/getPacketAvailalbeList",
            {
                pageSize: 0,
                pageNumber: 0
            },
            function(data) {
                console.log(data);
                if (data.code == 1) { // Successful
                    var packets = data.info.packet;
                    var select = $('#packet');
                    for (var i=0; i<packets.length; i++){
                        select.append($("<option>").attr('value', packets[i].Id).text(packets[i].Title));
                    }
                } else { // Fail
                    
                }
            },
            "json"
        );
}

function drawSelectAnimation() {
    var baseUrl = $("#base-url").attr("href");

    // Post to api
    $.post(
            baseUrl + "animation/getAnimation",
            {
                page_size: 0,
                page_number: 0
            },
    function(data) {
        console.log(data);
        if (data.code == 1) { // Successful
            var animations = data.info.animation;
                    var select = $('<select id="animation" name="animation" class="form-control image-picker">').appendTo('#select-animation');
                    for (var i=0; i<animations.length; i++){
                        select.append($("<option>").attr('value',animations[i].Id)
                                .attr('data-img-src', animations[i].ScreenShotURL)
                                .text('Animation '+animations[i].Id));
                    }
                    
                    // Image Picker Init
                    $('#animation').imagepicker({
        hide_select: false
    });
        } else { // Fail

        }
    },
            "json"
            );
}

function drawSelectActivity(){
    var baseUrl = $("#base-url").attr("href");
    
    // Post to api
    $.post(
            baseUrl + "activity/getActivityList",
            {
                pageSize: 0,
                pageNumber: 0
            },
            function(data) {
                console.log(data);
                if (data.code == 1) { // Successful
                    var activity = data.info.activity;
                    var select1 = $('<select id="activity_1" name="activity_1" class="form-control">').appendTo('#select-activity-1');
                    var select2 = $('<select id="activity_2" name="activity_2" class="form-control">').appendTo('#select-activity-2');
                    var select3 = $('<select id="activity_3" name="activity_3" class="form-control">').appendTo('#select-activity-3');
                    select1.append($("<option>").attr('value', 0).text('Select the Activity'));
                    select2.append($("<option>").attr('value', 0).text('Select the Activity'));
                    select3.append($("<option>").attr('value', 0).text('Select the Activity'));
                    var partner = '';
                    var optGroup;
                    for (var i=0; i<activity.length; i++){
                        if (i !== 0 && partner !== activity[i].PartnerName){
                            select1.append(optGroup);
                            var optGroup2 = optGroup.clone();
                            select2.append(optGroup2);
                            var optGroup3 = optGroup.clone();
                            select3.append(optGroup3);
                        }
                        if (partner !== activity[i].PartnerName){
                            // A new group
                            optGroup = $('<optgroup>');
                            partner = activity[i].PartnerName;
                            optGroup.attr('label', partner);
                        }
                        optGroup.append($("<option>").attr('value', activity[i].Id).text(activity[i].Title));
                        
                        if ((i === activity.length-1)){
                            // End of a group.
                            select1.append(optGroup);
                            var optGroup2 = optGroup.clone();
                            select2.append(optGroup2);
                            var optGroup3 = optGroup.clone();
                            select3.append(optGroup3);
                        }
                        
//                        select1.append($("<option>").attr('value', activity[i].Id).text(activity[i].Title));
//                        select2.append($("<option>").attr('value', activity[i].Id).text(activity[i].Title));
//                        select3.append($("<option>").attr('value', activity[i].Id).text(activity[i].Title));
                    }
                } else { // Fail
                    
                }
            },
            "json"
        );
}

function drawSelectDonation(){
    var baseUrl = $("#base-url").attr("href");
    
    // Post to api
    $.post(
            baseUrl + "donation/getDonationList",
            {
                pageSize: 0,
                pageNumber: 0
            },
            function(data) {
                console.log(data);
                if (data.code == 1) { // Successful
                    var donation = data.info.donation;
                    var select1 = $('<select id="donation_1" name="donation_1" class="form-control">').appendTo('#select-donation-1');
                    var select2 = $('<select id="donation_2" name="donation_2" class="form-control">').appendTo('#select-donation-2');
                    var select3 = $('<select id="donation_3" name="donation_3" class="form-control">').appendTo('#select-donation-3');
                    select1.append($("<option>").attr('value', 0).text('Select the Donation'));
                    select2.append($("<option>").attr('value', 0).text('Select the Donation'));
                    select3.append($("<option>").attr('value', 0).text('Select the Donation'));
                    
                    var partner = '';
                    var optGroup;
                    for (var i=0; i<donation.length; i++){
                        if (i !== 0 && partner !== donation[i].PartnerName){
                            select1.append(optGroup);
                            var optGroup2 = optGroup.clone();
                            select2.append(optGroup2);
                            var optGroup3 = optGroup.clone();
                            select3.append(optGroup3);
                        }
                        if (partner !== donation[i].PartnerName){
                            // A new group
                            optGroup = $('<optgroup>');
                            partner = donation[i].PartnerName;
                            optGroup.attr('label', partner);
                        }
                        optGroup.append($("<option>").attr('value', donation[i].Id).text(donation[i].Title));
                        
                        if ((i === donation.length-1)){
                            // End of a group.
                            select1.append(optGroup);
                            var optGroup2 = optGroup.clone();
                            select2.append(optGroup2);
                            var optGroup3 = optGroup.clone();
                            select3.append(optGroup3);
                        }
                        
                        
//                        select1.append($("<option>").attr('value', donation[i].Id).text(donation[i].Title));
//                        select2.append($("<option>").attr('value', donation[i].Id).text(donation[i].Title));
//                        select3.append($("<option>").attr('value', donation[i].Id).text(donation[i].Title));
                    }
                } else { // Fail
                    
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

function createQuest() {
    var baseUrl = $("#base-url").attr("href");

    // Get the input data:
    var partner_id = $("#partner-id").val();
    var packet_id = $("#packet").val();
    var name = $("#name").val();
    var unlock = $("#unlock").val();
    var point = $("#point").val();
    var quiz_category = $("#category").val();
    var activity_id_1 = $("#activity_1").val();
    var activity_id_2 = $("#activity_2").val();
    var activity_id_3 = $("#activity_3").val();
    var donation_id_1 = $("#donation_1").val();
    var donation_id_2 = $("#donation_2").val();
    var donation_id_3 = $("#donation_3").val();
    
    var animation_id = $('#animation').val();
    var character_url = $('#character').val();
    
    // Make the spining when waiting
    // Disable submit button
    $('#submit').attr('disabled', 'true');
    
    // Post to api
    $.post(
            baseUrl + "virtualquest/insertVirtualQuest",
            {
                partner_id: partner_id,
                packet_id: packet_id,
                name: name,
                unlock: unlock,
                point: point,
                quiz_category: quiz_category,
                activity_id_1: activity_id_1,
                activity_id_2: activity_id_2,
                activity_id_3: activity_id_3,
                donation_id_1: donation_id_1,
                donation_id_2: donation_id_2,
                donation_id_3: donation_id_3,
                
                animation_id: animation_id,
                image_url: character_url
            },
            function(data) {
                console.log(data);
                if (data.code == 1) { // Successful

                    // Store session

                    // Check the role and redirect

                    // Redirect to admin page
                    //return false;
                    successfulAlert("Your Quest has been created successfully. Do you want to ");
                    //window.location.replace(baseUrl + "organization/create_activity");
                    
                    $('#quest-form')[0].reset();
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
    $('#alert_placeholder').html('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><span>' + message + '</span> <a href="'+baseUrl+'admin/create_quest">Create another Quest</a></div>')
}
