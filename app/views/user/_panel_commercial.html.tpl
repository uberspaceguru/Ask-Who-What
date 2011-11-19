<? if(!isset($_GET['sid'])) { ?>
            <h3>Manage Commercial Listings <a href="/#commercial" class="live submit" target="_blank">Preview <img src="/images/panel/icons/eye.png" alt=""></a></h3>
            <a class="new" href="/user/panel/commercial/new">Add New <img src="/images/panel/icons/new.png" alt="New"></a>
            <input type="text" class="search" placeholder="Search">
            <table style="width: 100%;">
              <thead>
                <tr>
                  <th class="nobleft">Address/Location</th>
                  <th>Type</th>
                  <th>Price</th>
                  <th class="nobright listopt">Options</th>
                </tr>
              </thead>
              <tbody>
              <? foreach($listings as $listing) { ?>
                <tr class="<?= cycle("odd", "even") ?>" id="com_listing_<?= $listing->id ?>">
                  <td class="nobleft"><?= $listing->address ?> (<?= $listing->neighborhood->neighborhood ?>)</td>
                  <td><?= $listing->comtype->type ?></td>
                  <td><?= money_format('%(.0n', $listing->price) ?></td>
                  <td class="smallpad nobright">
                    <a href="/user/panel/commercial/<?= $listing->id ?>">Edit <img src="/images/panel/icons/edit.png" alt="Edit"></a>
                    <a href="/user/panel/commercial/<?= $listing->id ?>" rel="<?= $listing->id ?>" class="com_list_avail">Availability
                      <? if($listing->avail) { ?>
                        <img src="/images/panel/icons/checked.png" alt="Available">
                      <? } else { ?>
                        <img src="/images/panel/icons/unchecked.png" alt="Unavailable">
                      <? } ?>
                    </a>
                    <a href="/user/panel/commercial/<?= $listing->id ?>" rel="<?= $listing->id ?>" class="com_listing_del">Delete <img src="/images/panel/icons/delete.png" alt="Delete"></a>
                  </td>
                </tr>
              <? } ?>
              </tbody>
            </table>
<? } else if(is_numeric($_GET['sid'])) { ?>
            <h3>Edit Commercial Listing <a href="/?commercial_id=<?= $_GET['sid'] ?>#commercial" class="live submit" target="_blank">Preview <img src="/images/panel/icons/eye.png" alt=""></a></h3>
            <form action="/user/panel/<?= ID ?>/<?= $_GET['sid'] ?>" method="post" accept-charset="utf-8">
              <dl>
                <dt><label for="neighborhood">Neighborhood</label></dt>
                <dd>
                  <select id="neighborhood" name="neighborhood_id" class="single">
<? foreach(Location::all(array('order' => 'location asc')) as $loc) { ?>
                    <optgroup label="<?= $loc->location ?>">
<? foreach(Neighborhood::all(array('conditions' => 'location_id = ' . $loc->id)) as $hood) { ?>
                      <option value="<?= $hood->id ?>" <?= selected($listing->neighborhood_id, $hood->id) ?>><?= $hood->neighborhood ?></option>
<? } ?>
                    </optgroup>
<? } ?>
                  </select>
                </dd>
                
                <dt><label for="type">Type</label></dt>
                <dd>
                  <select id="type" name="comtype_id[]" class="multiple" multiple="multiple">
<? foreach(Comtype::all() as $comtype) { ?>
                    <option value="<?= $comtype->id ?>" <?= selectedMult($listing->comtype_id, $comtype->id) ?>><?= $comtype->type ?></option>
<? } ?>
                  </select>
                </dd>
                
                <dt><label for="address">Address</label></dt>
                <dd><input type="text" name="address" id="address" value="<?= $listing->address ?>"></dd>
                
                <dt><label for="price">Price</label></dt>
                <dd><input type="text" name="price" id="price" value="<?= $listing->price ?>"></dd>
                
                <dt><label for="file_upload">Pictures</label></dt>
                <dd>
                  <small style="float: right;">* Please save the listing to complete the upload procedure.</small>
                  <input id="file_upload" name="file_upload" type="file" />
                  <ol class="reorder">
<? $i = 0; foreach(filesIn(PUB_ROOT . '/public/commercial/' . $_GET['sid']) as $file) { $i++; ?>
                    <li id="file_<?= $i ?>">
                      <img src="<?= '/public/commercial/' . $_GET['sid'] . '/' . $file ?>?<?= time() ?>" alt="" class="thumb">
                      <a href="/delFile" class="delX">Delete</a>
                    </li>
<? } ?>
                  </ol>
                </dd>
                
                <dt><label for="desc">Description</label></dt>
                <dd><textarea name="desc" id="desc" rows="5" cols="80"><?= stripslashes($listing->desc) ?></textarea></dd>
                
                <dt><label for="contact">Contact</label></dt>
                <dd><input type="text" name="contact" id="contact" value="<?= $listing->contact ?>"></dd>
                
                <dt><label for="avail_yes">Available</label></dt>
                <dd>
                  <div>
                    <input type="radio" name="avail" id="avail_yes" <?= checked($listing->avail) ?>> <label for="avail_yes">Yes</label><br>
                    <input type="radio" name="avail" id="avail_no" <?= checked($listing->avail, true) ?>> <label for="avail_no">No</label>
                  </div>
                </dd>
              </dl>
              <div>
                <input type="submit" class="submit save" value="Save">
                <a class="submit finish" href="/user/panel/<?= ID ?>">Finish <img src="/images/panel/icons/finish.png" alt=""></a>
              </div>
            </form>
<? } else if($_GET['sid'] == 'new') { ?>
            <h3>Create New Commercial Listing</h3>
            <form action="/user/panel/<?= ID ?>/<?= $_GET['sid'] ?>" method="post" accept-charset="utf-8">
              <dl>
                <dt><label for="neighborhood">Neighborhood</label></dt>
                <dd>
                  <select id="neighborhood" name="neighborhood_id" class="multiple" multiple="multiple">
<? foreach(Location::all(array('order' => 'location asc')) as $loc) { ?>
                    <optgroup label="<?= $loc->location ?>">
<? foreach(Neighborhood::all(array('conditions' => 'location_id = ' . $loc->id)) as $hood) { ?>
                      <option value="<?= $hood->id ?>"><?= $hood->neighborhood ?></option>
<? } ?>
                    </optgroup>
<? } ?>
                  </select>
                </dd>
                
                <dt><label for="type">Type</label></dt>
                <dd>
                  <select id="type" name="comtype_id[]" class="single">
<? foreach(Comtype::all() as $comtype) { ?>
                    <option value="<?= $comtype->id ?>"><?= $comtype->type ?></option>
<? } ?>
                  </select>
                </dd>
                
                <dt><label for="address">Address</label></dt>
                <dd><input type="text" name="address" id="address"></dd>
                
                <dt><label for="price">Price</label></dt>
                <dd><input type="text" name="price" id="price"></dd>
                
                <dt><label for="file_upload">Pictures</label></dt>
                <dd><input id="file_upload" name="file_upload" type="file" /></dd>
                
                <dt><label for="desc">Description</label></dt>
                <dd><textarea name="desc" id="desc" rows="5" cols="80"></textarea></dd>
                
                <dt><label for="contact">Contact</label></dt>
                <dd><input type="text" name="contact" id="contact"></dd>
                
                <dt><label for="avail_yes">Available</label></dt>
                <dd>
                  <div>
                    <input type="radio" name="avail" id="avail_yes"> <label for="avail_yes">Yes</label><br>
                    <input type="radio" name="avail" id="avail_no"> <label for="avail_no">No</label>
                  </div>
                </dd>
              </dl>
              <div>
                <input type="submit" class="submit create" value="Create">
              </div>
            </form>
<? } ?>