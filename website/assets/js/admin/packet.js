$(function() {
    drawPacketTable();
    drawCategoryTable();
    drawAnimationTable();
});

function drawPacketTable() {
    var baseUrl = $("#base-url").attr("href");

    // Post to api
    $.post(
            baseUrl + "packet/getPacketList",
            {
                pageSize: 0,
                pageNumber: 0
            },
    function(data) {
        console.log(data);
        if (data.code == 1) { // Successful
            var packets = data.info.packet;
            var packetTable = $('#packet-table');
            for (var i = 0; i < packets.length; i++) {
                var row = $('<tr></tr>');
                var name = $('<td></td>').text(packets[i].Title);
                var background = '<img src="' + packets[i].ImageURL + '" alt="Your logo" width="139" height="29">';
                var action = '<td><a href="' + baseUrl + 'admin/edit_packet/' + packets[i].Id + '">Edit</a></td>';
                row.append(name).append(action);
                packetTable.append(row);
            }
        } else { // Fail

        }
    },
            "json"
            );
}

function drawCategoryTable() {
    var baseUrl = $("#base-url").attr("href");

    // Post to api
    $.post(
            baseUrl + "quizcategory/getQuizCategory",
            {
            },
    function(data) {
        console.log(data);
        if (data.code == 1) { // Successful
            var categorys = data.info.category;
            var cateTable = $('#category-table tbody');
            cateTable.empty();
            for (var i = 0; i < categorys.length; i++) {
                var row = $('<tr></tr>');
                var name = $('<td></td>').text(categorys[i].CategoryName);
                var numQuestion = $('<td></td>').text(categorys[i].quiz_count);
                var action = '<td><div style="float: left;"><a onclick="callEditCategory(' + categorys[i].Id + ')" href="javacript:void(0);">Change Name</a></div> '
                        +' <div style="float: right; font-size:11px"><a style="color: red;" onclick="callDeleteCategory(' + categorys[i].Id + ')" href="javacript:void(0);">Delete</a></div></td>';
                row.append(name).append(numQuestion).append(action);
                cateTable.append(row);
            }

        } else { // Fail

        }
    },
            "json"
            );
}

function drawAnimationTable() {
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
            var animationTable = $('#animation-table tbody');
            animationTable.empty();
            for (var i = 0; i < animations.length; i++) {
                var row = $('<tr></tr>');
                var id = $('<td></td>').text(animations[i].Id);
                var time = $('<td></td>').text(animations[i].time);
                var walking = $('<td></td>').text(animations[i].HeroAnimWalking);
                var standby = $('<td></td>').text(animations[i].HeroAnimStandby);
                var monster = $('<td></td>').text(animations[i].MonsterAnim);
                var kid = $('<td></td>').text(animations[i].KidFrame);

                var color = '<td style="background-color:rgb(' + animations[i].ColorR + ',' + animations[i].ColorG + ',' + animations[i].ColorB + ')"></td>';
                var background = '<td><img src="' + animations[i].ScreenShotURL + '" alt="Screenshot" width="139" height="40"></td>';

                var action = '<td><div style="float: left;"><a href="' + baseUrl + 'admin/edit_animation/' + animations[i].Id + '">View</a></div>  <div style="float: right; font-size:11px"><a style="color: red;" onclick="callDeleteAnimation(' + animations[i].Id + ')" href="javacript:void(0);">Delete</a></div></td>';

                row.append(id).append(time).append(walking).append(standby).append(monster).append(kid).append(color).append(background).append(action);
                //animationTable.append(row);
                
                animationTable.append(row);
            }
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
    $('form').on('submit', createPacket);

    // Grab the files and set them to our variable
    function prepareUpload(event) {
        files = event.target.files;
    }

    function uploadFiles(event) {
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
            url: baseUrl + "process/upload_s3",
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
                    createPacket(event, data);
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

});

function createPacket(event) {
    var baseUrl = $("#base-url").attr("href");
    var title = $('#packet').val();

    // Post to api
    $.post(
            baseUrl + "packet/insertPacket",
            {
                title: title,
                image_url: "",
                partner_id: 1
            },
    function(data) {
        console.log(data);
        if (data.code == 1) { // Successful

            // Draw that new row in table
            var packetTable = $('#packet-table');
            var row = $('<tr></tr>');
            var name = $('<td></td>').text(title);
            var background = $('<td></td>').text("Image");
            var action = '<td><a href="' + baseUrl + 'admin/edit_packet/">Edit</a></td>';
            row.append(name).append(background);
            packetTable.append(row);

            // Clear the input
            $('#packet').val("");
            // TODO : clear file also.
        } else { // Fail

        }
    },
            "json"
            );
}

function createCategory() {
    var baseUrl = $("#base-url").attr("href");
    var category = $('#category').val();
    // Post to api
    $.post(
            baseUrl + "quizcategory/insertQuizCategory",
            {
                category_name: category
            },
    function(data) {
        console.log(data);
        if (data.code == 1) { // Successful

            // Draw that new row in table
            /*
             var categoryTable = $('#category-table');
             var row = $('<tr></tr>');
             var name = $('<td></td>').text(category);
             var background = $('<td></td>').text('');
             row.append(name).append(background);
             categoryTable.append(row);
             */

            // Remove old table
            //$('#category-table tbody').remove();

            // Draw new table
            drawCategoryTable();

            // Clear the input
            $('#category').val("");
        } else { // Fail

        }
    },
            "json"
            );
}

function callDeleteAnimation(animationId){
    bootbox.confirm(
            "Are you sure you want to DELETE this Animation. The action cannot be undone!",
            function(result){
                if (result){
                    deleteAnimation(animationId);
                }
            }
        );
}

function deleteAnimation(animationId){
    var baseUrl = $("#base-url").attr("href");
    console.log("Deleting");
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "animation/delete",
            {
                id: animationId
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    
                    drawAnimationTable();
                } else { // Fail
                    bootbox.alert("Some error happened that we cannot delete. Please try again later.", 
                        function(){
                            
                        });
                }
            },
            "json"
            );
}

function callDeleteCategory(categoryId){
    bootbox.confirm(
            "Are you sure you want to DELETE this category. The action cannot be undone!",
            function(result){
                if (result){
                    deleteCategory(categoryId);
                }
            }
        );
}

function deleteCategory(categoryId){
    var baseUrl = $("#base-url").attr("href");
    console.log("Deleting");
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "quizcategory/deleteQuizCategory",
            {
                id: categoryId
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    
                    drawCategoryTable();
                } else { // Fail
                    bootbox.alert("Some error happened that we cannot delete. Please try again later.", 
                        function(){
                            
                        });
                }
            },
            "json"
            );
}

function callEditCategory(categoryId){
    bootbox.prompt("New name of the category: ", function(result){
        if (!result){
            // Do nothing
        } else {
            // Change it.
            editCategory(categoryId, result);
        }
    });
}

function editCategory(categoryId, category){
    var baseUrl = $("#base-url").attr("href");
    // Make the spining when waiting

    // Post to api
    $.post(
            baseUrl + "quizcategory/updateQuizCategory",
            {
                id: categoryId,
                category_name: category
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    drawCategoryTable();
                } else { // Fail
                    bootbox.alert("Some error happened. Please try again later.", 
                        function(){
                            
                        });
                }
            },
            "json"
            );
}