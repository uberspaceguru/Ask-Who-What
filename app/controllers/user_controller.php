<?php
class UserController {
  var $default = "index";
  
  function index() {
    global $error_messages;
    
    if(isset($_SESSION['user']))
      header("Location: /user/panel");
    else if(isset($_COOKIE['pistilli'])) {
      $_SESSION['user'] = $_COOKIE['pistilli'];
      header("Location: /user/panel");
    }
    
    if(isset($_GET['status'])) {
      if($_GET['status'] == 'registered') {
        $error_messages = '<p class="notice">Congratulations! You have successfully registered.  Please login.</p>';
      }
      if($_GET['status'] == 'taken') {
        $error_messages = '<p class="notice">Sorry! The email you entered is already taken!</p>';
      }
      if($_GET['status'] == 'password_retrieved') {
        $error_messages = '<p class="notice">Your new password has successfully been emailed to you.</p>';
      }
      if($_GET['status'] == 'captcha') {
        $error_messages = '<p class="notice">Sorry! The CAPTCHA you entered does not match.</p>';
      }
      if($_GET['status'] == 'nomatch') {
        $error_messages = '<p class="notice">Sorry! The passwords you entered do not match.</p>';
      }
      if($_GET['status'] == 'notfound') {
        $error_messages = '<p class="notice">Sorry! The credentials you entered do not match our any of records.</p>';
      }
      if($_GET['status'] == 'suspended') {
        $error_messages = '<p class="notice">Sorry! You cannot access your account at this time. Please email <a href="mailto:info@pistilli.com">info@pistilli.com</a>.</p>';
      }
    }
  }
  
  function legal() {
    
  }
  
  function panel() {
    if(!isset($_SESSION['user'])) {
      header("Location: /user");
      exit;
    }
    global $user;
    $user = User::find($_SESSION['user']);
    if(defined('ID'))
      if(ID == 'index')
        $this->panel_index();
      else {
        if(method_exists($this, ID))
          $this->{ID}();
        else {
          require_once(PUB_ROOT . "/404.html");
          exit;
        }
      }
  }
  
  function panel_index() {
    global $user;
    if($user->level_id == 4) {
      header("Location: /user/panel/archive");
      exit;
    }
    
  }
  
  function unsubscribe() {
    global $user;
    if(isset($_GET['id']) && isset($_GET['sid'])) {
      if(is_numeric($_GET['id'])) {
        $user = User::find($_GET['id']);
        if($user->password == $_GET['sid']) {
          $user->receive_blast = 0;
          if($user->save())
            Activity::create(array('performed_by' => $user->id, 'performed_to' => $user->id, 'table_affected' => 'users', 'action_taken' => 'unsubscribe'));
        }
      }
    }
  }
  
  function brokers() {
    global $user;
    if($user->level_id == 1) {
      if(!isset($_GET['sid'])) {
        global $brokers;
        $brokers = User::all(array('conditions' => 'level_id = 4'));
      } else {
        global $broker;
        $broker = User::first(array('conditions' => 'level_id = 4 AND id = ' . $_GET['sid']));
        if(!empty($_POST)) {
          if(isset($_POST['blast'])) {
            $broker->receive_blast = 1;
            unset($_POST['blast']);
          } else 
            $broker->receive_blast = 0;
          if(isset($_POST['suspend'])) {
            $broker->suspend = 1;
            unset($_POST['suspend']);
          } else 
            $broker->suspend = 0;
          foreach($_POST as $key => $value) {
            $broker->{$key} = $value;
          }
          if($broker->save()) {
            Activity::create(array('performed_by' => $user->id, 'performed_to' => $broker->id, 'table_affected' => 'users', 'action_taken' => 'update'));
            $error_messages = '<p class="notice">The broker <em><strong>' . $broker->name . '</strong></em> has successfully been updated.</p>';
          }
        }
      }
    } else {
      header("Location: /user/panel");
    }
  }
  
