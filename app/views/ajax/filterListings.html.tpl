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
              <script type="text/javascript">
              $("table").tablesorter();
              </script>