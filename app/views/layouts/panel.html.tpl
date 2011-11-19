<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Pistilli Realty | NYC Residential &amp; Commerical Real Estate</title>
  <meta name="description" content="The Pistilli Realty group has built its group of New York rentals on quality customer service and family values.">
  <meta name="keywords" content="rentals, condos, apartments">
  <?php echo template::include_stylesheets(array('reset', 'panel')) ?>
  <?php echo template::include_javascripts(array('panel')) ?>
  <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
  <script type="text/javascript">
  $(function() {
    var rowNum = 1;
    var current = 'odd';
    $(".file_del").click(function() {
      if(confirm("Are you sure you want to delete this file?\n\n* This is a permanent change and cannot be reversed.")) {
        var rel = $(this).attr('rel');
        var row = $("#file_" + rel);
        $.get("/ajax/delFile/" + rel, function() {
          row.remove();
        });
      }
      return false;
    });
    $(".photo_del").click(function() {
      if(confirm("Are you sure you want to delete this photo?\n\n* This is a permanent change on the database and cannot be reversed.")) {
        var rel = $(this).attr('rel');
        var row = $("#photo_" + rel);
        $.get("/ajax/delPhoto/" + rel, function() {
          row.remove();
        });
      }
      return false;
    });
    $(".prop_del").click(function() {
      if(confirm("Are you sure you want to delete this property?\n\n* This is a permanent change on the database and cannot be reversed.")) {
        var rel = $(this).attr('rel');
        var row = $("#prop_" + rel);
        $.get("/ajax/delProp/" + rel, function() {
          row.remove();
        });
      }
      return false;
    });
    $(".com_listing_del").click(function() {
      if(confirm("Are you sure you want to delete this listing?\n\n* This is a permanent change on the database and cannot be reversed.")) {
        var rel = $(this).attr('rel');
        var row = $("#com_listing_" + rel);
        $.get("/ajax/delComListing/" + rel, function() {
          row.remove();
        });
      }
      return false;
    });
    $(".listing_del").click(function() {
      if(confirm("Are you sure you want to delete this listing?\n\n* This is a permanent change on the database and cannot be reversed.")) {
        var rel = $(this).attr('rel');
        var row = $("#listing_" + rel);
        $.get("/ajax/delListing/" + rel, function() {
          row.remove();
        });
      }
      return false;
    });
    $(".user_del").click(function() {
      if(confirm("Are you sure you want to delete this user?\n\n* This is a permanent change on the database and cannot be reversed.")) {
        var rel = $(this).attr('rel');
        var row = $("#user_" + rel);
        $.get("/ajax/delUser/" + rel, function() {
          row.remove();
        });
      }
      return false;
    });
    $("#blast_send").click(function() {
      if(!confirm("Are you sure you'd like to send a blast?"))
        return false;
      return true;
    });
    $(".com_list_avail").click(function() {
      var rel = $(this).attr('rel');
      var img = $("img", this);
      $.get("/ajax/comListAvail/" + rel, function(data) {
        img.attr('src', data);
      });
      return false;
    });
    $(".blast_me").click(function() {
      var rel = $(this).attr('rel');
      var img = $("img", this);
      $.get("/ajax/blastMe", function(data) {
        img.attr('src', data);
      });
      return false;
    });
    $(".list_ready").click(function() {
      var rel = $(this).attr('rel');
      var img = $("img", this);
      $.get("/ajax/listReady/" + rel, function(data) {
        img.attr('src', data);
      });
      return false;
    });
    $(".list_avail").click(function() {
      var rel = $(this).attr('rel');
      var img = $("img", this);
      $.get("/ajax/listAvail/" + rel, function(data) {
        img.attr('src', data);
      });
      return false;
    });
    $(".list_hold").click(function() {
      var rel = $(this).attr('rel');
      var img = $("img", this);
      $.get("/ajax/listHold/" + rel, function(data) {
        img.attr('src', data);
      });
      return false;
    });
<? if(isset($_GET['sid'])) { ?>
    $(".delX").click(function() {
      var img = $(this).prev();
      var src = img.attr('src');
      $.post("/ajax/delFile", "src=" + src, function(data) {
        img.parent().remove();
        var order = $(".reorder").sortable("serialize");
<? if($_GET['id'] == 'commercial') { ?>
        $.post("/ajax/comGalOrder/<?= $_GET['sid'] ?>", order);
<? } else if($_GET['id'] == 'properties') { ?>
        $.post("/ajax/propGalOrder/<?= $_GET['sid'] ?>", order);
<? } ?>
      });
      return false;
    });
<? } ?>
    $(".receive_blast").click(function() {
      var rel = $(this).attr('rel');
      var img = $("img", this);
      $.get("/ajax/blast/" + rel, function(data) {
        img.attr('src', data);
      });
      return false;
    });
    $("#sorter").change(function() {
      $("#listings").load("/ajax/filterListings/" + $("#sorter option:selected").text());
    });
    $(".suspend").click(function() {
      var rel = $(this).attr('rel');
      var img = $("img", this);
      $.get("/ajax/suspend/" + rel, function(data) {
        img.attr('src', data);
      });
      return false;
    });
    $(".for_floor").live('click', function() {
      $(this).prev().click();
      return false;
    });
    $(".add_specs").live('click', function() {
      $(this).prev().fadeIn();
      $("#trans").fadeTo(400, .3);
      return false;
    });
    $(".calendar").live('click', function() {
      $('#ui-datepicker-div').appendTo($(this).next());
      $(this).parent().children(".avail").children("input[type=text]").focus();
    });
    $(".avail_check").live('click', function() {
      $check = $(this).parent().children(".avail").children("input[type=checkbox]");
      $check.click();
      if($check.attr('checked') == 'checked')
        $(this).removeClass('unchecked');
      else
        $(this).addClass('unchecked');
    });
    $("#add_row").click(function() {
      if(current == 'odd')
        current = 'even';
      else
        current = 'odd';
      $.get("/ajax/newRow?class=" + current + "&rowNum=" + rowNum++, function(data) {
        $("#rows").append(data);
      });
      return false;
    });
    $("#trans").click(function() {
      $(this).fadeOut();
      $(".specs").fadeOut();
    });
    $('input.search').quicksearch('table tbody tr');
    $.tablesorter.defaults.widgets = ['zebra']; 
    $("table").tablesorter({
<? if(ID == 'listings' || ID == 'properties') { ?>
     sortList: [[1,0]]
<? } ?>
    });
    $("select.single").multiselect({
      header: false,
      multiple: false,
      selectedList: 1
    }).multiselectfilter();
    $("select.multiple").multiselect();
    $(' [placeholder] ').defaultValue();

    $(".specs").addClass(function() {
      return $(this).parent().parent().attr('class');
    });

  	var el = $(".addable").multiselect().multiselectfilter(),
		disabled = $('#disabled'),
		selected = $('#selected'),
		newItem = $('#newItem');
		
		$("#newItem").keypress(function(e) {
      if(e.keyCode == 13) {
        addTo();
        return false;
      }
    });

		
		function addTo() {
		  if(newItem.val().trim() != '') {
    		var v = newItem.val(), opt = $('<option />', {
    			value: v,
    			text: v
    		});
		
    		opt.attr('selected','selected');
		
    		opt.appendTo( el );
    		newItem.val("");
		
    		el.multiselect('refresh');
    	}
  	}
	  
  	$("#add").click(function(){
  	  addTo();
  	});
  	
  	$('#file_upload').uploadify({
      'uploader'        : '/javascripts/uploadify/uploadify.swf',
      'script'          : '/javascripts/uploadify/uploadify.php',
      'cancelImg'       : '/javascripts/uploadify/cancel.png',
      'folder'          : '/public/public/temp/',
      'removeCompleted' : false,
      'multi'           : true,
      'auto'            : true,
    });
<? if(isset($_GET['sid']) && $_GET['id'] == 'commercial') { ?>
    $('ol.reorder, ul.reorder').sortable({
      update: function() {
        var order = $(this).sortable("serialize");
        $.post("/ajax/comGalOrder/<?= $_GET['sid'] ?>", order);
      }
    });
<? } ?>
<? if(isset($_GET['sid']) && $_GET['id'] == 'properties') { ?>
    $('ol.reorder, ul.reorder').sortable({
      update: function() {
        var order = $(this).sortable("serialize");
        $.post("/ajax/propGalOrder/<?= $_GET['sid'] ?>", order);
      }
    });
<? } ?>
    $('table.reorder').tableDnD({
      onDrop: function(table, row) {
        var rows = table.tBodies[0].rows;
        var order = new Array();
        for (var i = 0; i < rows.length; i++) {
          order[i] = rows[i].id;
        }
        order = JSON.stringify(order);
        $("table.reorder tr").removeClass('even');
        $("table.reorder tr").removeClass('odd');
        $("table.reorder tr:even").addClass('even');
        $("table.reorder tr:odd").addClass('odd');
	      $.ajax({
          type: "POST",
          url: "/ajax/galleryOrder",
          data: 'order=' + order
        });
	    }
    });
    
    $('#date, #date0').datepicker();
    
    $('#recent').scrollExtend({	
      	'target': 'ul#recentList',
      	'url': '/ajax/recent/',
      	'inc': 0
    });
    $('#recent').onScrollBeyond(function() {
      if($('#noneLeft').length > 0) {
        $('#recent').scrollExtend('disable');
      }
    });
    $('#load_more').click(function() {
      if($('#noneLeft').length > 0) {
        $('#recent').scrollExtend('disable');
      }
    });
  });
  </script>
