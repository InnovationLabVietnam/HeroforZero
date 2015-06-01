<div class="alert alert-danger alert-dismissable top-alert">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <strong>Hi Super Admin!</strong> You are loged in as super admin, this means you're top dogs. So please be aware what you do affect others below you.
</div>

<div id="wrapper">


    <div id="page-wrapper">

        <h1><b>Welcome to Hero for Zero.</b></h1>
        <p>We are excited to introduce to you our new program.</p>

        <div>
            <hr class="hr-light-blue">
        </div>

        <!-- Nav tabs -->
        <ul class="nav nav-tabs" role="tablist">
            <li class="active"><a href="#quest_tab" role="tab" data-toggle="tab">Quest</a></li>
            <li><a href="#quiz_tab" role="tab" data-toggle="tab">Quiz</a></li>
            <li><a href="#activity_tab" role="tab" data-toggle="tab">Activity</a></li>
            <li><a href="#donation_tab" role="tab" data-toggle="tab">Donation</a></li>
        </ul>

        <!-- Tab panes -->
        <div class="tab-content">
            <div class="tab-pane active" id="quest_tab">
                <!-- Main content -->
                <h3>Please approve recent Quest</h3>
                <p>Below are quest that have been created. To create a new Quest, <a href="<?php echo base_url() ?>admin/create_quest">Click here</a></p>

                <div id="quest"></div>
                <br><br><br>
            </div>
            <div class="tab-pane" id="quiz_tab">
                <!-- Quest approval -->
                <h3>Please create more Quiz</h3>
                <p>To create new Quiz, <a href="<?php echo base_url() ?>admin/create_quiz">Click here</a></p>


                <div id="quiz">
                    
                    
                </div>

                <br><br><br>
            </div>
            <div class="tab-pane" id="activity_tab">
                <!-- Activity approval -->
                <h3>Please approve recent activity</h3>
                <p>Below are activities that have been created by other organizations. Please approve or deny them.</p>

                <div id="activity"></div>

                <br><br><br>
            </div>
            <div class="tab-pane" id="donation_tab">
                <!-- Donation approval -->
                <h3>Please approve recent Donation suggestions</h3>
                <p>Below are Donation suggestions that have been created by other organizations. Please approve or deny them.</p>

                <div id="donation"></div>
            </div>
        </div>

    </div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->