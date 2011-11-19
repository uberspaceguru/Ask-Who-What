<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Pistilli Realty | NYC Residential &amp; Commerical Real Estate</title>
  <meta name="description" content="The Pistilli Realty group has built its group of New York rentals on quality customer service and family values.">
  <meta name="keywords" content="rentals, condos, apartments">
  <?php echo template::include_stylesheets(array('reset', 'unsubscribe')) ?>
  <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
</head>
<body>
  <div id="top">
    <header class="container">
      <h1><a href="/">Pistill</a></h1>
    </header>
    <div class="container">
      <section>
        <h2>You have successfully unsubscribed.</h2>
        <p>
          Dear <?= $user->name ?>,<br>
          We're sorry you don't like our e-mails. If you'd like to resubscribe, please <a href="/user">login</a> and edit your account settings or email us at <a href="mailto:info@pistilli.com">info@pistilli.com</a>.<br>
          <br>
          Regards,<br>
          The Pistilli Team
        </p>
      </section>
      <footer>
        <a href="/" id="logo">Pistilli</a>
          <a href="/user/legal" id="legal">Legal Privacy</a>
          <a href="#top" id="to_top">Back To Top</a>
          <a href="http://www.pistillicorner.com" id="go_blog" target="_blank"><strong>Blog</strong></a>
          <a href="/listings" id="go_listings"><strong>View Listings</strong></a>
          <a href="/#contact" id="go_contact"><strong>Contact Us</strong></a>
        <a href="http://www.empirestudios.net/" id="empire">Powered By: Empire Studios</a>
      </footer>
    </div>
  </div>
  <script type="text/javascript">

    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-15789186-6']);
    _gaq.push(['_trackPageview']);

    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();

  </script>
</body>
</html>