  function wizard() {
    global $user;
    global $property;
    if(isset($_GET['sid'])) {
      if($_GET['sid'] == 2) {
        if(!isset($_GET['fid'])) {
          if(!empty($_POST)) {
            $specs = "";
            foreach($_POST['specs'] as $spec) {
              if(!is_numeric($spec)) {
                $new = new PropertySpec(array('spec' => $spec));
                $new->save();
                $specs .= $new->id . ",";
              } else
                $specs .= $spec . ",";
            }
            $_POST['specs'] = $specs;
            $amenities = "";
            foreach($_POST['amenities'] as $amenity) {
                $amenities .= $amenity . ",";
            }
            $_POST['amenities'] = $amenities;
            unset($_POST['multiselect_specs']);
            unset($_POST['multiselect_neighborhood']);
            unset($_POST['multiselect_amenities']);
            unset($_POST['file_upload']);
            $property = Property::create($_POST);
            $address = $property->address . ", " . $property->neighborhood->neighborhood . ", " . $property->neighborhood->location->location . ", New York";
            $address = urlencode($address);
            $latlng = latlng($address);
            $property->lat = $latlng['lat'];
            $property->lng = $latlng['lng'];
            if($property->save()) {
              mkdir(PUB_ROOT . "/public/properties/" . $property->id);
              $i = 0;
              foreach(filesIn(PUB_ROOT . "/public/temp") as $file) {
                $i++;
                $pi = pathinfo($file);
                rename(PUB_ROOT . "/public/temp/" . $file, PUB_ROOT . "/public/properties/" . $listing->id . "/" . $i . "." . $pi['extension']);
              }
              Activity::create(array('performed_by' => $user->id, 'performed_to' => $property->id, 'table_affected' => 'properties', 'action_taken' => 'create'));
              header("Location: /user/panel/wizard/2/" . $property->id);
            }
          }
        } else {
          $property = Property::find($_GET['fid']);
        }
      } else if($_GET['sid'] == 'finish') {
        if(!empty($_POST)) {
          foreach($_POST['wizard2'] as $key => $item) {
            $specs = "";
            if(!empty($item['specs'])) {
              foreach($item['specs'] as $spec) {
                if(!is_numeric($spec)) {
                  $new = new ListingSpec(array('spec' => $spec));
                  $new->save();
                  $specs .= $new->id . ",";
                } else
                  $specs .= $spec . ",";
              }
            }
            $item['specs'] = $specs;
            $item['property_id'] = $_POST['property_id'];
            if(isset($item['avail']))
              $item['avail'] = 1;
            else 
              $item['avail'] = 0;
            if(!empty($item['dateAvail'])) {
              $dateAvail = explode("/", $item['dateAvail']);
              $timeAvail = mktime(0, 0, 0, $dateAvail[0], $dateAvail[1], $dateAvail[2]);
              $item['avail'] = $timeAvail;
            }
            unset($item['dateAvail']);
            if(isset($item['ready']))
              $item['ready'] = 1;
            else 
              $item['ready'] = 0;
            unset($item['file']);
            print_r($_FILES);
            $listing = Listing::create($item);
            if($listing) {
              if(!empty($_FILES)) {
                $ext = upload4ext($_FILES['wizard2'][$key]['file'], PUB_ROOT . "/public/floorplans/", $listing->id);
                if($ext == 'pdf') {
                  $p = new phMagick('', PUB_ROOT . "/public/floorplans/" . $listing->id . ".png");
                  $p->acquireFrame(PUB_ROOT . "/public/floorplans/" . $listing->id . "." . $ext);
                  unlink(PUB_ROOT . "/public/floorplans/" . $listing->id . "." . $ext);
                  $ext = 'png';
                }
                $listing->floorplan_ext = $ext;
              }
              if($listing->save()) {
                Activity::create(array('performed_by' => $user->id, 'performed_to' => $listing->id, 'table_affected' => 'listings', 'action_taken' => 'create'));
              }
            }
          }
        }
      }
    }
  }
  
  function users() {
    global $user;
    if($user->level_id == 1) {
      if(!isset($_GET['sid'])) {
        global $users;
        global $userCount;
        $users = User::all();
        $userCount = User::count();
      } else if(is_numeric($_GET['sid'])) {
        global $this_user;
        $this_user = User::find($_GET['sid']);
        if(!empty($_POST)) {
          unset($_POST['multiselect_level']);
          foreach($_POST as $key => $value) {
            $this_user->{$key} = $value;
          }
          if($this_user->save()) {
            Activity::create(array('performed_by' => $user->id, 'performed_to' => $this_user->id, 'table_affected' => 'users', 'action_taken' => 'update'));
            $error_messages = '<p class="notice">The user <em><strong>' . $this_user->name . '</strong></em> has successfully been updated.</p>';
          }
        }
      } else if($_GET['sid'] == 'new') {
        if(!empty($_POST)) {
          if(User::count(array('conditions' => 'email = "' . $_POST['email'] . '"')) == 0) {
            if(isset($_POST['receive_blast']))
              $_POST['receive_blast'] = 1;
            else 
              $_POST['receive_blast'] = 0;
            if(isset($_POST['suspend']))
              $_POST['suspend'] = 1;
            else 
              $_POST['suspend'] = 0;
            $_POST['password'] = sha1($_POST['password']);
            unset($_POST['multiselect_level']);
            if($new = User::create($_POST)) {
              Activity::create(array('performed_by' => $user->id, 'performed_to' => $new->id, 'table_affected' => 'users', 'action_taken' => 'create'));
              header("Location: /user/panel/users?status=success");
            }
          } else
            header("Location: /user/panel/users/new?status=taken");
        }
      }
    } else {
      header("Location: /user/panel");
    }
  }
  
