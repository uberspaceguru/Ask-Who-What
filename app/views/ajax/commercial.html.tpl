<? foreach($listings as $listing) { ?>
          <li class="listing new toHide">
            <div class="leftCol">
              <img src="/public/commercial/<?= $listing->id ?>/<?= $listing->firstImg() ?>" alt="Temp" class="left">
              <div class="left">
                <h3><?= $listing->getComtype(); ?></h3>
                <h4><?= $listing->address ?> <small>(<?= $listing->neighborhood->neighborhood ?>)</small></h4>
                <ul>
<? foreach(nl2array($listing->desc) as $desc) { ?>
                  <li><?= $desc ?>
<? } ?>
                </ul>
              </div>
            </div>
            <div class="box">
              <a href="/ajax/comGal/<?= $listing->id ?>" class="cam view_gallery">View Space Photos</a>
              <p>Contact Us<br /><strong><?= $listing->contact ?></strong></p>
            </div>
            <div class="clear"></div>
<? if($listings[count($listings)-1] == $listing && $next) { ?>
            <a href="/ajax/commercial/<?= $_GET['id'] ?>/<?= $next ?>" class="load_more">Load More</a>
<? } ?>
<? if($_GET['sid'] > 1) { ?>
            <a href="/ajax/commercial/<?= $_GET['id'] ?>" class="clean">Collapse</a>
<? } ?>
          </li>
<? } ?>
<script type="text/javascript">
  $(".view_gallery").fancybox({
      'type'           : 'iframe',
      'changeFade'     : 'fast',
      'width'          : 800,
      'height'         : 500,
      'centerOnScroll' : true
  });
      
  $(".clean").click(function() {
    $.get($(this).attr('href'),
      function(data) {
        $(".clean").slideUp();
        $(".toHide").slideUp(function() {
          $("#comList").html(data);
          $(".load_more").hide().slideDown();
          $(".new").removeClass("new");
          $(".toHide").removeClass("toHide");
        });
      });
    return false;
  });
      
  $(".load_more").click(function() {
    $.get($(this).attr('href'),
      function(data) {
        $(".load_more").slideUp( function() { $(this).remove(); });
        $("#comList").append(data);
        $(".new").hide().slideDown();
        $(".new").removeClass("new");
      });
    return false;
  });
  
</script>