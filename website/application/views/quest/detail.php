<div class="row">
    <div class="col-md-8">
        <div class="page-header">
            <h1 id="quest-name"></h1>
        </div>
        <div id="quest-detail">

        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        event.preventDefault();
        $("#quest-detail").prepend('<div class="loading-indication"><span class="glyphicon glyphicon-refresh"></span> Loading...</div>');
        $.ajax({
            type: "POST",
            url: "<?php echo base_url() ?>quest/questDetail",
            data: {
                questId: <?php echo $questId ?>,
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
                    customerList += "<p><img class=\"img-responsive\" src=\"";
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
                    if (data.info.donate_url !== null) {
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