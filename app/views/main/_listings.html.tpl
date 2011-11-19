    </div>
    <section id="listings">
      <div id="map_canvas"></div>
      <div class="container">
        <h2>Listings.</h2>
        <nav>
          <a href="#about">About Us</a>
          <a href="#development">Development</a>
          <a href="#commercial">Commercial</a>
          <a href="#move">Move-In &amp; Enjoy</a>
          <a href="#leasing">Leasing Guide</a>
        </nav>
        <form action="/listings" method="get">
          <dl>
            <dt><label for="loc">Location:</label></dt>
            <dd>
              <select name="search[loc]" id="loc" class="big">
                <option>Any</option>
              <? foreach(Location::all() as $location) { ?>
                <option value="<?= $location->id ?>"><?= $location->location ?></option>
              <? } ?>
              </select>
            </dd>
            
            <dt class="left cleft"><label for="bed">Bedrooms:</label></dt>
            <dd class="left cleft">
              <select name="search[bed]" id="bed">
                <option>Any</option>
              <? foreach(Listing::all(array('select' => "DISTINCT(bed)", 'order' => 'bed asc', 'conditions' => 'status_2_id = 4 AND status_1_id != 4')) as $beds) { ?>
                <option><?= $beds->bed ?></option>
              <? } ?>
              </select>
            </dd>
            
            <dt class="right cright"><label for="bath">Bathroom:</label></dt>
            <dd class="right cright">
              <select name="search[bath]" id="bath">
                <option>Any</option>
              <? foreach(Listing::all(array('select' => "DISTINCT(bath)", 'order' => 'bath asc', 'conditions' => 'status_2_id = 4 AND status_1_id != 4')) as $baths) { ?>
                <option><?= $baths->bath ?></option>
              <? } ?>
              </select>
            </dd>
            
            <dt class="left clear"><label for="min">Min Price:</label></dt>
            <dd class="left cleft">
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
            
            <dt class="right cright"><label for="max">Max Price:</label></dt>
            <dd class="right cright">
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
          <div class="clear">
            <input type="submit" name="submit" class="submit" value="Search">
          </div>
        </form>
      </div>
    </section>