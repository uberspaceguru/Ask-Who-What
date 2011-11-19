<? if(!isset($_GET['sid'])) { ?>
            <h3>Manage Brokers</h3>
            <a class="new" href="/user/panel/users/new">Add New <img src="/images/panel/icons/new.png" alt="New"></a>
            <input type="text" class="search" placeholder="Search">
            <table style="width: 100%;">
              <thead>
                <tr>
                  <th class="nobleft">Name</th>
                  <th>Company</th>
                  <th>User Level</th>
                  <th class="nobright brokopt">Options</th>
                </tr>
              </thead>
              <tbody>
              <? foreach($brokers as $broker) { ?>
                <tr class="<?= cycle("odd", "even") ?>" id="user_<?= $broker->id ?>">
                  <td class="nobleft"><?= $broker->name ?></td>
                  <td><?= $broker->company ?></td>
                  <td><?= $broker->level->level ?></td>
                  <td class="smallpad nobright">
                    <a href="/user/panel/brokers/<?= $broker->id ?>">Edit <img src="/images/panel/icons/edit.png" alt="Edit"></a>
                    <a href="/user/panel/brokers/<?= $broker->id ?>" rel="<?= $broker->id ?>" class="receive_blast">Email Blast
                      <? if($broker->receive_blast) { ?>
                        <img src="/images/panel/icons/checked.png" alt="Yes">
                      <? } else { ?>
                        <img src="/images/panel/icons/unchecked.png" alt="No">
                      <? } ?>
                    </a>
                    <a href="/user/panel/brokers/<?= $broker->id ?>" rel="<?= $broker->id ?>" class="suspend">Suspended
                      <? if($broker->suspend) { ?>
                        <img src="/images/panel/icons/checked.png" alt="Yes">
                      <? } else { ?>
                        <img src="/images/panel/icons/unchecked.png" alt="No">
                      <? } ?>
                    </a>
                    <a href="/user/panel/brokers/<?= $broker->id ?>" rel="<?= $broker->id ?>" class="user_del">Delete <img src="/images/panel/icons/delete.png" alt="Delete"></a>
                  </td>
                </tr>
              <? } ?>
              </tbody>
            </table>
<? } else { ?>
            <h3>Edit <?= $broker->name ?></h3>
            <form action="/user/panel/<?= ID ?>/<?= $_GET['sid'] ?>" method="post" accept-charset="utf-8">
              <dl>
                <dt>User Level</dt>
                <dd><?= $broker->level->level ?> - <?= $broker->level->description ?></dd>
                <dt><label for="name">Name</label></dt>
                <dd><input type="text" name="name" id="name" value="<?= $broker->name ?>"></dd>
                
                <dt><label for="email">Email</label></dt>
                <dd><input type="email" name="email" id="email" value="<?= $broker->email ?>"></dd>
                
                <dt><label for="phone">Phone</label></dt>
                <dd><input type="tel" name="phone" id="phone" value="<?= $broker->phone ?>"></dd>
                
                <dt><label for="company">Company</label></dt>
                <dd><input type="text" name="company" id="company" value="<?= $broker->company ?>"></dd>
              </dl>
              <div>
                <input type="checkbox" name="blast" id="blast" <?= checked($broker->receive_blast) ?>> <label for="blast">Receive Blast?</label><br>
                <input type="checkbox" name="suspend" id="suspend" <?= checked($broker->suspend) ?>> <label for="suspend">Suspend User?</label><br>
                <input type="submit" class="submit save" value="Save">
                <a class="submit finish" href="/user/panel/<?= ID ?>">Finish <img src="/images/panel/icons/finish.png" alt=""></a>
              </div>
            </form>
<? } ?>