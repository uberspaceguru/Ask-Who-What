
          <p class="gen reg">If you have a question, we would love to hear from you. </p>
          <p class="more reg">To email us, please fill out the form below, or call our office directly.</p>
          <div class="ui-widget">
<? if($passed) { ?>
    				<div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 1em;"> 
    					<p>
    					  <span class="ui-icon ui-icon-info" style="float: left; margin-right: 0.3em; position: absolute;"></span>
    					  <strong style="position: relative; left: 25px;"><?= $message; ?></strong>
    					</p>
    				</div>
<? } else { ?>
    				<div class="ui-state-error ui-corner-all" style="padding: 1em;"> 
    					<p>
    					  <span class="ui-icon ui-icon-alert" style="float: left; margin-right: 0.3em;"></span> 
    					  <strong><?= $message; ?></strong>
    					</p>
    				</div>
<? } ?>
          </div>
<? if(!$passed) { ?>
          <form action="/" method="post" accept-charset="utf-8" id="contact_form">
            <dl>
              <dt><label for="name">Your Name</label></dt>
              <dd><input type="text" name="contact[name]" id="name" value="<?= $_POST['contact']['name'] ?>"></dd>
              
              <dt><label for="email">Email</label></dt>
              <dd><input type="text" name="contact[email]" id="email" value="<?= $_POST['contact']['email'] ?>"></dd>
              
              <dt><label for="subject">Subject</label></dt>
              <dd><input type="text" name="contact[subject]" id="subject" value="<?= $_POST['contact']['subject'] ?>"></dd>
              
              <dt><label for="message">Message</label></dt>
              <dd><textarea name="contact[message]" id="message" rows="8" cols="40"><?= $_POST['contact']['message'] ?></textarea></dd>
            </dl>
            <div>
              <input type="submit" name="send" value="Send">
            </div>
          </form>
<? } ?>