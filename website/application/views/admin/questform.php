<div id="wrapper">

    <div id="page-wrapper">

        <div class="row">
            <div class="col-lg-12">
                <h1>Quest Form <small>Enter Your Data</small></h1>
                <ol class="breadcrumb">
                    <li><a href="index.php"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                    <li class="active"><i class="fa fa-edit"></i> Quest Form</li>
                </ol>
            </div>
        </div>

        <div class="row">
            <!--<div class="col-lg-3"></div>-->
            <div class="col-lg-6">
                <h1>Basic Info</h1>
                <form id="form_quest">
                    <div class="form-group">
                        <label for="">Group Quest</label>
                        <select name="parentQuest" class="form-control">
                            <option value="NULL">none</option>
                            <?php
                            $host = '127.0.0.1';
                            $username = 'user_hau';
                            $password = '123456';
                            $dbname = 'travel_hero';
                            $conn = mysqli_connect($host, $username, $password, $dbname);

                            if (mysqli_connect_errno())
                                echo "Failed to connect to MySQL: " . mysqli_connect_error();

                            // Select Parent Quest Id, name
                            $result = mysqli_query($conn, "SELECT Id, Name FROM quest WHERE parent_quest_id IS NULL");

                            while ($row = mysqli_fetch_array($result)) {
                                echo '<option value="' . $row['Id'] . '">' . $row['Name'] . '</option>';
                            }

                            mysqli_close($conn);
                            ?>
                        </select>
                    </div>	

                    <div class="form-group">
                        <label>Quest Name</label>
                        <input type="text" class="form-control" id="questName" name="questName" value="" />
                    </div>

                    <div class="form-group">
                        <label>Description</label>
                        <textarea rows="4" cols="50" class="form-control" id="questDescription" name="questDescription"></textarea> 
                    </div>

                    <div class="form-group">
                        <label>Point</label>
                        <select name="questPoint" class="form-control">
                            <option value="100">Hard</option>
                            <option value="50">Easy</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Url Donate</label>
                        <input type="text" class="form-control" id="donateUrl" name="donateUrl" value="" placeholder="http://www.example.com" />
                    </div>

                    <label>Address</label>
                    <div class="form-group input-group">
                        <input type="text" class="form-control" id="address" name="address"/>
                        <span class="input-group-btn">
                            <button class="btn btn-default" type="button" id="searchAddress"><i class="fa fa-search"></i></button>
                        </span>
                    </div>

                    <input type="hidden" id="latitude" name="latitude" value="null" />
                    <input type="hidden" id="longitude" name="longitude" value="null" />
                    <input type="hidden" id="photoUrl" name="photoUrl" value="null" />

                    <input type="submit" value="Submit" id="submit" class="btn btn-primary"/>
                    <div id="fp_message"></div>
                </form>      
            </div>

            <div class="col-lg-6">
                <h1>Photo</h1>
                <!-- simple file uploading form -->
                <img style="display:none" id="loader" src="images/loader.gif" alt="Loading...." title="Loading...." />

                <form id="form" enctype="multipart/form-data" method="post" action="upload.php">
                    <input type="hidden" name="MAX_FILE_SIZE" value="1048576" />
                    <div class="form-group">
                        <label>Photo upload</label>
                        <input type="file" class="form-control" size="32" name="my_field" value="" />
                        <p class="help-block">Max file size 1MB.</p>
                        <input type="hidden" name="action" value="simple" />
                        <input id="button" type="submit" value="Upload" class="btn btn-primary">
                    </div>
                </form>
                <!-- image preview -->
                <div id="preview" style="display:none"></div>
                <!-- map preview -->
                <div id="map_canvas" style="display: none;"></div>


            </div>
        </div>
    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->