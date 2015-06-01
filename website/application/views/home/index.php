<!DOCTYPE html>
<html lang='en'>
    <head>
        <meta name="viewport" content='width=device-width, initial-scale=1'>
        <meta charset="utf-8">
        <title>Welcome to Hero for Zero</title>

        <link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/css/bootstrap.min.css" media="screen" />
        <link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/css/hero.css" media="screen" />
        <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
        <link rel="shortcut icon" href="<?php echo base_url(); ?>assets/img/favicon.ico" type="image/x-ico">

        <script type="text/javascript" src="<?php echo base_url(); ?>assets/js/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="<?php echo base_url(); ?>assets/js/bootstrap.min.js"></script>

        <script>
            (function (i, s, o, g, r, a, m) {
                i['GoogleAnalyticsObject'] = r;
                i[r] = i[r] || function () {
                    (i[r].q = i[r].q || []).push(arguments)
                }, i[r].l = 1 * new Date();
                a = s.createElement(o),
                        m = s.getElementsByTagName(o)[0];
                a.async = 1;
                a.src = g;
                m.parentNode.insertBefore(a, m)
            })(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');

            ga('create', 'UA-49504439-1', 'heroforzero.be');
            ga('send', 'pageview');

        </script>

    </head>
    <body>
        <!--Facebook SDK-->
        <script>
       window.fbAsyncInit = function() {
    FB.init({
      appId      : '600584033376388',
      xfbml      : true,
      version    : 'v2.2'
    });
  };

  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));
       
       function shareIt(){
           FB.ui({
                method: 'share',
                href: 'https://heroforzero.be/',
              }, function(response){});
       }
       $(document).ready(function(){
           $('.btn-share').on('click', function(){
                shareIt();
            });
       });
       
    </script>
        
        
        <div class="container-fluid">
            <div class="row" id="header-video">
                <video width="100%" height="100%" autoplay loop class="blur border-bottom">
                    <source src="<?php echo base_url(); ?>assets/img/demo/hero-hi.mp4" type="video/mp4">
                    <img src="<?php echo base_url(); ?>assets/img/demo/hfz-poster.png" width="100%" height="100%">
                </video>
            </div>

            <div class="row img-center height-0">
                <div id="phone-container" class="send-to-front">
                    <div id="main_image">
                        <img src="<?php echo base_url(); ?>assets/img/demo/iphone.png" class="img-responsive img-center" width="300" alt="Hero For Zero">
                    </div>
                    <div id="overlay_image">
                        <img src="<?php echo base_url(); ?>assets/img/demo/iphone-inside.png" class="img-responsive img-center" width="250" alt="Hero For Zero">
                    </div>
                </div>
            </div>

            <!--Content body-->
            <div class="row">
                <div class=" col-md-10 col-md-offset-1">
                    <div class="row border-bottom add-space-above-sm">
                        <div class="col-sm-4 text-blue text-center">
                            <p class="text-24">
                                Number of children under 5 to support in Vietnam:
                            </p>
                            <p class="text-xxlarge font-varela-round"><b><?php echo $children ?></b></p>
                        </div>
                        <div class="col-sm-4 col-sm-offset-4">
                            <div class="row">
                                <button class="btn btn-hero-blue btn-share" id="fb-share" href="#">Share</button> 
                                <button class="btn btn-hero-blue" type="button" data-toggle="modal" data-target="#donateModal">Donate to an NGO</button>
                            </div>
                            <div class="row">
                                <a class="btn btn-hero-blue " target="_blank"  href="https://itunes.apple.com/us/app/heroforzero/id839890618?mt=8">
                                    <div class="row-fluid btn-appstore">
                                        <div class="col-xs-4">
                                            <span class="fa fa-apple fa-4x"></span>
                                        </div>
                                        <div class="col-xs-8">
                                            <span class="text-medium">Available on the</span>
                                            <br>
                                            <span class="text-medium">Apple App Store</span>

                                        </div>
                                    </div>


                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="row border-bottom add-space-above-sm">
                        <div class="col-sm-4">
                            <!--Fact-->
                            <table class="table ver-center table-noborder table-condensed">
                                <tr>
                                    <td><img src="<?php echo base_url(); ?>assets/img/demo/vn-flag.png" height="35px"></td>
                                    <td class="text-xlarge">In Vietnam</td>
                                </tr>
                                <tr>
                                    <td class="text-xlarge">100</td>
                                    <td class="text-21"><b>children die preventable</b> deaths every day </td>
                                </tr>
                                <tr>
                                    <td class="text-xlarge">1</td>
                                    <td class="text-21"><b>child dies every hour</b> from injury: mainly drowning and traffic accidents</td>
                                </tr>
                                <tr>
                                    <td class="text-xlarge">2</td>
                                    <td class="text-21"><b>million children</b> suffer permanent physical and brain damage due to malnutrition</td>
                                </tr>
                                <tr>
                                    <td class="text-xlarge">3</td>
                                    <td class="text-21"><b>million children</b> are deprived of clean drinking water</td>
                                </tr>
                                <tr>
                                    <td class="text-xlarge">12</td>
                                    <td class="text-21"><b>million children</b> do not have access to hygienic latrines.</td>
                                </tr>
                            </table>

                        </div>
                        <!--Leader board-->
                        <div class="col-sm-4 col-sm-offset-4">
                            <p class="text-xlarge">Top 4: Leaderboard</p>
                            <!--TODO : Check if empty array first-->
                            <table class="table  ver-center table-noborder">
                                <tbody>
                                <?php for ($i=0; $i<count($leader); $i++) :
                                echo "<tr>";
                                    echo "<td class='text-xlarge'>".($i+1) .".</td>";
                                    if ($leader[$i]->avatar == 2){
                                        $image = "boy_hero@2x.png";
                                    } else {
                                        $image = "girl_hero@2x.png";
                                    }
                                    echo "<td><img class='img-circle' src=' ".base_url()."assets/img/player/".$image ."' height='60px'></td>";
                                    echo "<td><span class='text-18'>".$leader[$i]->name."</span><br>".$leader[$i]->mark."</td>";
                                echo "</tr>";
                            endfor; ?>
                                </tbody>
                            </table>
                            
                        </div>
                    </div>

                    <!--How it works-->
                    <div class="row  add-space-above-md">
                        <h2 class="text-center">Will you help us support the children?</h2>
                        <h3 class="text-center">Here's how this works:</h3>
                        <!--Three steps-->
                        <div class="col-sm-4">
                            <h3>Step 1: NGOs Know</h3>
                            <p>NGOs who work with and provide for children will create questions, activities and donations for the content of the app</p>
                            <img class="img-responsive add-space-above-md" src="<?php echo base_url(); ?>assets/img/demo/admin-website.png" height="750px">
                        </div>
                        <div class="col-sm-4">
                            <h3>Step 2: Educate</h3>
                            <p>You, the HERO, will educate yourself on how to help and support a child from a preventable death in the virtual world</p>
                            <img class="img-responsive add-space-above-md" src="<?php echo base_url(); ?>assets/img/demo/educate.png" height="750px">
                        </div>
                        <div class="col-sm-4">
                            <h3>Step 3: Activate</h3>
                            <p>Participate in NGO's activities and donate to NGOs, and inform your friends to support children in the real world</p>
                            <img class="img-responsive add-space-above-md" src="<?php echo base_url(); ?>assets/img/demo/activate.png" height="750px">
                        </div>
                    </div>

                    <!--Building community-->
                    <div class="row  add-space-above-md add-space-below-lg">
                        <h2 class="text-center">It's more than a game, it's a community of HEROs</h2>
                        <h3 class="text-center add-space-below-md">Supporting children | Building communities</h3>
                        <!--Three groups-->
                        <div class="col-sm-4 add-space-above-xs">
                            <img class="img-responsive add-space-below-md" src="<?php echo base_url(); ?>assets/img/demo/partners.png">
                            <p>HEROforZERO is supported by Vietnam Community and having partnered with many great organizations and people who already are supporting children's lives in the real world.</p>
                        </div>
                        <div class="col-sm-4 add-space-above-xs">
                            <img class="img-responsive add-space-below-md" src="<?php echo base_url(); ?>assets/img/demo/ranking.png">
                            <p>As you progress in your quest to help children you will encounter many rivalries. This will be tracked based on your global point rankings seen in the "Leaderboard" screen.</p>
                        </div>
                        <div class="col-sm-4 add-space-above-xs">
                            <img class="img-responsive add-space-below-md" src="<?php echo base_url(); ?>assets/img/demo/together.png">
                            <p>You alone cannot support 7,000,000 children. You must enlist your friends, families, co-workers, and neighbors to help. With this united community we could do our small parts to help change the number of preventable child deaths in Vietnam to ZERO.</p>
                        </div>
                    </div>

                    <!--Image of characters-->
                    <img class="img-responsive add-space-above-xxl add-space-below-lg" src="<?php echo base_url(); ?>assets/img/demo/all-characters.png">
                    
                    <!--Call for action-->
                    <div class="row  add-space-above-md">
                        <div class="col-sm-8 text-center">
                            <p class="text-medium">Be an agent for change. The only way to support 7,000,000 children is to get a lot of people to support one child at a time. Your 
                                small actions combined makes a big difference. How do you get involved? Play the game and learn through the quizes. Share with your
                                friends or donate to these many great organizations who are the true HEROforZERO.</p>
                        </div>
                        <div class="col-sm-4">
                            <div class="row">
                                <button class="btn btn-hero-blue btn-share" href="#">Share</button> 
                                <button class="btn btn-hero-blue" type="button" data-toggle="modal" data-target="#donateModal">Donate to an NGO</button>
                            </div>
                            <div class="row">
                                <a class="btn btn-hero-blue " target="_blank"  href="https://itunes.apple.com/us/app/heroforzero/id839890618?mt=8">
                                    <div class="row-fluid btn-appstore">
                                        <div class="col-xs-4">
                                            <span class="fa fa-apple fa-4x"></span>
                                        </div>
                                        <div class="col-xs-8">
                                            <span class="text-medium">Available on the</span>
                                            <br>
                                            <span class="text-medium">Apple App Store</span>

                                        </div>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <!--Footer-->
            <div class="row footer-blue text-white add-space-above-md">
                <div class="container">
                <div class="row">
                <!--Message for member-->
                <div class="col-md-7 col-md-offset-1 text-center add-space-above-md">
                    Are you an organization or a person that likes helping? You can sign up and help us create content and help promote your cause and NGO.
                </div>
                <div class="col-md-4 add-space-above-md">
                    <a class="btn btn-hero-blue" href="<?php echo base_url(); ?>login">Login</a>
                    or
                    <a class="btn btn-hero-blue" href="<?php echo base_url(); ?>signup">Sign up</a>
                </div>
                </div>
                <div class="row text-center add-space-above-md add-space-below-sm">
                    <span class="text-xsmall">Copyright HEROforZERO 2015</span>
                </div>
                </div>
            </div>
        </div>
    
    <!-- Modal -->
