<? if(!isset($_GET['sid'])) { ?>
            <h3>Manage Neighborhoods</h3>
            <a class="new left" href="/user/panel/neighborhoods/new">Add New <img src="/images/panel/icons/new.png" alt="New"></a>
            <input type="text" class="search" placeholder="Search">
            <table style="width: 100%;">
              <thead>
                <tr>
                  <th class="nobleft">Neighborhood</th>
                  <th>Location</th>
                  <th class="nobright opt">Options</th>
                </tr>
              </thead>
              <tbody>
              <? foreach($neighborhoods as $neighborhood) { ?>
                <tr class="<?= cycle("odd", "even") ?>">
                  <td class="nobleft"><?= $neighborhood->neighborhood ?></td>
                  <td><?= $neighborhood->location->location ?></td>
                  <td class="smallpad nobright">
                    <a href="/user/panel/neighborhoods/<?= $neighborhood->id ?>">Edit <img src="/images/panel/icons/edit.png" alt="Edit"></a>
                    <a href="/user/panel/neighborhoods/<?= $neighborhood->id ?>">Delete <img src="/images/panel/icons/delete.png" alt="Delete"></a>
                  </td>
                </tr>
              <? } ?>
              </tbody>
            </table>
<? } else if(is_numeric($_GET['sid'])) { ?>
            <h3>Edit Neighborhood</h3>
            <?= @$error_messages ?>
            <form action="/user/panel/<?= ID ?>/<?= $_GET['sid'] ?>" method="post" accept-charset="utf-8">
              <dl>
                <dt><label for="location">Location</label></dt>
                <dd>
                  <div>
                    <select id="location" name="location_id">
<? foreach(Location::all(array('order' => 'location asc')) as $loc) { ?>
                      <option value="<?= $loc->id ?>" <?= selected($neighborhood->location->id, $loc->id) ?>><?= $loc->location ?></option>
<? } ?>
                    </select>
                  </div>
                </dd>
                
                <dt><label for="neighborhood">Neighborhood</label></dt>
                <dd><input type="text" name="neighborhood" id="neighborhood" value="<?= $neighborhood->neighborhood ?>"></dd>
                
                <dt><label for="desc">Description</label></dt>
                <dd><textarea name="desc" id="desc" rows="5" cols="80"><?= $neighborhood->desc ?></textarea></dd>
              </dl>
              <div>
                <input type="submit" class="submit save" value="Save">
                <a class="submit finish" href="/user/panel/<?= ID ?>">Finish <img src="/images/panel/icons/finish.png" alt=""></a>
              </div>
            </form>
<? } else if($_GET['sid'] == 'new') { ?>
            <h3>Create New Neighborhood</h3>
            <form action="/user/panel/<?= ID ?>/<?= $_GET['sid'] ?>" method="post" accept-charset="utf-8">
              <dl>
                <dt><label for="location">Location</label></dt>
                <dd>
                  <div>
                    <input type="text" id="newItem" style="margin: 0 10px 0 0;">
                    <select id="location" name="location_id" class="addable single">
<? foreach(Location::all() as $loc) { ?>
                      <option value="<?= $loc->id ?>"><?= $loc->location ?></option>
<? } ?>
                    </select><br>
                    <input type="button" id="add" value="Add" style="margin: 5px 0 0; float: none;" class="create submit">
                  </div>
                </dd>
                
                <dt><label for="neighborhood">Neighborhood</label></dt>
                <dd><input type="text" name="neighborhood" id="neighborhood"></dd>
                
                <dt><label for="desc">Description</label></dt>
                <dd><textarea name="desc" id="desc" rows="5" cols="80"></textarea></dd>
              </dl>
              <div>
                <input type="submit" class="submit create" value="Create">
              </div>
            </form>
<? } ?>