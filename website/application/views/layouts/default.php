<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title><?php echo $template['title'] ?></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?php echo $template['metadata'] ?>
    
    <script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-49504439-1', 'heroforzero.be');
  ga('send', 'pageview');

</script>

  </head>

  <body class="<?php echo $body_class ?>">
    <?php echo $template['partials']['header'] ?>

    <div class="container">

      <?php echo $template['partials']['flash_messages'] ?>

      <?php echo $template['body'] ?>

      <?php echo $template['partials']['footer'] ?>

    </div> <!-- /container -->
    
    <!-- Scroll to top button -->
    <div class="scroll-top-wrapper">
    <span class="scroll-top-inner">
        <i class="fa fa-2x fa-chevron-up"></i>
    </span>
</div>
    
  </body>
</html>