  function website() {
    global $user;
    if($user->level_id < 3) {
      if(!isset($_GET['sid'])) {
        global $photos;
        $photos = Photo::all(array('order' => 'sort asc'));
      } else if($_GET['sid'] == 'new') {
        if(!empty($_POST)) {
          global $photo;
          $photo = Photo::create($_POST);
          $ext = upload4ext($_FILES['file'], PUB_ROOT . "/public/gallery/", $photo->id);
          $photo->ext = $ext;
          if($photo->save()) {
            Activity::create(array('performed_by' => $user->id, 'performed_to' => $photo->id, 'table_affected' => 'photos', 'action_taken' => 'create'));
            header("Location: /user/panel/website?status=success");
          }
        }
      } else if(is_numeric($_GET['sid'])) {
        global $photo;
        $photo = Photo::find($_GET['sid']);
        if(!empty($_POST)) {
          foreach($_POST as $key => $value) {
            $photo->{$key} = $value;
          }
          if(!empty($_FILES['file']['name'])) {
            if(!empty($photo->ext))
              unlink(PUB_ROOT . "/public/floorplans/" . $photo->id . "." . $photo->ext);
            $ext = upload4ext($_FILES['file'], PUB_ROOT . "/public/gallery/", $photo->id);
            $photo->ext = $ext;
          }
          if($photo->save()) {
            Activity::create(array('performed_by' => $user->id, 'performed_to' => $photo->id, 'table_affected' => 'photos', 'action_taken' => 'update'));
            $error_messages = '<p class="notice">The photo <em><strong>' . $photo->name . '</strong></em> has successfully been updated.</p>';
          }
        }
      }
    }
  }
  
  function archive() {
    global $user;
    if(!isset($_GET['sid'])) {
      global $blasts;
      $blasts = Blast::all(array('order' => 'date desc'));
    }
  }
  
