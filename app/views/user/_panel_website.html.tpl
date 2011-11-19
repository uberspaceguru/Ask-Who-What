<? if(!isset($_GET['sid'])) { ?>
            <h3>Manage Photos</h3>
            <a class="new left" href="/user/panel/website/new">Add New <img src="/images/panel/icons/new.png" alt="New"></a>
            <input type="text" class="search" placeholder="Search">
            <table style="width: 100%;" class="reorder">
              <thead>
                <tr>
                  <th class="nobleft">Photo</th>
                  <th class="nobright opt">Options</th>
                </tr>
              </thead>
              <tbody>
              <? foreach($photos as $photo) { ?>
                <tr class="<?= cycle("odd", "even") ?>" id="photo_<?= $photo->id ?>">
                  <td class="nobleft"><?= $photo->name ?></td>
                  <td class="smallpad nobright">
                    <a href="/user/panel/website/<?= $photo->id ?>" rel="<?= $photo->id ?>">Edit <img src="/images/panel/icons/edit.png" alt="Edit"></a>
                    <a href="/user/panel/website/<?= $photo->id ?>" rel="<?= $photo->id ?>" class="photo_del">Delete <img src="/images/panel/icons/delete.png" alt="Delete"></a>
                  </td>
                </tr>
              <? } ?>
              </tbody>
            </table>
<? } else if($_GET['sid'] == 'new') { ?>
            <h3>Add New Photo</h3>
            <form action="/user/panel/<?= ID ?>/<?= $_GET['sid'] ?>" method="post" enctype="multipart/form-data" accept-charset="utf-8">
              <dl>                
                <dt><label for="name">Name</label></dt>
                <dd><input type="text" name="name" id="name"></dd>
                
                <dt><label for="file">File</label></dt>
                <dd><input type="file" name="file" id="file"></dd>
                
                <dt><label for="desc">Description</label></dt>
                <dd><textarea name="desc" id="desc" rows="5" cols="80"></textarea></dd>
              </dl>
              <div>
                <input type="submit" class="submit create" value="Add">
              </div>
            </form>
<? } else if(is_numeric($_GET['sid'])) { ?>
            <h3>Edit <?= $photo->name ?></h3>
            <form action="/user/panel/<?= ID ?>/<?= $_GET['sid'] ?>" method="post" enctype="multipart/form-data" accept-charset="utf-8">
              <dl>                
                <dt><label for="name">Name</label></dt>
                <dd><input type="text" name="name" id="name" value="<?= $photo->name ?>"></dd>
                
                <dt><label for="file">File</label></dt>
                <dd><input type="file" name="file" id="file"></dd>
                
                <dt><label for="desc">Description</label></dt>
                <dd><textarea name="desc" id="desc" rows="5" cols="80"><?= $photo->desc ?></textarea></dd>
              </dl>
              <div>
                <input type="submit" class="submit save" value="Save">
                <a class="submit finish" href="/user/panel/<?= ID ?>">Finish <img src="/images/panel/icons/finish.png" alt=""></a>
              </div>
            </form>
<? } ?>