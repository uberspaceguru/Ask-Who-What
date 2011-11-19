<? if(!isset($_GET['sid'])) { ?>
            <h3>Wizard <small>Step 1: Create New Property</small></h3>
            <form action="/user/panel/<?= ID ?>/2" method="post" accept-charset="utf-8">
              <dl>
                <dt><label for="neighborhood">Neighborhood</label></dt>
                <dd>
                  <div>
                    <select id="neighborhood" name="neighborhood_id" class="single">
<? foreach(Location::all(array('order' => 'location asc')) as $loc) { ?>
                      <optgroup label="<?= $loc->location ?>">
<? foreach(Neighborhood::all(array('conditions' => 'location_id = ' . $loc->id)) as $hood) { ?>
                        <option value="<?= $hood->id ?>"><?= $hood->neighborhood ?></option>
<? } ?>
                      </optgroup>
<? } ?>
                    </select><br>
                  </div>
                </dd>
                
                <dt><label for="address">Address</label></dt>
                <dd><input type="text" name="address" id="address"></dd>
                
                <dt><label for="file_upload">Pictures</label></dt>
                <dd><input id="file_upload" name="file_upload" type="file" /></dd>
                
                <dt><label for="specs">Specifications</label></dt>
                <dd>
                  <div>
                    <input type="text" id="newItem" style="margin: 0 10px 0 0;">
                    <select id="specs" name="specs[]" multiple="multiple" class="addable">
<? foreach(PropertySpec::all() as $spec) { ?>
                      <option value="<?= $spec->id ?>"><?= $spec->spec ?></option>
<? } ?>
                    </select><br>
                    <input type="button" id="add" value="Add" style="margin: 5px 0 0; float: none;" class="create submit">
                  </div>
                </dd>
                
                <dt><label for="desc">Description</label></dt>
                <dd><textarea name="desc" id="desc" rows="5" cols="80"></textarea></dd>
                
                <dt><label for="amenities">Amenities</label></dt>
                <dd>
                  <select id="amenities" name="amenities[]" class="multiple" multiple="multiple">
                    <option value="elevator">Elevator</option>
                    <option value="laundry">Laundry</option>
                    <option value="parking">Parking</option>
                    <option value="doorman">Doorman</option>
                    <option value="gas">Free Gas</option>
                    <option value="utilities">All Utilities</option>
                  </select>
                </dd>
                
                <dt><label for="super">Super</label></dt>
                <dd>
                  <textarea name="super" id="super"></textarea>
                </dd>
              </dl>
              <div>
                <input type="submit" class="submit next" value="Next">
              </div>
            </form>
<? } else if($_GET['sid'] == 2) { ?>
            <h3 class="noborder">Wizard <small>Step 2: Create Listings</small> <a href="#" class="live submit" id="add_row">Add <img src="/images/panel/icons/add.png" alt=""></a></h3>
            <form action="/user/panel/<?= ID ?>/finish" method="post" accept-charset="utf-8">
              <table class="wiz" style="width: 100%;">
                <thead>
                  <tr>
                    <th>Floor</th>
                    <th>Apt</th>
                    <th>Price</th>
                    <th>Bed</th>
                    <th>Bath</th>
                    <th>Sqft</th>
                    <th>Size</th>
                    <th>Floorplan</th>
                    <th style="width: 60px;">Specs</th>
                    <th style="width: 112px;">Status 1</th>
                    <th style="width: 112px;">Status 2</th>
                    <th style="width: 60px;">Available</th>
                  </tr>
                </thead>
                <tbody id="rows">
                  <tr class="odd">
                    <td><input type="text" name="wizard2[0][floor]"></td>
                    <td><input type="text" name="wizard2[0][apt_num]"></td>
                    <td><input type="text" name="wizard2[0][price]" style="width: 30px;"></td>
                    <td><input type="text" name="wizard2[0][bed]"></td>
                    <td><input type="text" name="wizard2[0][bath]"></td>
                    <td><input type="text" name="wizard2[0][sqft]" style="width: 30px;"></td>
                    <td><input type="text" name="wizard2[0][size]"></td>
                    <td>
                      <input type="file" name="wizard2[0][file]" class="hidden">
                      <button type="button" class="for_floor">Browse</button>
                    </td>
                    <td>
                      <div class="specs">
                        <input type="text" id="newItem" style="margin: 0 10px 0 0;">
                        <select id="specs" name="wizard2[0][specs][]" multiple="multiple" class="addable">
  <? foreach(ListingSpec::all() as $spec) { ?>
                          <option value="<?= $spec->id ?>"><?= $spec->spec ?></option>
  <? } ?>
                        </select><br>
                        <input type="button" value="Add" id="add" style="margin: 5px 0 0; float: none;" class="create submit">
                      </div>
                      <button type="button" class="add_specs">Specs</button>
                    </td>
                    <td class="status_1">
                      <select name="wizard2[0][status_1_id]" class="single">
<? foreach(Status1::all() as $status) { ?>
                        <option value="<?= $status->id ?>"><?= $status->status ?></option>
<? } ?>
                      </select>
                    </td>
                    <td>
                      <select name="wizard2[0][status_2_id]" class="single">
<? foreach(Status2::all() as $status) { ?>
                        <option value="<?= $status->id ?>"><?= $status->status ?></option>
<? } ?>
                      </select>
                    </td>
                    <td>
                      <div class="avail hidden">
                        <input type="checkbox" name="wizard2[0][avail]" checked="checked" id="avail0">
                        <input type="text" class="left" style="margin: 5px 0 0;" id="date0" name="wizard2[0][dateAvail]">
                      </div>
                      <button type="button" class="avail_check">Availability</button>
                      <button type="button" class="calendar">Calendar</button>
                      <div class="calcont"></div>
                    </td>
                  </tr>
                </tbody>
              </table>
              <div style="padding: 0;">
                <input type="hidden" name="property_id" value="<?= $property->id ?>">
                <input type="submit" class="submit save left" value="Finish">
              </div>
            </form>
            <div id="trans"></div>
<? } ?>