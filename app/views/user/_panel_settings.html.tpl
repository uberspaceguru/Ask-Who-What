
            <h3>Edit User Settings</h3>
            <form action="/user/panel/settings" method="post" accept-charset="utf-8">
              <dl>
                <dt>User Level</dt>
                <dd><?= $user->level->level ?> - <?= $user->level->description ?></dd>
                <dt><label for="name">Name</label></dt>
                <dd><input type="text" name="name" id="name" value="<?= $user->name ?>"></dd>
                
                <dt><label for="email">Email</label></dt>
                <dd><input type="email" name="email" id="email" value="<?= $user->email ?>"></dd>
                
                <dt><label for="phone">Phone</label></dt>
                <dd><input type="tel" name="phone" id="phone" value="<?= $user->phone ?>"></dd>
                
                <dt><label for="company">Company</label></dt>
                <dd><input type="text" name="company" id="company" value="<?= $user->company ?>"></dd>
                
                <dt><label for="oldpass">Old Password</label></dt>
                <dd><input type="password" name="oldpass" id="oldpass"></dd>
                
                <dt><label for="newpass">New Password</label></dt>
                <dd><input type="password" name="newpass" id="newpass"></dd>
                
                <dt><label for="confpass">Confirm Password</label></dt>
                <dd><input type="password" name="confpass" id="confpass"></dd>
                
                <dt><label for="rec_blast">Email Blast</label></dt>
                <dd>
                  <a href="/user/panel/website" id="rec_blast" rel="<?= $user->id ?>" class="blast_me pgchk">Email Blast
                    <? if($user->receive_blast) { ?>
                      <img src="/images/panel/icons/checked.png" alt="Yes">
                    <? } else { ?>
                      <img src="/images/panel/icons/unchecked.png" alt="No">
                    <? } ?>
                  </a>
                </dd>
              </dl>
              <div>
                <input type="submit" class="submit save" value="Save">
              </div>
            </form>