<div class="modal fade text-white" id="donateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header text-center">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title text-44" id="myModalLabel">Donate</h4>
        <p>Click on the name of the organization below to visit their website and donate to them.</p>
      </div>
      <div class="modal-body">
        <!--Check if empty array first-->
        <?php if(count($donate)): ?>
                            <table class="table  ver-center table-noborder table-hover">
                                <tbody>
                                <?php for ($i=0; $i<count($donate); $i++) :
                                    if (!empty($donate[$i]['donation_link'])){
                                echo "<tr>";
                                    if ($donate[$i]['IconURL'] ){
                                        $image = $donate[$i]['IconURL'];
                                        echo "<td><img class='img-circle add-margin-left-md' src=' ".$image ."' height='60px'></td>";
                                    } else {
                                        $strings = explode(" ", $donate[$i]['PartnerName']);
                                        if (count($strings)>1){
                                            $short = strtoupper(substr($strings[0], 0,1).substr($strings[1], 0,1));
                                        } else {
                                            $short = strtoupper(substr($strings[0], 0,2));
                                        }
                                        
                                        echo "<td><div class='avatar-overlay'><img class='img-circle add-margin-left-md' height='60px' width='60px'>";
                                        echo "<div class='text-name-alt'>".$short."<div>";
                                        echo "</div></td>";
                                    }
                                    
                                    echo "<td><a href='".$donate[$i]['donation_link']."' ><span class='text-18'>".$donate[$i]['PartnerName']."</a></td>";
                                echo "</tr>";
                                    }
                            endfor; ?>
                                </tbody>
                            </table>
        <?php else : ?>
        <p>Currently doesn't have any donation information available.</p>
        
        <?php endif; ?>
      </div>
    </div>
  </div>
</div>
    
    
    </body>
</html>