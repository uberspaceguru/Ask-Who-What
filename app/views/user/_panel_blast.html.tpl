            <h3>Email Blast <a href="/user/panel/archive" class="live submit" target="_blank">Archive <img src="/images/panel/icons/list.png" alt=""></a></h3>
            <? if(isset($_GET['status'])) {
                 if($_GET['status'] == 'sent') { ?>
            <div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 1em;"> 
    					<p>
    					  <span class="ui-icon ui-icon-info" style="float: left; margin-right: 0.3em; position: absolute;"></span>
    					  <strong style="position: relative; left: 25px;">The email blast has successfully been sent.</strong>
    					</p>
    				</div>
            <? } } ?>
            <form action="/user/panel/<?= ID ?>" method="post" accept-charset="utf-8">
              <dl>
                <dt><label for="from">From</label></dt>
                <dd><input type="text" name="from" id="from" value="Pistilli Realty <noreply@pistilli.com>" disabled="disabled"></dd>
                
                <dt><label for="subject">Subject</label></dt>
                <dd><input type="text" name="subject" id="subject" value="<?= date("Y-m-d") . ": Pistilli Email Blast" ?>" readonly="readonly"></dd>
                
                <dt><label for="body">Body</label></dt>
                <dd>
                  <textarea name="body" id="body" rows="20" cols="80" readonly="readonly">
Dear {name},

Please find the attached Pistilli Listings Blast for the Week of <?= date("Y-m-d") ?> in PDF format. If you are unable to access this file format please visit our online version at http://www.pistilli.com/listings/blast/{id}. You can also always visit our online Broker Login (http://www.pistilli.com/user) to access our Listings, edit your account settings or view past archives at any time.

You are receiving this email because you signed up for the Broker Portal on Pistilli.com or requested to receive listing updates from Pistilli Realty. If you have any questions or concerns please contact us at info@pistilli.com, replying to this email directly will go un-answered.

Pistilli Realty Group
35-01 30th Ave; Suite 300
Astoria, NY 11103
www.pistilli.com

Phone:  718-204-1600
Fax:    800-590-1317
Toll:   800-381-7042


To unsubscribe, please click the following link: http://www.pistilli.com/user/unsubscribe/{user_id}/{sha1}
                  </textarea>
                </dd>
              </dl>
              <div>
                <input type="submit" class="submit send" id="blast_send" value="Send">
              </div>
            </form>