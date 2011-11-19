<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Pistilli Realty | NYC Residential &amp; Commerical Real Estate</title>
  <meta name="description" content="The Pistilli Realty group has built its group of New York rentals on quality customer service and family values.">
  <meta name="keywords" content="rentals, condos, apartments">
  <?php echo template::include_stylesheets(array('reset', 'blast'), 'screen, print') ?>
  <?php echo template::include_javascripts(array('listings')) ?>
  <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
  <script type="text/javascript">    
    $(function() {
      $.tablesorter.defaults.widgets = ['zebra']; 
      $("#list").tablesorter(); 
      $("h1").svg();
      $("h1").svg('get').load('/images/logo.svg');
      $(".amt span").svg();
      $("dt span").svg();
      $("#elevator").svg('get').load('/images/blast/elevator.svg');
      $("#laundry").svg('get').load('/images/blast/laundry.svg');
      $("#parking").svg('get').load('/images/blast/parking.svg');
      $("#no_dogs_allowed").svg('get').load('/images/blast/no_dogs_allowed.svg');
      $("#cats").svg('get').load('/images/blast/cat.svg');
      $("#doorman").svg('get').load('/images/blast/doorman.svg');
      $("#utilities").svg('get').load('/images/blast/utilities.svg');
      $("#gas").svg('get').load('/images/blast/gas.svg');
<? foreach($listings as $listing) { 
     $amenities = explode(",", $listing->property->amenities);
     unset($amenities[count($amenities)-1]);
     foreach($amenities as $amenity) { ?>
      $("#<?= $amenity ?>_<?= $listing->id ?>").svg('get').load('/images/blast/<?= $amenity ?>.svg');
<? } } ?>
    });
  </script>
</head>
<body>
  <div id="top">
    <div class="container">
      <header>
        <h1 style="background: none; text-indent: 0;"></h1>
        <h2>Listings</h2>
        <h3 class="week">Week of <?= date("n/j/y") ?></h3>
        <p><img src="/images/blast/attention.png" alt="!">There will be a brokers fee of <b>$100.00</b> Per Apartment except for Manhattan <b>$200.00</b>, the Brokers Fee must be paid in cash!</p>
<? /*
        <a href="/" id="home">Home</a>
*/ ?>
      </header>
      <section id="results">
        <div id="res">
          <table id="list" class="tabA tablesorter">
            <thead>
              <tr>
                <th class="loc">Location</th>
                <th class="addr">Address</th>
                <th class="amt">Amenities</th>
                <th class="floor">Floor</th>
                <th class="apt">Apt</th>
                <th class="size">Size</th>
                <th class="price">Price</th>
                <th class="status2">Status</th>
                <th class="status1">Work Status</th>
                <th class="super">Super Info</th>
              </tr>
            </thead>
            <tbody>
            <? foreach($listings as $listing) { ?>
              <tr class="<?= cycle("odd", "even") ?>" onclick="javascript:window.location='/listings/<?= $listing->id ?>'">
                <td class="loc" title="<?= $listing->property->neighborhood->location->location ?>"><?= $listing->property->neighborhood->neighborhood ?><? // &#151; <?= $listing->property->neighborhood->location->location ?></td>
                <td class="addr"><?= $listing->property->address ?></td>
                <td class="amt">
                  <?
                    $amenities = explode(",", $listing->property->amenities);
                    unset($amenities[count($amenities)-1]);
                    foreach($amenities as $amenity) {
                      echo '<span id="' . $amenity . '_' . $listing->id . '"></span>';
                    }
                  ?>
                </td>
                <td class="floor"><?= $listing->floor ?></td>
                <td class="apt"><?= $listing->apt_num ?></td>
                <td class="size"><?= $listing->size ?></td>
                <td class="price"><? if($listing->status_1_id == 4) echo "[HOLD]"; else echo money_format('%(.0n', $listing->price); ?></td>
                <td class="status2"><? if($listing->status_2_id != 4) echo @Status2::find($listing->status_2_id)->status; ?></td>
                <td class="status1"><?= @Status1::find($listing->status_1_id)->status ?></td>
                <td class="super"><?= $listing->property->super ?></td>
              </tr>
            <? } ?>
            </tbody>
          </table>
          <div style="padding: 2px 0 0; border-bottom: 1px solid #d0d0d0; overflow: hidden;">
            <h3 class="legend left">Legend:</h3>
            <dl>
              <dt><span id="elevator"></span></dt>
              <dd>Elevator</dd>
            
              <dt><span id="laundry"></span></dt>
              <dd>Laundry</dd>
            
              <dt><span id="parking"></span></dt>
              <dd>Parking</dd>
            
              <dt><span id="doorman"></span></dt>
              <dd>Doorman</dd>
            
              <dt><span id="gas"></span></dt>
              <dd>Free Gas</dd>
            
              <dt><span id="utilities"></span></dt>
              <dd>All Utilities</dd>
            </dl>
          </div>
          <dl style="padding: 2px 0 0; border-bottom: 1px solid #d0d0d0; overflow: hidden">
            <dt class="clear"><span id="no_dogs_allowed"></span></dt>
            <dd style="padding: 9px 10px 0 3px;">No Dogs Allowed</dd>
            <dt><span id="cats"></span></dt>
            <dd style="padding: 9px 3px 0;">Cats Are Allowed</dd>
          </dl>              
        </div>
      </section>
      <footer>
        <a href="http://www.empirestudios.net/" title="Empire Studios" id="empire">Powered By: Empire Studios</a> 
        <p style="font-weight: bold;">Pistilli Realty Group reserves the right to change any information WITHOUT notice.</p>
        <p style="padding: 7px 0;">Copyright &copy; 2011 Pistilli Realty Group. All rights reserved.</p>
      </footer>
<? /*
      <footer>
        <a href="/" id="logo">Pistilli</a>
          <a href="" id="legal">Legal Privacy</a>
          <a href="#top" id="to_top">Back To Top</a>
          <a href="/blog" id="go_blog"><strong>Blog</strong></a>
          <a href="/listings" id="go_listings"><strong>View Listings</strong></a>
          <a href="/#contact" id="go_contact"><strong>Contact Us</strong></a>
        <a href="http://www.empirestudios.net/" id="empire">Powered By: Empire Studios</a>
      </footer>
*/ ?>
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