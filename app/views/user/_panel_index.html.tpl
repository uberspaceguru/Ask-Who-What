          <h3 class="nofloat" style="padding-bottom: 0;"><a href="/user/panel/wizard" id="to_wizard">Start the Wizard.</a></h3>
          <div id="recent">
            <h3 class="nofloat">Recent Activity</h3>
            <ul id="recentList">
<? foreach(Activity::all(array('order' => 'created_at desc', 'limit' => '10')) as $activity) { ?>
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
            </ul>
            <a href="#" id="load_more">Load More</a>
          </div>