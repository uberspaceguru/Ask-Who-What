
        <style>

            /* Demo styles */
            html,body{background:#ededed;margin:0;}
            .content{color:#777;font:12px/1.4 "helvetica neue",arial,sans-serif;width:800px;margin:0 auto;}
            h1{font-size:12px;font-weight:normal;color:#ddd;margin:0;}
            p{margin:0 0 20px}
            a {color:#22BCB9;text-decoration:none;}
            .cred{margin-top:20px;font-size:11px;}

            /* This rule is read by Galleria to define the gallery height: */
            #galleria{height:500px}

        </style>

        <?php echo template::include_javascripts(array('gallery')) ?>
    <div class="content">

        <!-- Adding gallery images. We use resized thumbnails here for better performance, but it’s not necessary -->

        <div id="galleria">
<? foreach(Photo::all(array('order' => 'sort asc')) as $photo) { ?>
            <a href="<?= getGalleryPhoto($photo->id, $photo->ext) ?>">
            	<img title="<?= $photo->name ?>"
            	     alt="<?= $photo->desc ?>"
            	     src="<?= getGalleryPhoto($photo->id, $photo->ext) ?>">
        	</a>
<? } ?>
        </div>

    </div>

    <script type="text/javascript">

    // Load the classic theme
	Galleria.loadTheme('/public/javascripts/galleria/themes/classic/galleria.classic.min.js');

	// Initialize Galleria
	$('#galleria').galleria();

    </script>