<!-- TODO : Not completed -->
        <div class="row">
            <div class="large-12 columns">
                <nav class="top-bar" data-topbar>
                    <ul class="title-area">
                        <li class="name">
                            <h1><a id="quest-name" href="#"></a></h1>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>


        <div class="row">
            <div class="large-12 columns">
                <ul id="quest-detail">
                    
                </ul>
            </div>
        </div>

        <script>
            $(document).ready(function() {
                event.preventDefault();
                $.ajax({
                    type: "POST",
                    url: "<?php echo URL ?>quest/questDetail",
                    data: {
                        questId: <?php echo $this->questId ?>,
                    },
                    dataType: 'json',
                    success: function(data) {
                        console.log(data);
                        if (data.code === 1) {
                            // load successfully
                            var customerList = "";
                            customerList += "<table class=\"table\">";
                            
                            customerList += "<tr>";
                            customerList += "<td>Description</td>";
                            customerList += "<td>";
                            customerList += "<p><img class=\"th\" src=\"";
                            customerList += data.info.image_url;
                            customerList += "\"></img></p>";
                            customerList += data.info.description;
                            customerList += "</td>";
                            customerList += "</tr>";
                             customerList += "<tr>";
                            customerList += "<td>Address</td>";
                            customerList += "<td>";
                            customerList += data.info.address;
                            customerList += "</td>";
                            customerList += "</tr>";
                             customerList += "<tr>";
                            customerList += "<td>Points</td>";
                            customerList += "<td>";
                            customerList += data.info.points;
                            customerList += "</td>";
                            customerList += "</tr>";
                             customerList += "<tr>";
                            customerList += "<td>Donation</td>";
                            customerList += "<td>";
                            if (data.info.donate_url !== null){
                                customerList += data.info.donate_url;
                            } else {
                                
                            }
                            customerList += "</td>";
                            customerList += "</tr>";
                            document.getElementById("quest-name").innerHTML = data.info.name;
                            document.getElementById("quest-detail").innerHTML = customerList;
                        } else {
                            // error
                        }
                    }
                });
            });

        </script>