</head>
<body>
  <div id="top">
    <header class="container">
      <h1 class="left"><a href="/user/panel">Pistilli</a></h1>
      <a href="/user/logout" id="signout" class="right">Sign Out <img src="/images/panel/icons/right_arrow.png" alt=""></a>
      <p class="right">Welcome to the Empire CMS | <a href="/user/panel/settings"><?= $user->name ?></a></p>
    </header>
    <div class="container">
      <section id="panel">
        <div id="left">
          <h3 id="empcms"><a href="/user/panel">Empire Studios CMS</a></h3>
          <div id="weather" style="padding: 10px 0 0 1px;">
            <iframe src="http://weather.weatherbug.com/Corporate/Products/Stickers/v2/Samples/Live_125x125.aspx?zipcode=11102&amp;cityname=Astoria"></iframe>
          </div>
        </div>
        <div id="right">
          <h2>Admin Control Panel</h2>
          <nav>
            <ul id="tabs">
<? if($user->level_id == 4) { ?>
              <li><a href="/user/panel/archive" <?= selId('archive') ?>>Blast Archive</a></li>
<? } else { ?>
              <li><a href="/user/panel/properties" <?= selId('properties') ?>>Manage Properties</a></li>
              <li><a href="/user/panel/listings" <?= selId('listings') ?>>Manage Listings</a></li>
              <li><a href="/user/panel/commercial" <?= selId('commercial') ?>>Commercial Listings</a></li>
<? if($user->level_id == 1) { ?>
              <li><a href="/user/panel/brokers" <?= selId('brokers') ?>>Manage Brokers</a></li>
<? } ?>
              <li><a href="/user/panel/blast" id="blast" <?= selId('blast') ?>>Email Blast</a></li>
<? if($user->level_id == 1) { ?>
              <li><a href="/user/panel/users" <?= selId('users') ?>>Manage Users</a></li>
<? } ?>
<? if($user->level_id < 3) { ?>
              <li><a href="/user/panel/website" <?= selId('website') ?>>Website</a></li>
<? } ?>
<? } ?>
              <li><a href="/user/panel/settings" <?= selId('settings') ?>>Settings</a></li>
            </ul>
          </nav>
          <?php template::yield("panel_" . ID, get_defined_vars()); ?>
        </div>
      </section>
      <footer>
        <a href="http://www.empirestudios.net/" title="Empire Design Studios" id="copyright">Copyright &copy;2011 Empire Design Studios. All Rights Reserved.</a> 
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