  function listings() {
    global $user;
    if(!isset($_GET['sid'])) {
      global $listings;
      switch($user->listing_filter) {
        case 'All':
          $listings = Listing::all(array('order' => 'property_id asc'));
          break;
        case 'Offline':
          $listings = Listing::all(array('conditions' => 'status_2_id = 3', 'order' => 'property_id asc'));
          break;
        case 'Active':
          $listings = Listing::all(array('conditions' => 'status_2_id = 4 AND status_1_id != 4', 'order' => 'property_id asc'));
          break;
        case 'Blast':
          $listings = Listing::all(array('conditions' => 'status_2_id != 3', 'order' => 'property_id asc'));
          break;
      }
    } else if(is_numeric($_GET['sid'])) {
      global $listing;
      global $user;
      $user = User::find($_SESSION['user']);
      $listing = Listing::find($_GET['sid']);
      if(!empty($_POST)) {
        $specs = "";
        foreach($_POST['specs'] as $spec) {
          if(!is_numeric($spec)) {
            $new = new ListingSpec(array('spec' => $spec));
            $new->save();
            $specs .= $new->id . ",";
          } else
            $specs .= $spec . ",";
        }
        $_POST['specs'] = $specs;
        unset($_POST['multiselect_property']);
        unset($_POST['multiselect_specs']);
        unset($_POST['multiselect_status1']);
        unset($_POST['multiselect_status2']);
        if(!empty($_POST['avail'])) {
          $dateAvail = explode("/", $_POST['avail']);
          $timeAvail = mktime(0, 0, 0, $dateAvail[0], $dateAvail[1], $dateAvail[2]);
          $listing->avail = $timeAvail;
        } else
          $listing->avail = 1;
        unset($_POST['avail']);
        
        if(isset($_POST['ready'])) {
          $listing->ready = 1;
          unset($_POST['ready']);
        } else 
          $listing->ready = 0;
        foreach($_POST as $key => $value) {
          $listing->{$key} = $value;
        }
        if(!empty($_FILES['file']['name'])) {
          if(!empty($listing->floorplan_ext))
            unlink(PUB_ROOT . "/public/floorplans/" . $listing->id . "." . $listing->floorplan_ext);
          $ext = upload4ext($_FILES['file'], PUB_ROOT . "/public/floorplans/", $listing->id);
          if($ext == 'pdf') {
            $p = new phMagick('', PUB_ROOT . "/public/floorplans/" . $listing->id . ".png");
            $p->acquireFrame(PUB_ROOT . "/public/floorplans/" . $listing->id . "." . $ext) or die("error");
            unlink(PUB_ROOT . "/public/floorplans/" . $listing->id . "." . $ext);
            $ext = 'png';
          }
          $listing->floorplan_ext = $ext;
        }
        if($listing->save()) {
          Activity::create(array('performed_by' => $user->id, 'performed_to' => $listing->id, 'table_affected' => 'listings', 'action_taken' => 'update'));
          $error_messages = '<p class="notice">The listing at <em><strong>' . $listing->property->address . '</strong></em> has successfully been updated.</p>';
        }
      }
    } else if($_GET['sid'] == 'new') {
      if(!empty($_POST)) {
        global $listing;
        $specs = "";
        foreach($_POST['specs'] as $spec) {
          if(!is_numeric($spec)) {
            $new = new ListingSpec(array('spec' => $spec));
            $new->save();
            $specs .= $new->id . ",";
          } else
            $specs .= $spec . ",";
        }
        $_POST['specs'] = $specs;
        unset($_POST['multiselect_property']);
        unset($_POST['multiselect_specs']);
        unset($_POST['multiselect_status1']);
        unset($_POST['multiselect_status2']);
        if(isset($_POST['avail']))
          $_POST['avail'] = 1;
        else 
          $_POST['avail'] = 0;
        if(!empty($_POST['dateAvail'])) {
          $dateAvail = explode("/", $_POST['dateAvail']);
          $timeAvail = mktime(0, 0, 0, $dateAvail[0], $dateAvail[1], $dateAvail[2]);
          $_POST['avail'] = $timeAvail;
        }
        unset($_POST['dateAvail']);
        if(isset($_POST['ready']))
          $_POST['ready'] = 1;
        else 
          $_POST['ready'] = 0;
        $listing = Listing::create($_POST);
        if($listing) {
          $ext = upload4ext($_FILES['file'], PUB_ROOT . "/public/floorplans/", $listing->id);
          if($ext == 'pdf') {
            $p = new phMagick('', PUB_ROOT . "/public/floorplans/" . $listing->id . ".png");
            $p->acquireFrame(PUB_ROOT . "/public/floorplans/" . $listing->id . "." . $ext);
            unlink(PUB_ROOT . "/public/floorplans/" . $listing->id . "." . $ext);
            $ext = 'png';
          }
          $listing->floorplan_ext = $ext;
          if($listing->save()) {
            Activity::create(array('performed_by' => $user->id, 'performed_to' => $listing->id, 'table_affected' => 'listings', 'action_taken' => 'create'));
            header("Location: /user/panel/listings?status=success");
          }
        }
      }
    }
  }
  
  function neighborhoods() {
    global $user;
    if(!isset($_GET['sid'])) {
      global $neighborhoods;
      $neighborhoods = Neighborhood::all();
    } else if(is_numeric($_GET['sid'])) {
      global $neighborhood;
      $neighborhood = Neighborhood::find($_GET['sid']);
      if(!empty($_POST)) {
        foreach($_POST as $key => $value) {
          $neighborhood->{$key} = $value;
        }
        if($neighborhood->save()) {
          Activity::create(array('performed_by' => $user->id, 'performed_to' => $neighborhood->id, 'table_affected' => 'neighborhoods', 'action_taken' => 'update'));
          $error_messages = '<p class="notice">The neighborhood <em><strong>' . $neighborhood->neighborhood . '</strong></em> has successfully been updated.</p>';
        }
      }
    } else if($_GET['sid'] == 'new') {
      if(!empty($_POST)) {
        global $neighborhood;
        if(!is_numeric($_POST['location_id'])) {
          $new = new Location(array('location' => $_POST['location_id']));
          $new->save();
          $_POST['location_id'] = $new->id;
        }
        unset($_POST['multiselect_location']);
        $neighborhood = Neighborhood::create($_POST);
        if($neighborhood) {
          Activity::create(array('performed_by' => $user->id, 'performed_to' => $neighborhood->id, 'table_affected' => 'neighborhoods', 'action_taken' => 'create'));
          header("Location: /user/panel/neighborhoods?status=success");
        }
      }
    }
  }
  
