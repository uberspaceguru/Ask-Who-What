<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Pistilli Realty | NYC Residential &amp; Commerical Real Estate</title>
  <meta name="description" content="The Pistilli Realty group has built its group of New York rentals on quality customer service and family values.">
  <meta name="keywords" content="rentals, condos, apartments">
  <?php echo template::include_stylesheets(array('reset', 'main')) ?>
  <?php echo template::include_javascripts(array('main', 'scroll')) ?>
  <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <style type="text/css">
      nav       { overflow: visible; }
    </style>
  <![endif]-->
  <script type="text/javascript">
    //$('a').smoothScroll();
    var original;
    
    function initialize() {
      var myOptions = {
        zoom: 12,
        center: new google.maps.LatLng(<?= $midpts['lat'] + .015 ?>, <?= $midpts['lng'] - .02 ?>),
        disableDefaultUI: true,
        scrollwheel: false,
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
    
    function balloon(dir) {
      if(dir == 'up') {
       $(".scroll").animate({ paddingTop: $.randomBetween(0, 10) }, 3000, function() { balloon("down") });
      } else {
       $(".scroll").animate({ paddingTop: $.randomBetween(35, 50) }, 3000, function() { balloon("up") });
      }
    }
    
    function findAddressViaGoogle(address) {
      var geocoder = new google.maps.Geocoder();
      geocoder.geocode( { 'address': address }, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          alert(results[0].geometry.location)
        } else {
          alert("Unable to find address: " + status);
        }
      });
    }
   
    function cloud(dir, which) {
      if(dir == 'left') {
       $("#"+which).animate({ marginLeft: $.randomBetween(0, 10) }, $.randomBetween(4000, 6000), function() { cloud("right", which) });
      } else {
       $("#"+which).animate({ marginLeft: $.randomBetween(35, 50) }, $.randomBetween(4000, 6000), function() { cloud("left", which) });
      }
    }
    
    function slide(num) {
      if(num == 1) {
        $("#go_m2").removeClass("sel");
        $("#go_m1").addClass("sel");
        $("#mover").animate({ left: 0 }, 500);
        $("#fb2").fadeOut("fast", function() {
          $("#fb1").fadeIn("fast");
        });
      } else if(num == 2) {
        $("#go_m1").removeClass("sel");
        $("#go_m2").addClass("sel");
        $("#mover").animate({ left: -523 }, 500);
        $("#fb1").fadeOut("fast", function() {
          $("#fb2").fadeIn("fast");
        });
      }
    }
    
    function validateContactForm() {
      var ret = true;
      var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
      if($("#name").val() == '' || $("#name").val() == "What's your name?") {
        $("#name").animate({ backgroundColor : '#28ADF1' });
        $("#name").val("What's your name?");
        ret = false;
      } else
        $("#name").animate({ backgroundColor : '#000000' });
        
      if($("#email").val() == '' || $("#email").val() == "What's your email?") {
        $("#email").animate({ backgroundColor : '#28ADF1' });
        $("#email").val("What's your email?");
        ret = false;
      } else if(!emailReg.test($("#email").val())) {
        $("#email").animate({ backgroundColor : '#28ADF1' });
        $("#email").val("Please enter a valid email.");
        ret = false;
      } else
        $("#email").animate({ backgroundColor : '#000000' });
        
      if($("#subject").val() == '' || $("#subject").val() == "You left this empty!") {
        $("#subject").animate({ backgroundColor : '#28ADF1' });
        $("#subject").val("You left this empty!");
        ret = false;
      } else
        $("#subject").animate({ backgroundColor : '#000000' });
        
      if($("#message").val() == '' || $("#message").val() == "Why are you contacting us?") {
        $("#message").animate({ backgroundColor : '#28ADF1' });
        $("#message").val("Why are you contacting us?");
        ret = false;
      } else
        $("#message").animate({ backgroundColor : '#000000' });
        
      return ret;
    }
    
    
    $(function() {
      initialize();
      $("#contact_form").submit(function() {
        if(validateContactForm()) {        
          $.post("/ajax/contact", $(this).serialize(), function(data) {
            $("#contajax").html(data);
          });
          return false;
        } else
          return false;
      });
      $(".scroll").jScroll();
      $(".scroll").jScroll({top : 100});
      balloon("up");
      cloud("right", "cloud_l");
      cloud("left", "cloud_m");
      cloud("right", "cloud_s");
      $("#move_1_but").click(function() {
        slide(1);
        return false;
      });
      $("#move_2_but").click(function() {
        slide(2);
        return false;
      });
      $("#next").click(function() {
        if($("#mover").css('left') == '0px') {
          slide(2);
        } else {
          slide(1);
        }
        return false;
      });
      $("#go_m1").click(function() {
        slide(1);
        return false;
      });
      $("#go_m2").click(function() {
        slide(2);
        return false;
      });
      $("#leasing li div").css({ display: "none" });
      $("#leasing li h3").click(function() {
        if($(this).next().css('display') == 'none') {
          $("#leasing .leftCol > li div").slideUp();
          $("#leasing .leftCol").parent().animate({ top: original }, 'slow');
          $("#leasing .leftCol > li").css({ zIndex : 0 });
          $(this).parent().css({ zIndex : 10 });
          $("#leasing .leftCol > li").removeClass("sel");
          $(this).parent().addClass("sel");
          $(this).next().slideDown();
          original = $(this).parent().css('top');
          $("#leasing .leftCol > li:not(.sel)").fadeOut('fast');
          $(this).parent().animate({ top: 0, height: 318 }, 'slow');
          $(this).parent().fadeIn('slow');
        } else {
          $("#leasing .leftCol > li").removeClass("sel");
          $(this).parent().animate({ top: original, height: 33 }, 'slow', function() {
            $("#leasing .leftCol > li").parent().children().fadeIn('fast');
          });
          $("#leasing .leftCol > li div").slideUp();
        }
        return false;
      });
      $("#tree_left").animate({ height: 24, width: 23, top: 560, left: 100 }, 'slow', function() {
        $("#tree_right").animate({ height: 37, width: 38, top: 538, left: 216 }, 'slow', function() {
          $("#cityscape").animate({ height: 137, width: 156, top: 458, left: 100, zIndex: 1 }, 'slow', function() {
            $("#cityscape").animate({ height: 107, top: 478, left: 100 }, 'fast');
          });
        });
      });
    
      $("#sorting a").click(function() {
        $("#sorting a").removeClass('sel');
        $(this).addClass('sel');
        $.get("/ajax/commercial/" + $(this).attr('href'),
          function(data) {
            $("#comList").slideUp().html(data).slideDown();
            $(".new").removeClass("new");
            $(".toHide").removeClass("toHide");
          });
        return false;
      });
      
      $(".view_gallery").fancybox({
          'type'           : 'iframe',
          'changeFade'     : 'fast',
          'width'          : 800,
          'height'         : 500,
          'centerOnScroll' : true
      });
      
      $("#all").click();
      
      
    });
    
    
  </script>
</head>
<body>
  <div id="top">
    <div class="container">
      <img src="images/balloon.png" alt="" id="balloon" class="scroll">
      <h1>Pistilli</h1>
      <a href="http://www.pistilliresidents.com/" id="res_login_tab" class="top_tab" target="_blank">Residential Login</a>
      <a href="/user" id="broker_login_tab" class="top_tab" target="_blank">Broker Login</a>
      <a href="#listings" id="view_listing_tab" class="top_tab">View Listings</a>
      <?php template::yield("home"); ?>
      <?php template::yield("about"); ?>
      <?php template::yield("development"); ?>
      <?php template::yield("commercial"); ?>
      <?php template::yield("move"); ?>
      <?php template::yield("leasing"); ?>  
    </div>
    <?php template::yield("listings"); ?>
    <?php template::yield("contact"); ?>
    <?php template::yield("footer"); ?>
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