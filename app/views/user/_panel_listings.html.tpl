<? if(!isset($_GET['sid'])) { ?>
            <h3>Manage Listings <a href="/listings" class="live submit" target="_blank">Preview <img src="/images/panel/icons/eye.png" alt=""></a></h3>
            <a class="new" href="/user/panel/listings/new">Add New <img src="/images/panel/icons/new.png" alt="New"></a>
            <input type="text" class="search" placeholder="Search">
            <div class="right" style="padding: 11px">
              <select id="sorter" class="single">
                <option <?= selected($user->listing_filter, 'All') ?>>All</option>
                <option <?= selected($user->listing_filter, 'Blast') ?>>Blast</option>
                <option <?= selected($user->listing_filter, 'Active') ?>>Active</option>
                <option <?= selected($user->listing_filter, 'Offline') ?>>Offline</option>
              </select>
            </div>
            <table style="width: 100%;" id="listings">
              <thead>
                <tr>
                  <th class="nobleft">Address</th>
                  <th>Neighborhood/Location</th>
                  <th>Price</th>
                  <th class="nobright listopt">Options</th>
                </tr>
              </thead>
              <tbody>
              <? foreach($listings as $listing) { ?>
                <tr class="<?= cycle("odd", "even") ?>" id="listing_<?= $listing->id ?>">
                  <td class="nobleft"><?= $listing->property->address ?> (<?= $listing->apt_num ?>)</td>
                  <td><?= $listing->property->neighborhood->neighborhood ?> &#151; <?= $listing->property->neighborhood->location->location ?></td>
                  <td><?= money_format('%(.0n', $listing->price) ?></td>
                  <td class="smallpad nobright">
                    <a href="/user/panel/listings/<?= $listing->id ?>">Edit <img src="/images/panel/icons/edit.png" alt="Edit"></a>
                    <a href="/user/panel/listings/<?= $listing->id ?>" rel="<?= $listing->id ?>" class="list_avail">Availability
                      <? if($listing->avail) { ?>
                        <img src="/images/panel/icons/checked.png" alt="Available">
                      <? } else { ?>
                        <img src="/images/panel/icons/unchecked.png" alt="Unavailable">
                      <? } ?>
                    </a>
                    <a href="/user/panel/listings/<?= $listing->id ?>" rel="<?= $listing->id ?>" class="listing_del">Delete <img src="/images/panel/icons/delete.png" alt="Delete"></a>
                  </td>
                </tr>
              <? } ?>
              </tbody>
            </table>
<? } else if(is_numeric($_GET['sid'])) { ?>
            <h3>Edit Listing <a href="/listings/<?= $_GET['sid'] ?>" class="live submit" target="_blank">Preview <img src="/images/panel/icons/eye.png" alt=""></a></h3>
            <form action="/user/panel/<?= ID ?>/<?= $_GET['sid'] ?>" method="post" enctype="multipart/form-data" accept-charset="utf-8">
              <dl>
                <dt><label for="property">Property</label></dt>
                <dd>
                  <select id="property" name="property_id" class="single">
<? foreach(Neighborhood::all(array('order' => 'neighborhood asc')) as $hood) { ?>
                    <optgroup label="<?= $hood->neighborhood ?>">
<? foreach(Property::all(array('conditions' => 'neighborhood_id = ' . $hood->id)) as $property) { ?>
                      <option value="<?= $property->id ?>" <?= selected($listing->property_id, $property->id) ?>><?= $property->address ?></option>
<? } ?>
                    </optgroup>
<? } ?>
                  </select>
                </dd>
                
                <dt><label for="floor">Floor</label></dt>
                <dd><input type="text" name="floor" id="floor" value="<?= $listing->floor ?>"></dd>
                
                <dt><label for="apt_num">Apartment Number</label></dt>
                <dd><input type="text" name="apt_num" id="apt_num" value="<?= $listing->apt_num ?>"></dd>
                
                <dt><label for="price">Price</label></dt>
                <dd><input type="text" name="price" id="price" value="<?= $listing->price ?>"></dd>
                
                <dt><label for="bed">Bed</label></dt>
                <dd><input type="text" name="bed" id="bed" value="<?= $listing->bed ?>"></dd>
                
                <dt><label for="bath">Bath</label></dt>
                <dd><input type="text" name="bath" id="bath" value="<?= $listing->bath ?>"></dd>
                
                <dt><label for="sqft">Sq. Ft.</label></dt>
                <dd><input type="text" name="sqft" id="sqft" value="<?= $listing->sqft ?>"></dd>
                
                <dt><label for="size">Size</label></dt>
                <dd><input type="text" name="size" id="size" value="<?= $listing->size ?>"></dd>
                
                <dt><label for="floorplan">Floorplan</label></dt>
                <dd><input type="file" name="file" id="floorplan"></dd>
                
                <dt><label for="specs">Specifications</label></dt>
                <dd>
                  <div>
                    <input type="text" id="newItem" style="margin: 0 10px 0 0;">
                    <select id="specs" name="specs[]" multiple="multiple" class="addable">
<? foreach(ListingSpec::all() as $spec) { ?>
                      <option value="<?= $spec->id ?>" <?= selectedMult($listing->specs, $spec->id) ?>><?= $spec->spec ?></option>
<? } ?>
                    </select><br>
                    <input type="button" id="add" value="Add" style="margin: 5px 0 0; float: none;" class="create submit">
                  </div>
                </dd>
                
                <dt><label for="status1">Status 1</label></dt>
                <dd>
                  <select id="status1" name="status_1_id" class="single">
<? foreach(Status1::all() as $status) { ?>
                    <option value="<?= $status->id ?>" <?= selected($listing->status_1_id, $status->id) ?>><?= $status->status ?></option>
<? } ?>
                  </select>
                </dd>
                <dt><label for="status2">Status 2</label></dt>
                <dd>
                  <select id="status2" name="status_2_id" class="single">
<? foreach(Status2::all() as $status) { ?>
                    <option value="<?= $status->id ?>" <?= selected($listing->status_2_id, $status->id) ?>><?= $status->status ?></option>
<? } ?>
                  </select>
                </dd>
<? /*
                <dt><label for="ready_yes">Ready</label></dt>
                <dd>
                  <a href="/user/panel/listings/<?= $listing->id ?>" id="ready_yes" rel="<?= $listing->id ?>" class="list_ready pgchk">Ready
                    <? if($listing->ready) { ?>
                      <img src="/images/panel/icons/checked.png" alt="Ready">
                    <? } else { ?>
                      <img src="/images/panel/icons/unchecked.png" alt="Not Ready">
                    <? } ?>
                  </a>
                </dd>
                
<? if($user->level_id == 4) { ?>
                <dt><label for="hold_yes">Hold</label></dt>
                <dd>
                  <a href="/user/panel/listings/<?= $listing->id ?>" id="hold_yes" rel="<?= $listing->id ?>" class="list_hold pgchk">Hold
                    <? if($listing->hold) { ?>
                      <img src="/images/panel/icons/checked.png" alt="On Hold">
                    <? } else { ?>
                      <img src="/images/panel/icons/unchecked.png" alt="Off Hold">
                    <? } ?>
                  </a>
                </dd>
<? } ?>
*/ ?>
                <dt><label for="avail_yes">Available</label></dt>
                <dd>
                  <a href="/user/panel/listings/<?= $listing->id ?>" id="avail_yes" rel="<?= $listing->id ?>" class="list_avail pgchk">Availability
                    <? if($listing->avail) { ?>
                      <img src="/images/panel/icons/checked.png" alt="Available">
                    <? } else { ?>
                      <img src="/images/panel/icons/unchecked.png" alt="Unavailable">
                    <? } ?>
                  </a>
                  <input type="text" class="left" style="padding: 3px 0 2px 6px; margin: 0 0 0 10px;" id="date" name="avail" value="<? if($listing->avail != 1 && $listing->avail != 0) echo date("m/d/Y", $listing->avail) ?>">
                </dd>
              </dl>
              <div>
                <input type="submit" class="submit save" value="Save">
                <a class="submit finish" href="/user/panel/<?= ID ?>">Finish <img src="/images/panel/icons/finish.png" alt=""></a>
              </div>
            </form>
<? } else if($_GET['sid'] == 'new') { ?>
            <h3>Create New Listing</h3>
            <form action="/user/panel/<?= ID ?>/<?= $_GET['sid'] ?>" method="post" enctype="multipart/form-data" accept-charset="utf-8">
              <dl>
                <dt><label for="property">Property</label></dt>
                <dd>
                  <select id="property" name="property_id" class="single">
<? foreach(Neighborhood::all(array('order' => 'neighborhood asc')) as $hood) { ?>
                    <optgroup label="<?= $hood->neighborhood ?>">
<? foreach(Property::all(array('conditions' => 'neighborhood_id = ' . $hood->id)) as $property) { ?>
                      <option value="<?= $property->id ?>"><?= $property->address ?></option>
<? } ?>
                    </optgroup>
<? } ?>
                  </select>
                </dd>
                
                <dt><label for="floor">Floor</label></dt>
                <dd><input type="text" name="floor" id="floor"></dd>
                
                <dt><label for="apt_num">Apartment Number</label></dt>
                <dd><input type="text" name="apt_num" id="apt_num"></dd>
                
                <dt><label for="price">Price</label></dt>
                <dd><input type="text" name="price" id="price"></dd>
                
                <dt><label for="bed">Bed</label></dt>
                <dd><input type="text" name="bed" id="bed"></dd>
                
                <dt><label for="bath">Bath</label></dt>
                <dd><input type="text" name="bath" id="bath"></dd>
                
                <dt><label for="sqft">Sq. Ft.</label></dt>
                <dd><input type="text" name="sqft" id="sqft"></dd>
                
                <dt><label for="size">Size</label></dt>
                <dd><input type="text" name="size" id="size"></dd>
                
                <dt><label for="floorplan">Floorplan</label></dt>
                <dd><input type="file" name="file" id="floorplan"></dd>
                
                <dt><label for="specs">Specifications</label></dt>
                <dd>
                  <div>
                    <input type="text" id="newItem" style="margin: 0 10px 0 0;">
                    <select id="specs" name="specs[]" multiple="multiple" class="addable">
<? foreach(ListingSpec::all() as $spec) { ?>
                      <option value="<?= $spec->id ?>"><?= $spec->spec ?></option>
<? } ?>
                    </select><br>
                    <input type="button" id="add" value="Add" style="margin: 5px 0 0; float: none;" class="create submit">
                  </div>
                </dd>
                
                <dt><label for="status1">Status 1</label></dt>
                <dd>
                  <select id="status1" name="status_1_id" class="single">
<? foreach(Status1::all() as $status) { ?>
                    <option value="<?= $status->id ?>"><?= $status->status ?></option>
<? } ?>
                  </select>
                </dd>
                <dt><label for="status2">Status 2</label></dt>
                <dd>
                  <select id="status2" name="status_2_id" class="single">
<? foreach(Status2::all() as $status) { ?>
                    <option value="<?= $status->id ?>"><?= $status->status ?></option>
<? } ?>
                  </select>
                </dd>
                
<? /*
                
                <dt><label for="ready_yes">Ready</label></dt>
                <dd>
                  <div>
                    <input type="radio" name="ready" id="ready_yes" checked="checked"> <label for="ready_yes">Yes</label><br>
                    <input type="radio" name="ready" id="ready_no"> <label for="ready_no">No</label>
                  </div>
                </dd>
*/ ?>
                <dt><label for="avail_yes">Available</label></dt>
                <dd>
                  <div>
                    <input type="radio" name="avail" id="avail_yes" checked="checked"> <label for="avail_yes">Yes</label><br>
                    <input type="radio" name="avail" id="avail_no"> <label for="avail_no">No</label>
                  </div>
                  <input type="text" class="left" style="margin: 5px 0 0;" id="date" name="dateAvail">
                </dd>
              </dl>
              <div>
                <input type="submit" class="submit create" value="Create">
              </div>
            </form>
<? } ?>