  function commercial() {
    global $user;
    if(!isset($_GET['sid'])) {
      global $listings;
      $listings = CommercialListing::all();
    } else if(is_numeric($_GET['sid'])) {
      global $listing;
      $listing = CommercialListing::find($_GET['sid']);
      if(!empty($_POST)) {
        if(isset($_POST['avail'])) {
          $listing->avail = 1;
          unset($_POST['avail']);
        } else 
          $listing->avail = 0;
        $coms = "";
        foreach($_POST['comtype_id'] as $com) {
            $coms .= $com . ",";
        }
        $_POST['comtype_id'] = $coms;
        unset($_POST['multiselect_neighborhood']);
        unset($_POST['multiselect_type']);
        unset($_POST['file_upload']);
        foreach($_POST as $key => $value) {
          $listing->{$key} = $value;
        }
        if(!is_dir(PUB_ROOT . "/public/commercial/" . $listing->id))
          mkdir(PUB_ROOT . "/public/commercial/" . $listing->id);
        $i = count(filesIn(PUB_ROOT . "/public/commercial/" . $listing->id));
        foreach(filesIn(PUB_ROOT . "/public/temp") as $file) {
          $i++;
          $pi = pathinfo($file);
          rename(PUB_ROOT . "/public/temp/" . $file, PUB_ROOT . "/public/commercial/" . $listing->id . "/" . $i . "." . $pi['extension']);
        }
        if($listing->save()) {
          Activity::create(array('performed_by' => $user->id, 'performed_to' => $listing->id, 'table_affected' => 'commercial_listings', 'action_taken' => 'update'));
          $error_messages = '<p class="notice">The listing at <em><strong>' . $listing->address . '</strong></em> has successfully been updated.</p>';
        }
      }
    } else if($_GET['sid'] == 'new') {
      if(!empty($_POST)) {
        global $listing;
        if(isset($_POST['avail']))
          $_POST['avail'] = 1;
        else 
          $_POST['avail'] = 0;
        $coms = "";
        foreach($_POST['comtype_id'] as $com) {
            $coms .= $com . ",";
        }
        $_POST['comtype_id'] = $coms;
        unset($_POST['multiselect_neighborhood']);
        unset($_POST['multiselect_type']);
        unset($_POST['file_upload']);
        $listing = CommercialListing::create($_POST);
        if($listing) {
          mkdir(PUB_ROOT . "/public/commercial/" . $listing->id);
          $i = 0;
          foreach(filesIn(PUB_ROOT . "/public/temp") as $file) {
            $i++;
            $pi = pathinfo($file);
            rename(PUB_ROOT . "/public/temp/" . $file, PUB_ROOT . "/public/commercial/" . $listing->id . "/" . $i . "." . $pi['extension']);
          }
          Activity::create(array('performed_by' => $user->id, 'performed_to' => $listing->id, 'table_affected' => 'commercial_listings', 'action_taken' => 'create'));
          header("Location: /user/panel/commercial?status=success");
        }
      }
    }
  }
  
