<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Pistilli Realty | NYC Residential &amp; Commerical Real Estate</title>
  <meta name="description" content="The Pistilli Realty group has built its group of New York rentals on quality customer service and family values.">
  <meta name="keywords" content="rentals, condos, apartments">
  <?php echo template::include_stylesheets(array('reset', 'listing')) ?>
  <?php echo template::include_javascripts(array('listing')) ?>
  <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
  <script type="text/javascript">
    var index = 1;
    var using = false;
    
    $(function() {
      $(".zoom").fancybox({
          'type'           : 'image',
          'transitionIn'   : 'elastic',
          'transitionOut'  : 'elastic'
      });
      
      $(".next").click(function() {
        if($(".current").next().is('li') && !using) {
          using = true;
          $(".current").next().animate({ left : 0 }, function() {
            $(".current").animate({ left : 386 });
            $(".current").removeClass('current');
            $(this).addClass('current');
            $(".zoom").attr('href', $(this).children().first().attr('src'));
            using = false;
          });
          index++;
        } else if(!using) {
          using = true;
          var newEle = $(".current").parent().children().first();
          newEle.css({ left : 0 });
          $(".current").animate({ left : 386 }, function() {
            using = false;
          });
          $(".current").removeClass('current');
          newEle.addClass('current');
          $(".zoom").attr('href', newEle.children().first().attr('src'));
          index = 1;
        }
        $("#slideNum").html(index);
        return false;
      });
      
      var height = $("#area .text").height();
      var src = "http://maps.google.com/maps/api/staticmap?center=<?= $listing->property->neighborhood->neighborhood ?>,NY&zoom=14&size=500x" + height + "&maptype=roadmap&sensor=true&style=feature:transit.line|element:all|hue:0x0000ff|visibility:on|lightness:0|gamma:1";
      $("#mapprev").attr('src', src);
    });
  </script>
</head>
<body>
  <div id="top">
    <div class="container">
      <header>
        <h1><a href="/">Pistilli</a></h1>
        <h2>Listings</h2>
        <a href="/" id="home">Home</a>
      </header>
      <section id="listing">
        <header>
          <a href="<? if(isset($_SERVER['HTTP_REFERER'])) echo $_SERVER['HTTP_REFERER']; else echo "/listings"; ?>" id="back">&laquo; Back to Listings</a>
          <h3><small><?= $listing->property->neighborhood->neighborhood ?> -</small><?= $listing->property->address ?> <small class="right" id="apt">Apt <?= $listing->apt_num ?></small></h3>
          <ul id="opts">
            <li><a href="/print?url=<?= (!empty($_SERVER['HTTPS'])) ? "https://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'] : "http://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI']; ?>" id="print">Print</a></li>
            <li><a href="mailto: ?subject=A Listing on Pistilli.com&amp;body=I thought you might be interested in this listing: <?= (!empty($_SERVER['HTTPS'])) ? "https://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'] : "http://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI']; ?>" id="email">Email Listings</a></li>
            <li><a href="/listings" id="search">New Search</a></li>
          </ul>
        </header>
        <div class="lleft">
          <ul id="overview">
            <li id="price"><small>Price Range:</small><?= money_format('%(.0n', $listing->price) ?> / month</li>
            <li><?= $listing->bed ?> bed / <?= $listing->bath ?> bath (<?= $listing->sqft ?> sq ft approx.)</li>
<? if($listing->avail == 1 || $listing->avail < time()) { ?>
            <li style="color: green;">Available Now</li>
<? } else if($listing->avail > time()) { ?>
            <li style="color: orange;">Available On <?= date("M j, Y", $listing->avail) ?></li>
<? } else { ?>
            <li style="color: red;">Not Available</li>
<? } ?>
          </ul>
          <p><?= stripslashes($listing->property->desc) ?></p>
          <div id="subways">
            <h4>Nearby Subways</h4>
            <ul>
            <?php
            foreach($subs as $sub) { ?>
              <li><?
              for($i = 1; $i <= 11; $i++) {
                $temp = "route_" . $i;
                if(!empty($sub->$temp)) {
                  echo '<img src="http://maps.gstatic.com/intl/en_us/mapfiles/transit/iw/us-ny-mta/sb/' . strtolower($sub->$temp) . '.png" alt="' . $sub->$temp . '">';
                }
              }
            ?><?= $sub->station_name ?> (<?= round($sub->distance, 2) ?> miles)</li>
            <? } ?>
            </ul>
          </div>
          <a href="/#contact" id="ask">Ask a Question</a>
          <p id="call"><strong>Call Us:</strong>718.204.1600</p>
        </div>
        <div id="floorplan">
          <h4>Floorplan</h4>
          <span>* Typical FloorPlan for apartments at this property.</span>
<?php if(!file_exists(PUB_ROOT . "/public/floorplans/" . $listing->id . "." . $listing->floorplan_ext)) { ?>
          <p class="not_avail">Not Available</p>
<? } else { ?>
          <img src="/public/floorplans/<?= $listing->id ?>.<?= $listing->floorplan_ext ?>" alt="Floorplan">
          <a href="/public/floorplans/<?= $listing->id ?>.<?= $listing->floorplan_ext ?>" class="zoom">Zoom</a>
<? } ?>
        </div>
        <div class="clear" id="specs">
          <div class="left">
            <h4>Property Specifications</h4>
            <ul>
<? foreach(nl2array($listing->property->specs) as $spec) { ?>
              <li><?= $spec ?></li>
<? } ?>
            </ul>
          </div>
          <div class="left apt">
            <h4>Apartment Specifications</h4>
            <ul>
<? foreach(nl2array($listing->specs) as $spec) { ?>
              <li><?= $spec ?></li>
<? } ?>
            </ul>
          </div>
          <ul id="propImgs">
<? 
$files = filesIn(PUB_ROOT . "/public/properties/" . $listing->property_id);
foreach($files as $file) { ?>
            <li<? if($file == $files[0]) echo ' class="current"'; ?>><img src="/public/properties/<?= $listing->property_id ?>/<?= $file ?>" alt="<?= $file ?>"></li>
<? } ?>
          </ul>
          <details>These Photos depict a typical Pistilli apartment.<span class="right"><span id="slideNum">1</span> / <?= count($files) ?></span></details>
          <a href="/public/properties/<?= $listing->property_id ?>/<?= $files[0] ?>" class="zoom">Zoom</a>
          <a href="#" class="arrow next">Next</a>
          <div class="cleft"></div>
          <a href="/listings?property_id=<?= $listing->property_id ?>" id="olist">See Other Listings at this Property</a>
        </div>
        <div class="clear"></div>
      </section>
      <section id="area">
        <div class="box">
          <img src="" alt="<?= $listing->property->neighborhood->neighborhood ?>, NY" id="mapprev" class="left">
          <div class="text">
            <h3>About <?= $listing->property->neighborhood->neighborhood ?></h3>
  <? foreach(nl2array($listing->property->neighborhood->desc) as $desc) { ?>
            <p><?= $desc ?></p>
  <? } ?>
          </div>
        </div>
        <div id="bot"></div>
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