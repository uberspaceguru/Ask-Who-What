<? if(!isset($_GET['sid'])) { ?>
            <h3>Manage Properties</h3>
            <a class="new left" href="/user/panel/properties/new">Add New <img src="/images/panel/icons/new.png" alt="New"></a>
            <a class="new cnone" style="margin-left: 10px;" href="/user/panel/neighborhoods/new">Add Neighborhood <img src="/images/panel/icons/new.png" alt="New"></a>
            <input type="text" class="search" placeholder="Search">
            <table style="width: 100%;">
              <thead>
                <tr>
                  <th class="nobleft">Address</th>
                  <th>Neighborhood/Location</th>
                  <th class="nobright opt">Options</th>
                </tr>
              </thead>
              <tbody>
              <? foreach($properties as $property) { ?>
                <tr class="<?= cycle("odd", "even") ?>" id="prop_<?= $property->id ?>">
                  <td class="nobleft"><?= $property->address ?></td>
                  <td><?= $property->neighborhood->neighborhood ?> &#151; <?= $property->neighborhood->location->location ?></td>
                  <td class="smallpad nobright">
                    <a href="/user/panel/properties/<?= $property->id ?>">Edit <img src="/images/panel/icons/edit.png" alt="Edit"></a>
                    <a href="/user/panel/properties/<?= $property->id ?>" rel="<?= $property->id ?>" class="prop_del">Delete <img src="/images/panel/icons/delete.png" alt="Delete"></a>
                  </td>
                </tr>
              <? } ?>
              </tbody>
            </table>
<? } else if(is_numeric($_GET['sid'])) { ?>
            <h3>Edit Property <a href="/listings?property_id=<?= $property->id ?>" class="live submit" target="_blank">Preview <img src="/images/panel/icons/eye.png" alt=""></a></h3>
            <?= @$error_messages ?>
            <form action="/user/panel/<?= ID ?>/<?= $_GET['sid'] ?>" method="post" accept-charset="utf-8">
              <dl>
                <dt><label for="neighborhood">Neighborhood</label></dt>
                <dd>
                  <div>
                    <select id="neighborhood" name="neighborhood_id" class="single">
<? foreach(Location::all(array('order' => 'location asc')) as $loc) { ?>
                      <optgroup label="<?= $loc->location ?>">
<? foreach(Neighborhood::all(array('conditions' => 'location_id = ' . $loc->id)) as $hood) { ?>
                        <option value="<?= $hood->id ?>" <?= selected($property->neighborhood_id, $hood->id) ?>><?= $hood->neighborhood ?></option>
<? } ?>
                      </optgroup>
<? } ?>
                    </select><br>
                  </div>
                </dd>
                
                <dt><label for="address">Address</label></dt>
                <dd><input type="text" name="address" id="address" value="<?= $property->address ?>"></dd>
                
                <dt><label for="file_upload">Pictures</label></dt>
                <dd>
                  <small style="float: right;">* Please save the listing to complete the upload procedure.</small>
                  <input id="file_upload" name="file_upload" type="file" />
                  <ol class="reorder">
<? $i = 0; foreach(@filesIn(PUB_ROOT . '/public/properties/' . $_GET['sid']) as $file) { $i++; ?>
                    <li id="file_<?= $i ?>">
                      <img src="<?= '/public/properties/' . $_GET['sid'] . '/' . $file ?>?<?= time() ?>" alt="" class="thumb">
                      <a href="/delFile" class="delX">Delete</a>
                    </li>
<? } ?>
                  </ol>
                </dd>
                
                <dt><label for="specs">Specifications</label></dt>
                <dd>
                  <div>
                    <input type="text" id="newItem" style="margin: 0 10px 0 0;">
                    <select id="specs" name="specs[]" multiple="multiple" class="addable">
<? foreach(PropertySpec::all() as $spec) { ?>
                      <option value="<?= $spec->id ?>" <?= selectedMult($property->specs, $spec->id) ?>><?= $spec->spec ?></option>
<? } ?>
                    </select><br>
                    <input type="button" id="add" value="Add" style="margin: 5px 0 0; float: none;" class="create submit">
                  </div>
                </dd>
                
                <dt><label for="desc">Description</label></dt>
                <dd><textarea name="desc" id="desc" rows="5" cols="80"><?= stripslashes($property->desc) ?></textarea></dd>
                
                <dt><label for="amenities">Amenities</label></dt>
                <dd>
                  <select id="amenities" name="amenities[]" class="multiple" multiple="multiple">
                    <option value="elevator" <?= selectedMult($property->amenities, 'elevator') ?>>Elevator</option>
                    <option value="laundry" <?= selectedMult($property->amenities, 'laundry') ?>>Laundry</option>
                    <option value="parking" <?= selectedMult($property->amenities, 'parking') ?>>Parking</option>
                    <option value="doorman" <?= selectedMult($property->amenities, 'doorman') ?>>Doorman</option>
                    <option value="gas" <?= selectedMult($property->amenities, 'gas') ?>>Free Gas</option>
                    <option value="utilities" <?= selectedMult($property->amenities, 'utilities') ?>>All Utilities</option>
                  </select>
                </dd>
                
                <dt><label for="super">Super</label></dt>
                <dd>
                  <textarea name="super" id="super"><?= $property->super ?></textarea>
                </dd>
              </dl>
              <div>
                <input type="submit" class="submit save" value="Save">
                <a class="submit finish" href="/user/panel/<?= ID ?>">Finish <img src="/images/panel/icons/finish.png" alt=""></a>
              </div>
            </form>
<? } else if($_GET['sid'] == 'new') { ?>
            <h3>Create New Property</h3>
            <form action="/user/panel/<?= ID ?>/<?= $_GET['sid'] ?>" method="post" accept-charset="utf-8">
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
                <input type="submit" class="submit create" value="Create">
              </div>
            </form>
<? } ?>