
        This is Quest index, need to be edited :)
        <div class="row">
            <div class="large-12 columns">
                <nav class="top-bar" data-topbar>
                    <ul class="title-area">
                        <li class="name">
                            <h1><a href="#">Quest</a></h1>
                        </li>
                        <li class="toggle-topbar menu-icon"><a href="#">Menu</a></li>
                    </ul>

                    <section class="top-bar-section">
                        <!-- Right Nav Section -->
                        <ul class="right">
                            <li class="active"><a href="<?php echo base_url() ?>formquest/index.php">Add new Quest</a></li>
                        </ul>

                        <!-- Left Nav Section -->
                        <ul class="left">
                            <li><a href="#"> </a></li>
                        </ul>
                    </section>
                </nav>
            </div>
        </div>


        <div class="row">
            <div class="large-12 columns">
                <ul id="quest-list">

                </ul>
            </div>
        </div>
        <div id="pages"></div>



        <script>
            $(document).foundation();


            // TODO : Pagination: tut: http://www.sanwebe.com/2013/03/ajax-pagination-with-jquery-php
        </script>

        <script>
            // TODO : Consider using popup : http://www.nicolashoening.de/?twocents&nr=8
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
                            var pagination = "";
                            if (pages > 1) {
                                pagination += '<ul class="paginate">';
                                for (var i = 1; i <= pages; i++)
                                {
                                    pagination += '<li><a href="#" class="paginate_click" id="' + i + '-page">' + i + '</a></li>';
                                }
                                pagination += '</ul>';
                            }
                            document.getElementById("pages").innerHTML = pagination;

                            loadQuestList(0, pageSize);
                            $("#1-page").addClass('active');
                        } else {
                            // error
                        }
                        
                        $(".paginate_click").click(function(e) {

                            $("#quest-list").prepend('<div class="loading-indication"><img src="ajax-loader.gif" /> Loading...</div>');

                            var clicked_id = $(this).attr("id").split("-"); //ID of clicked element, split() to get page number.
                            var page_num = parseInt(clicked_id[0]); //clicked_id[0] holds the page number we need 

                            $('.paginate_click').removeClass('active'); //remove any active class

                            //post page number and load returned data into result element
                            //notice (page_num-1), subtract 1 to get actual starting point
                            loadQuestList(page_num - 1, pageSize);

                            $(this).addClass('active'); //add active class to currently clicked element

                            return false; //prevent going to herf link
                        });
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
                            customerList += "<table class=\"table\"><th>Quest</th><th></th><th>State</th>";
                            for (var i in data.info) {
                                customerList += "<tr>";
                                customerList += "<td><a href=\"";
                                customerList += "<?php echo base_url() ?>" + "quest/detail/" + data.info[i].id;
                                customerList += "\">";
                                customerList += data.info[i].name;
                                customerList += "</a><iframe class=\"box\" src=\""
                                customerList += "<?php echo base_url() ?>" + "quest/detail/" + data.info[i].id + "\" width = \"500px\" height = \"500px\"></iframe></td>";

                                customerList += "<td><a href=\"";
                                customerList += "<?php echo base_url() ?>" + "quest/edit/" + data.info[i].id;
                                customerList += "\">Edit</a>";
                                customerList += "</td>";

                                customerList += "<td>";
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