  function properties() {
    global $user;
    if(!isset($_GET['sid'])) {
      global $properties;
      $properties = Property::all();
    } else if(is_numeric($_GET['sid'])) {
      global $property;
      global $error_messages;
      $property = Property::find($_GET['sid']);
      if(!empty($_POST)) {
        $specs = "";
        foreach($_POST['specs'] as $spec) {
          if(!is_numeric($spec)) {
            $new = new PropertySpec(array('spec' => $spec));
            $new->save();
            $specs .= $new->id . ",";
          } else
            $specs .= $spec . ",";
        }
        $_POST['specs'] = $specs;
        $amenities = "";
        if(isset($_POST['amenities'])) {
          foreach($_POST['amenities'] as $amenity) {
              $amenities .= $amenity . ",";
          }
        }
        $_POST['amenities'] = $amenities;
        unset($_POST['multiselect_specs']);
        unset($_POST['multiselect_neighborhood']);
        unset($_POST['multiselect_amenities']);
        unset($_POST['file_upload']);
        foreach($_POST as $key => $value) {
          $property->{$key} = $value;
        }
        if(!is_dir(PUB_ROOT . "/public/properties/" . $property->id))
          mkdir(PUB_ROOT . "/public/properties/" . $property->id);
        $i = count(filesIn(PUB_ROOT . "/public/properties/" . $property->id));
        foreach(filesIn(PUB_ROOT . "/public/temp") as $file) {
          $i++;
          $pi = pathinfo($file);
          rename(PUB_ROOT . "/public/temp/" . $file, PUB_ROOT . "/public/properties/" . $property->id . "/" . $i . "." . $pi['extension']);
        }
        $address = $property->address . ", " . $property->neighborhood->neighborhood . ", " . $property->neighborhood->location->location . ", New York";
        $address = urlencode($address);
        $latlng = latlng($address);
        if(empty($latlng)) {
          $address = $property->address . ", " . $property->neighborhood->location->location . ", New York";
          $address = urlencode($address);
          $latlng = latlng($address);
        }
        $property->lat = $latlng['lat'];
        $property->lng = $latlng['lng'];
        if($property->save()) {
          Activity::create(array('performed_by' => $user->id, 'performed_to' => $property->id, 'table_affected' => 'properties', 'action_taken' => 'update'));
          $error_messages = '<p class="notice">The property <em><strong>' . $property->address . '</strong></em> has successfully been updated.</p>';
        }
      }
    } else if($_GET['sid'] == 'new') {
      if(!empty($_POST)) {
        $specs = "";
        foreach($_POST['specs'] as $spec) {
          if(!is_numeric($spec)) {
            $new = new PropertySpec(array('spec' => $spec));
            $new->save();
            $specs .= $new->id . ",";
          } else
            $specs .= $spec . ",";
        }
        $_POST['specs'] = $specs;
        $amenities = "";
        if(isset($_POST['amenities'])) {
          foreach($_POST['amenities'] as $amenity) {
              $amenities .= $amenity . ",";
          }
        }
        $_POST['amenities'] = $amenities;
        unset($_POST['multiselect_specs']);
        unset($_POST['multiselect_neighborhood']);
        unset($_POST['multiselect_amenities']);
        unset($_POST['file_upload']);
        $property = Property::create($_POST);
        $address = $property->address . ", " . $property->neighborhood->neighborhood . ", " . $property->neighborhood->location->location . ", New York";
        $address = urlencode($address);
        $latlng = latlng($address);
        $property->lat = $latlng['lat'];
        $property->lng = $latlng['lng'];
        if($property->save()) {
          mkdir(PUB_ROOT . "/public/properties/" . $property->id);
          $i = 0;
          foreach(filesIn(PUB_ROOT . "/public/temp") as $file) {
            $i++;
            $pi = pathinfo($file);
            rename(PUB_ROOT . "/public/temp/" . $file, PUB_ROOT . "/public/properties/" . $listing->id . "/" . $i . "." . $pi['extension']);
          }
          Activity::create(array('performed_by' => $user->id, 'performed_to' => $property->id, 'table_affected' => 'properties', 'action_taken' => 'create'));
          header("Location: /user/panel/properties?status=success");
        }
      }
    }
  }
  
  function blast() {
    global $user;
    global $recipients;
    global $mailer;
    global $transport;
    if(!empty($_POST)) {
      $recipients = User::all(array('conditions' => 'receive_blast = 1 AND suspend = 0'));
      
      $html = file_get_contents('http://www.pistilli.com/listings/blast');
      $blast = new Blast();
      $blast->date = time();
      $blast->html = $html;
      $blast->save();
      
      $out = PUB_ROOT . "/public/blasts/" . date("Y-m-d") . "_Blast_" . $blast->id . ".pdf";
      $pdf = new WKPDF();
      $pdf->set_url('http://www.pistilli.com/listings/blast');
      $pdf->set_orientation('Landscape');
      $pdf->set_page_size('Letter');
      $pdf->set_footer('http://www.pistilli.com/app/views/listings/_blast_footer.html.tpl');
      $pdf->set_output($out);
      $pdf->set_margins(5, 10, 18, 10);
      $pdf->render();
      
      $body = str_replace("{id}", $blast->id, $_POST['body']);
      $attachment = Swift_Attachment::fromPath($out)
        ->setFilename(date("Y-m-d") . "_Blast.pdf");
      $message = Swift_Message::newInstance($_POST['subject'])
        ->setFrom(array('noreply@pistilli.com' => 'Pistilli Realty'))
        ->attach($attachment);
      foreach($recipients as $recipient) {
        $message->setTo(array($recipient->email => $recipient->name));
        $body = str_replace("{name}", $recipient->name, $body);
        $body = str_replace("{user_id}", $recipient->id, $body);
        $body = str_replace("{sha1}", $recipient->password, $body);
        $message->setBody($body);
        $mailer->send($message, $failed);
      }
      Activity::create(array('performed_by' => $user->id, 'performed_to' => $blast->id, 'table_affected' => 'blasts', 'action_taken' => 'create'));
      header("Location: /user/panel/blast?status=sent");
    }
  }
  
