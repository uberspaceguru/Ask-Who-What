<? if(!isset($_GET['sid'])) { ?>
            <h3>Manage Users<small class="right"><?= $userCount ?></small></h3>
            <a class="new" href="/user/panel/users/new">Add New <img src="/images/panel/icons/new.png" alt="New"></a>
            <input type="text" class="search" placeholder="Search">
            <table style="width: 100%;">
              <thead>
                <tr>
                  <th class="nobleft">Name</th>
                  <th>User Level</th>
                  <th class="nobright opt">Options</th>
                </tr>
              </thead>
              <tbody>
              <? foreach($users as $this_user) { ?>
                <tr class="<?= cycle("odd", "even") ?>" id="user_<?= $this_user->id ?>">
                  <td class="nobleft"><?= $this_user->name ?></td>
                  <td><?= $this_user->level->level ?></td>
                  <td class="smallpad nobright">
                    <a href="/user/panel/users/<?= $this_user->id ?>">Edit <img src="/images/panel/icons/edit.png" alt="Edit"></a>
                    <a href="/user/panel/users/<?= $this_user->id ?>" rel="<?= $this_user->id ?>" class="user_del">Delete <img src="/images/panel/icons/delete.png" alt="Delete"></a>
                  </td>
                </tr>
              <? } ?>
              </tbody>
            </table>
<? } else if(is_numeric($_GET['sid'])) { ?>
            <h3>Edit <?= $this_user->name ?></h3>
            <form action="/user/panel/<?= ID ?>/<?= $_GET['sid'] ?>" method="post" accept-charset="utf-8">
              <dl>
                <dt><label for="level">User Level</label></dt>
                <dd>
                  <select id="level" name="level_id" class="single">
<? foreach(Level::all() as $level) { ?>
                    <option value="<?= $level->id ?>" <?= selected($this_user->level_id, $level->id) ?>><?= $level->level ?></option>
<? } ?>
                  </select>
                </dd>
                
                <dt><label for="name">Name</label></dt>
                <dd><input type="text" name="name" id="name" value="<?= $this_user->name ?>"></dd>
                
                <dt><label for="email">Email</label></dt>
                <dd><input type="email" name="email" id="email" value="<?= $this_user->email ?>"></dd>
                
                <dt><label for="phone">Phone</label></dt>
                <dd><input type="tel" name="phone" id="phone" value="<?= $this_user->phone ?>"></dd>
                
                <dt><label for="company">Company</label></dt>
                <dd><input type="text" name="company" id="company" value="<?= $this_user->company ?>"></dd>
                
                <dt><label for="rec_blast">Email Blast</label></dt>
                <dd>
                  <a href="/user/panel/website" id="rec_blast" rel="<?= $this_user->id ?>" class="receive_blast pgchk">Email Blast
                    <? if($this_user->receive_blast) { ?>
                      <img src="/images/panel/icons/checked.png" alt="Yes">
                    <? } else { ?>
                      <img src="/images/panel/icons/unchecked.png" alt="No">
                    <? } ?>
                  </a>
                </dd>
                
                <dt><label for="suspend">Suspend User</label></dt>
                <dd>
                  <a href="/user/panel/users/<?= $this_user->id ?>" id="suspend" rel="<?= $this_user->id ?>" class="suspend pgchk">Suspend
                    <? if($this_user->suspend) { ?>
                      <img src="/images/panel/icons/checked.png" alt="Yes">
                    <? } else { ?>
                      <img src="/images/panel/icons/unchecked.png" alt="No">
                    <? } ?>
                  </a>
                </dd>
              </dl>
              <div>
                <input type="submit" class="submit save" value="Save">
                <a class="submit finish" href="/user/panel/<?= ID ?>">Finish <img src="/images/panel/icons/finish.png" alt=""></a>
              </div>
            </form>
<? } else if($_GET['sid'] == 'new') { ?>
            <h3>Create New User</h3>
            <form action="/user/panel/<?= ID ?>/<?= $_GET['sid'] ?>" method="post" accept-charset="utf-8">
              <dl>
                <dt><label for="level">User Level</label></dt>
                <dd>
                  <select id="level" name="level_id" class="single">
<? foreach(Level::all(array('order' => 'id desc')) as $level) { ?>
                    <option value="<?= $level->id ?>"><?= $level->level ?></option>
<? } ?>
                  </select>
                </dd>
                
                <dt><label for="name">Name</label></dt>
                <dd><input type="text" name="name" id="name"></dd>
                
                <dt><label for="email">Email</label></dt>
                <dd><input type="email" name="email" id="email"></dd>
                
                <dt><label for="phone">Phone</label></dt>
                <dd><input type="tel" name="phone" id="phone"></dd>
                
                <dt><label for="password">Password</label></dt>
                <dd><input type="text" name="password" id="password"></dd>
                
                <dt><label for="company">Company</label></dt>
                <dd><input type="text" name="company" id="company"></dd>
              </dl>
              <div>
                <input type="checkbox" name="receive_blast" id="receive_blast"> <label for="receive_blast">Receive Blast?</label><br>
                <input type="checkbox" name="suspend" id="suspend"> <label for="suspend">Suspend User?</label><br>
                <input type="submit" class="submit create" value="Create">
              </div>
            </form>
<? } ?>