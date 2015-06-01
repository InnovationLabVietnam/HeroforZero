<div id="wrapper">

    <div id="page-wrapper">

        <div class="row">
            <h1>Game options</h1>
            <p>Each quest must belong to a city or a packet. You must first create that city or packet, then you can associate that packet/city with your quest.</p>


            <!-- Nav tabs -->
            <ul class="nav nav-tabs" role="tablist">

                <li class="active"><a href="#category-pane" role="tab" data-toggle="tab">Category</a></li>
                <li ><a href="#animation" role="tab" data-toggle="tab">Animation</a></li>
<!--                <li><a href="#packet" role="tab" data-toggle="tab">Packet</a></li>-->
            </ul>

            <!-- Tab panes -->
            <div class="tab-content">
                <div class="tab-pane active" id="category-pane">

                    <h2>Category</h2>

                    <table class="table table-striped table-bordered" id="category-table">
                        <thead>
                            <tr>
                                <th>Question Category</th>
                                <th>Number of Questions</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>

                        </tbody>
                    </table>
                    <form class='form-inline' role ='form' onsubmit="createCategory();
                            return false;">
                        <div class='form-group col-md-6'>
                            <label class='sr-only' for='category'>Category's Name</label>
                            <input type='text' class='form-control' id='category' placeholder='Write the category name' required="">
                        </div>
                        <div class='col-md-6'>
                            <button type='submit' class='btn btn-block btn-primary'>Add Category</button>
                        </div>
                    </form>
                </div>

                <div class="tab-pane " id="animation">
                    <h2>Animation</h2>
                    <p><a href="/admin/create_animation" class="btn btn-primary btn-mini"><i class="fa fa-plus"></i> Create a new animation</a></p>

                    <table class="table table-striped table-bordered" id="animation-table">
                        <thead>
                            <tr>
                                <th>Id</th>
                                <th>Time</th>
                                <th>Hero Walking</th>
                                <th>Hero Standby</th>
                                <th>Monster</th>
                                <th>Kid Frame</th>
                                <th>Background Color</th>
                                <th>Screen shot</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>

                        </tbody>
                    </table>

                </div>
                <div class="tab-pane" id="packet">
                    <h2>Packet</h2>
                    <p>Each quest must belong to a city or a packet. You must first create that city or packet, then you can associate that packet/city with your quest.</p>
                    <table class="table table-striped table-bordered" id="packet-table">
                        <thead>
                            <tr>
                                <th>Packet's Name</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>

                        </tbody>
                    </table>
                    <form class='form-horizontal' role ='form' onsubmit="return false;">
                        <fieldset>

                            <!-- Form Name -->
                            <legend></legend>
                            <!-- Text input-->
                            <div class="form-group">
                                <label class="col-md-4 control-label" for="packet">Packet's Name</label>  
                                <div class="col-md-8">
                                    <input id="packet" name="packet" type="text" placeholder="Write the packet's name" class="form-control input-md" required="">

                                </div>
                            </div>

                            <!-- Button -->
                            <div class="form-group">
                                <label class="col-md-4 control-label" for="submit"></label>
                                <div class="col-md-8">
                                    <button type='submit' class='btn btn-block btn-primary'>Add Packet</button>
                                </div>
                            </div>
                        </fieldset>
                    </form>
                </div>

            </div>
        </div>
    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->