<? if(!isset($activities)) { ?>
  <li id="noneLeft">There are no more activities to display.</li>
<? } else { ?>
<? foreach($activities as $activity) { ?>
              <li><img src="/images/panel/icons/activity/<?= $activity->getIcon(); ?>" alt=""><?= $activity->getAction() ?> |
                <strong><? $rec = $activity->getRec();
                if(is_array($rec))
                  echo $rec[0] . " (". $rec[1] . ")";
                else
                  echo $rec;
                ?></strong>
                <span class="right"><strong><?= $activity->by_name() ?></strong>
                  | <?= date("m/d/Y / h:i A", strtotime($activity->created_at)) ?></span>
              </li>
<? } ?>
<? } ?>