<? if(!isset($_GET['sid'])) { ?>
            <h3>Blast Archive</h3>
            <input type="text" class="search" placeholder="Search">
            <table style="width: 100%;">
              <thead>
                <tr>
                  <th class="nobleft">Date</th>
                  <th class="nobright listopt">View</th>
                </tr>
              </thead>
              <tbody>
              <? foreach($blasts as $blast) { ?>
                <tr class="<?= cycle("odd", "even") ?>" id="blast_<?= $blast->id ?>">
                  <td class="nobleft"><?= date("F d, Y", $blast->date) ?></td>
                  <td class="smallpad nobright">
                    <a href="/public/blasts/<?= $blast->filename() ?>">PDF <img src="/images/panel/icons/pdf.png" alt="PDF"></a>
                    <a href="/listings/blast/<?= $blast->id ?>">HTML <img src="/images/panel/icons/globe.png" alt="HTML"></a>
                  </td>
                </tr>
              <? } ?>
              </tbody>
            </table>
<? } ?>