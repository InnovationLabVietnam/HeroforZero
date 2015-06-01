/**
 * This javascript file load the table of partners.
 */

/*
 * Partner Table
 */

var playersTable;

$(document).ready(function() {
    $('#players').html('<table cellpadding="0" cellspacing="0" border="0" class="display table table-striped table-bordered" id="players-table"></table>');
    playersTable = $('#players-table').dataTable({
        "aoColumns": [
            {"sTitle": "Player Name"},
            {"sTitle": "Point", "sClass": "center"},
            {"sTitle": "Action", "sClass": "center"}
        ],
        "sPaginationType": "bootstrap",
        "bSort": false
    });
    loadPlayersTable();
});

function loadPlayersTable() {
    var baseUrl = $("#base-url").attr("href");

    // Make the spining when waiting

    // Post to api
    $.post(
            baseUrl + "service/getLeaderBoard",
            {
                pageSize: 0,
                pageNumber: 0
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    var playersArray = data.leaderboard;
                    var tableData = new Array();
                    var player;
                    var action;
                    for (var i = 0; i < playersArray.length; i++) {
                        player = playersArray[i];
                        action = '<div style="float: center; font-size:11px"><a style="color: red;" onclick="callDelete('+player.id+')" href="javacript:void(0);">Reset Player</a></div>';
                        action = '<div style="float: left;"><a style="color: blue;" onclick="callReset('+player.id+')" href="javacript:void(0);">Reset Player</a></div>  <div style="float: right; font-size:11px"><a style="color: red;" onclick="callDelete('+player.id+')" href="javacript:void(0);">Delete</a></div>';
                        tableData.push([
                            '<strong>'+player.name+'</strong>',
                            player.mark,
                            action
                        ]);
                    }
                    playersTable.fnClearTable();
                    playersTable.fnAddData(tableData);
                } else { // Fail

                }
            },
            "json"
            );
}

function callReset(playerId) {
    bootbox.confirm(
            "Are you sure you want to reset this player. The action cannot be undone!",
            function(result) {
                if (result) {
                    resetPlayer(playerId);
                }
            }
    );
}

function callDelete(playerId) {
    bootbox.confirm(
            "Are you sure you want to DELETE this player. The action cannot be undone!",
            function(result) {
                if (result) {
                    deletePlayer(playerId);
                }
            }
    );
}

function resetPlayer(playerId) {
    var baseUrl = $("#base-url").attr("href");
    console.log("Reseting player");
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "service/resetPlayer",
            {
                id: playerId
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    // Reset table. Maybe by reloading, maybe just replace the Point by Zero.
                    loadPlayersTable();
                    
                } else { // Fail
                    bootbox.alert("Some error happened that we cannot reset the player. Please try again later.",
                            function() {

                            });
                }
            },
            "json"
            );
}

function deletePlayer(playerId) {
    var baseUrl = $("#base-url").attr("href");
    console.log("Deleting player");
    // Make the spining when waiting
    // Disable submit button

    // Post to api
    $.post(
            baseUrl + "service/deletePlayer",
            {
                id: playerId
            },
            function(data) {
                console.log(data);
                if (data.code === 1) { // Successful
                    // Reset table. Maybe by reloading, maybe just replace the Point by Zero.
                    loadPlayersTable();
                    
                } else { // Fail
                    bootbox.alert("Some error happened that we cannot delete the player. Please try again later.",
                            function() {

                            });
                }
            },
            "json"
            );
}