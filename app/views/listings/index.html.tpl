<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Pistilli Realty | NYC Residential &amp; Commerical Real Estate</title>
  <meta name="description" content="The Pistilli Realty group has built its group of New York rentals on quality customer service and family values.">
  <meta name="keywords" content="rentals, condos, apartments">
  <?php echo template::include_stylesheets(array('reset', 'listings')) ?>
  <?php echo template::include_javascripts(array('listings')) ?>
  <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
  <script type="text/javascript">
    var initialized = false;
    function initialize() {
      var myOptions = {
        zoom: 11,
        center: new google.maps.LatLng(<?= $midpts['lat'] ?>, <?= $midpts['lng'] ?>),
        mapTypeId: google.maps.MapTypeId.ROADMAP
      }
      var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
      var image = '/images/listings/pin.png';
      var shadow = new google.maps.MarkerImage('/images/listings/pinshad.png',
        new google.maps.Size(40, 6),
        new google.maps.Point(0, 0),
        new google.maps.Point(20, -1));
      var markers = new Array();
      var points = new Array();
      var marker;
      <?php
      foreach(Listing::all(array('select' => "DISTINCT(property_id)", 'conditions' => 'status_2_id = 4 AND status_1_id != 4')) as $listing) {
          if(!empty($listing->property->lat) && !empty($listing->property->lng)) { ?>
            points.push(new google.maps.LatLng(<?= $listing->property->lat ?>, <?= $listing->property->lng ?>));
            marker = new google.maps.Marker({
              position: points[points.length-1],
              shadow: shadow,
              map: map,
              icon: image
            });
            google.maps.event.addListener(marker, "click", function() {
              window.location = '/listings?property_id=' + <?= $listing->property_id ?>;
            });
            markers.push(marker);
      <? } } ?>
    }
    
    $(function() {
      $.tablesorter.defaults.widgets = ['zebra']; 
      $("#list").tablesorter();
      $("th.price.header").click().click();
      $("#tabs a").click(function() {
        var switchTo = this.href.split('#')[1];
        if(!$(this).hasClass('sel')) {
          $(".tabA").fadeOut('fast', function() {
            $(this).removeClass('sel');
            $('#'+switchTo).addClass('sel');
            $('#'+switchTo).fadeIn('fast');
            if(!initialized) {
              initialize();
              initialized = true;
            }
          });
          $("a").removeClass('sel');
          $(this).addClass('sel');
        }
        return false;
      });
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
      <section id="form">
        <h3>You are looking for:</h3>
        <form method="get">
          <dl>
            <dt style="top: 75px;"><label for="loc">Location:</label></dt>
            <dd style="top: 92px;">
              <select name="search[loc]" id="loc" class="big">
                <option>Any</option>
              <? foreach(Location::all() as $location) { ?>
                <option value="<?= $location->id ?>"><?= $location->location ?></option>
              <? } ?>
              </select>
            </dd>
            
            <dt style="top: 75px; left: 441px;"><label for="bed">Bedrooms:</label></dt>
            <dd style="top: 92px; left: 441px;">
              <select name="search[bed]" id="bed">
                <option>Any</option>
              <? foreach(Listing::all(array('select' => "DISTINCT(bed)", 'order' => 'bed asc', 'conditions' => 'status_2_id = 4 AND status_1_id != 4')) as $beds) { ?>
                <option><?= $beds->bed ?></option>
              <? } ?>
              </select>
            </dd>
            
            <dt style="top: 75px; left: 610px"><label for="bath">Bathrooms:</label></dt>
            <dd style="top: 92px; left: 610px">
              <select name="search[bath]" id="bath">
                <option>Any</option>
              <? foreach(Listing::all(array('select' => "DISTINCT(bath)", 'order' => 'bath asc', 'conditions' => 'status_2_id = 4 AND status_1_id != 4')) as $baths) { ?>
                <option><?= $baths->bath ?></option>
              <? } ?>
              </select>
            </dd>
            
            <dt style="top: 140px;"><label for="hood">Neighborhood:</label></dt>
            <dd style="top: 157px;">
              <select name="search[hood]" id="hood" class="big">
                <option>Any</option>
              <? foreach(Neighborhood::all() as $neighborhood) { ?>
                <option value="<?= $neighborhood->id ?>"><?= $neighborhood->neighborhood ?></option>
              <? } ?>
              </select>
            </dd>
            
            <dt style="top: 140px; left: 441px;"><label for="min">Min Price:</label></dt>
            <dd style="top: 157px; left: 441px;">
              <select name="search[min]" id="min">
                <option>Any</option>
                <option value="500">$500</option>
                <option value="1000">$1,000</option>
                <option value="1500">$1,500</option>
                <option value="2000">$2,000</option>
                <option value="2500">$2,500</option>
                <option value="3000">$3,000</option>
                <option value="3500">$3,500</option>
                <option value="4000">$4,000+</option>
              </select>
            </dd>
            
            <dt style="top: 140px; left: 610px"><label for="max">Max Price:</label></dt>
            <dd style="top: 157px; left: 610px">
              <select name="search[max]" id="max">
                <option>Any</option>
                <option value="500">$500</option>
                <option value="1000">$1,000</option>
                <option value="1500">$1,500</option>
                <option value="2000">$2,000</option>
                <option value="2500">$2,500</option>
                <option value="3000">$3,000</option>
                <option value="3500">$3,500</option>
                <option value="4000">$4,000+</option>
              </select>
            </dd>
          </dl>
          <div>
            <input type="submit" class="submit" value="Search Again">
          </div>
        </form>
      </section>
      <section id="results">
        <div id="res">
          <ul id="tabs">
            <li><a href="#list" class="sel">List</a></li>
            <li class="formap"><a href="#map_canvas">Map</a></li>
          </ul>
          <ul id="opts">
            <li><a href="/print?url=<?= (!empty($_SERVER['HTTPS'])) ? "https://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'] : "http://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI']; ?>" id="print">Print</a></li>
            <li><a href="mailto: ?subject=Listing Results from Pistilli&amp;body=I thought you might be interested in these listings: <?= (!empty($_SERVER['HTTPS'])) ? "https://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'] : "http://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI']; ?>" id="email">Email Listings</a></li>
          </ul>
          <div id="map_canvas" style="display: none;" class="tabA"></div>
          <table id="list" class="tabA tablesorter">
            <thead>
              <tr>
                <th class="addr" colspan="2">Address</th>
                <th class="loc">Location</th>
                <th class="bed">Bedrooms</th>
                <th class="bath">Bathrooms</th>
                <th class="sqft">Sq. Feet</th>
                <th class="price">Price</th>
              </tr>
            </thead>
            <tbody>
            <? foreach($listings as $listing) { ?>
              <tr class="<?= cycle("odd", "even") ?>" onclick="javascript:window.location='/listings/<?= $listing->id ?>'">
                <td><?= $listing->property->address ?></td>
                <td style="padding: 6px 40px 6px 0; text-align: right"><strong><?= $listing->apt_num ?></strong></td>
                <td><?= $listing->property->neighborhood->neighborhood ?> &#151; <?= $listing->property->neighborhood->location->location ?></td>
                <td class="bed"><?= $listing->bed ?></td>
                <td class="bath"><?= $listing->bath ?></td>
                <td class="sqft"><?= $listing->sqft ?></td>
                <td class="price"><?= money_format('%(.0n', $listing->price) ?></td>
              </tr>
            <? } ?>
            </tbody>
          </table>
        </div>
        <div id="pagination">
          <div>
            <p><?= "Displaying listings <strong>" . $start . "</strong>-<strong>" . $end . "</strong> of <strong>" . $listingCount . "</strong>" ?></p>
            <ul id="pagnav">
<? if($next) { ?>
              <li><a href="<?= pageVal($next) ?>">Next</a></li>
<? } ?>
<? if($prev) { ?>
              <li><a href="<?= pageVal($prev) ?>">Previous</a><? if($next) echo '|'; ?></li>
<? } ?>
            </ul>
          </div>
        </div>
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