  function settings() {
    global $user;
    if(!empty($_POST)) {
      $oldpass = $_POST['oldpass'];
      $newpass = $_POST['newpass'];
      $confpass = $_POST['confpass'];
      unset($_POST['oldpass']);
      unset($_POST['newpass']);
      unset($_POST['confpass']);
      if($user->password == sha1($oldpass))
        if($newpass == $confpass)
          $user->password = sha1($newpass);
      foreach($_POST as $key => $value) {
        $user->{$key} = $value;
      }
      if($user->save())
        $error_messages = '<p class="notice">Your account has successfully been updated.</p>';
    }
  }
  
  function retrieve_password() {
    $args = array('conditions' => 'email = "' . $_POST['email'] . '" AND phone = "' . $_POST['phone'] . '"');
    if(User::count($args)) {
      $user = User::find('first', $args);
      $new_pass = substr($user->password, 0, 6);
      $user->password = sha1($new_pass);
      if($user->save()) {
        $message = "Dear " . $user->name . ",\r\nYour new password is:\r\n" . $new_pass . "\r\n\r\nThanks,\r\nThe Pistilli Staff";
        mail($user->email, "Password Retrieval from Pistilli", $message, "From: Pistilli Realty <noreply@pistilli.com>");
        header("Location: /user?status=password_retrieved");
        exit;
      }
    }
  }
  
  function register() {
    $resp = recaptcha_check_answer(PRIVATE_KEY,
                                   $_SERVER["REMOTE_ADDR"],
                                   $_POST["recaptcha_challenge_field"],
                                   $_POST["recaptcha_response_field"]);
    if($resp->is_valid) {
      if(User::count(array('conditions' => 'email = "' . $_POST['email'] . '"'))) {
        header("Location: /user?status=taken");
        exit;
      }
      if($_POST['password'] !== $_POST['password_confirmation']) {
        header("Location: /user?status=nomatch");
        exit;
      }
      
      $userA = array(
        'email'        => $_POST['email'],
        'phone'        => $_POST['phone'],
        'password'     => sha1($_POST['password']),
        'created_at'   => time(),
        'name'         => $_POST['name'],
        'company'      => $_POST['company']
      );
      if($user = User::create($userA)) {
        Activity::create(array('performed_by' => $user->id, 'performed_to' => $user->id, 'table_affected' => 'users', 'action_taken' => 'create'));
        header("Location: /user?status=registered");
        exit;
      }
    } else {
      header("Location: /user?status=captcha");
      exit;
    }
  }
  
  function login() {
    $_POST['password'] = sha1($_POST['password']);
    $where =  "email = '" . $_POST['email'] . "' AND phone = '" . $_POST['phone'] . "' AND password = '" . $_POST['password'] . "'";
    if(User::count(array('conditions' => $where))) {
      $user = User::find('first', array('conditions' => $where));
      if($user->suspend) {
        header("Location: /user?status=suspended");
        exit;
      }
      $_SESSION['user'] = $user->id;
      $user->save();
      if(isset($_POST['remember']))
        setcookie("pistilli", $user->id, time() + (60 * 60 * 24 * 7));
      header("Location: /user/panel");
      exit;
    }
    header("Location: /user?status=notfound");
  }
  
  function logout() {
    if(session_destroy()) {
      if(isset($_COOKIE['pistilli'])) {
        unset($_COOKIE['pistilli']);
        setcookie("pistilli", NULL, -1);
      }
      header("Location: /user");
      exit;
    }
  }
  
  function getDefault() {
    return $this->default;
  }
}
?>