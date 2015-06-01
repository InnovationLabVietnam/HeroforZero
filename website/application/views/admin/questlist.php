<div id="wrapper">
    <div id="page-wrapper">
        <div class="row">
            <div class="page-header">
                <h1>Quests List</h1>
            </div>
            <div class="col-md-8">
                <div id="quest-list">

                </div>
            </div>
        </div>
        <table class="table center">
            <tr>
                <td>
                    <div id="pages"></div>
                </td>
            </tr>
        </table>
    </div>
</div>
<script>
    $(document).ready(function() {
        event.preventDefault();
        // Load the quest list count:
        var pageSize = 5;
        $.ajax({
            type: "POST",
            url: "<?php echo base_url() ?>quest/questCountbyUser",
            data: {
                userId: 0,
            },
            dataType: 'json',
            success: function(data) {
                console.log(data);
                if (data.code === 1) {
                    // load successfully
                    var pages = Math.ceil(data.info / pageSize);
                    console.log(pages);
                    if (pages > 1) {
                        // Pagination with : http://flaviusmatis.github.io/simplePagination.js/ glyphicon glyphicon-refresh
                        $("#pages").pagination({
                            pages: pages,
                            cssStyle: 'light-theme',
                            onPageClick: function(pageNumber, event) {
                                $("#quest-list").prepend('<div class="loading-indication"><span class="glyphicon glyphicon-refresh"></span> Loading...</div>');
                                loadQuestList(pageNumber - 1, pageSize);
                            }
                        });
                    }
                    loadQuestList(0, pageSize);

                } else {
                    // error
                }
            }
        });
    });

    function loadQuestList(currentPage, pageSize) {
        $.ajax({
            type: "POST",
            url: "<?php echo base_url() ?>quest/questListInfobyUser",
            data: {
                currentPage: currentPage,
                pageSize: pageSize,
                userId: 0,
            },
            dataType: 'json',
            success: function(data) {
                console.log(data);
                if (data.code === 1) {
                    // load successfully
                    var customerList = "";
                    customerList += "<table class=\"table\"><th></th><th></th><th class=\"center\">State</th>";
                    for (var i in data.info) {
                        customerList += "<tr>";
                        customerList += "<td><a onmouseover=\"nhpup.popup($('#hidden-div" + i + "').html(), {'width': 300});\" href=\"";
                        customerList += "<?php echo base_url() ?>" + "quest/detail/" + data.info[i].id;
                        customerList += "\">";
                        customerList += data.info[i].name;
                        customerList += "</a>";
                        customerList += "<div class=\"hidden-div\" id=\"hidden-div" + i + "\" >  <table class=\"table no-borders\" border=\"0\" width=\"300\"> <tr> <td>";
                        customerList += "<img class=\"img-responsive\" src=\"" + data.info[i].image_url + "\"></img>";
                        customerList += "" + data.info[i].description + "";
                        customerList += "</td></tr></table></div>";
                        customerList += "</td>";

                        customerList += "<td><a href=\"";
                        customerList += "<?php echo base_url() ?>" + "quest/edit/" + data.info[i].id;
                        customerList += "\">Edit</a>";
                        customerList += "</td>";

                        customerList += "<td class=\"center\">";
                        customerList += "<form name=\"active\">";
                        if (data.info[i].state == 0) {
                            customerList += "<INPUT TYPE=\"checkbox\" NAME=\"tick\" onClick=\"return activate(" + data.info[i].id + ", checked)\">";
                            // ["+data.info[i].id+"]
                        } else {
                            customerList += "<INPUT TYPE=\"checkbox\" NAME=\"tick\" onClick=\"return activate(" + data.info[i].id + ", checked)\" checked=\"true\">";
                        }
                        customerList += "</td>";
                        customerList += "</tr>";
                    }
                    document.getElementById("quest-list").innerHTML = customerList;
                } else {
                    // error
                }
            }
        });
    }

    function activate(questId, checked) {
        if (checked) {
            if (confirm("Are you sure you want to activate this Quest?")) {
                // User confirm to activate the quest.
                activateQuest(questId, 1);
            } else {
                // TODO : uncheck the box if user cancel
            }
        } else {
            if (confirm("Are you sure you want to deactivate this Quest?")) {
                // User confirm to activate the quest.
                activateQuest(questId, 0);
            } else {
                // TODO : uncheck the box if user cancel
            }
        }
    }

    function activateQuest(questId, state) {
        $.ajax({
            type: "POST",
            url: "<?php echo base_url() ?>quest/updateQuestState",
            data: {
                questId: questId,
                state: state,
            },
            dataType: 'json',
            success: function(data) {
                console.log(data);
                if (data.code === 1) {
                    // load successfully
                } else {
                    // error
                    alert("Some error occurred. Refresh your page and try again!");
                    // TODO : uncheck the box because of this error.
                }
            }
        });
    }

</script>