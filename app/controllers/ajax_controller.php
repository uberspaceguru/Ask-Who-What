<?php
class AjaxController {
  var $default = "error";
  
  function error() {
    
  }
  
  function recent() {
    global $activities;
    if(isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $offset = ($_GET['id'] + 1) * 10;
        if(Activity::count(array('order' => 'created_at desc')) > $offset)
          $activities = Activity::all(array('order' => 'created_at desc', 'limit' => 10, 'offset' => $offset));
        else
          return false;
      }
    }
  }
  
  function filterListings() {
    global $listings;
    global $user;
    $user = User::find($_SESSION['user']);
    if(isset($_GET['id'])) {
      switch($_GET['id']) {
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
      $user->listing_filter = $_GET['id'];
      $user->save();
    }
  }
  
  function commercial() {
    global $listings;
    global $next;
    
    if(!isset($_GET['sid']))
      $_GET['sid'] = 1;
    if($_GET['id'] == 'All') {
      $listings = CommercialListing::all(array('limit' => 2, 'offset' => (($_GET['sid']-1) * 2)));
      $listingCount = CommercialListing::count();
      $end = ($_GET['sid'] - 1) * 2 + count($listings);
    } else {
      $comtype = Comtype::first(array('conditions' => 'type = "' . $_GET['id'] . '"'));
      $listings = CommercialListing::all(array('conditions' => 'comtype_id LIKE "%' . $comtype->id . '%"', 'limit' => 2, 'offset' => (($_GET['sid']-1) * 2)));
      $listingCount = CommercialListing::count(array('conditions' => 'comtype_id LIKE "%' . $comtype->id . '%"'));
      $end = ($_GET['sid'] - 1) * 2 + count($listings);
    }
    
    if($end == $listingCount)
      $next = false;
    else
      $next = $_GET['sid'] + 1;
  }
  
  function blastMe() {
    if(isset($_SESSION['user'])) {
      $user = User::find($_SESSION['user']);
      if($user->receive_blast) {
        $user->receive_blast = 0;
        if($user->save()) {
          Activity::create(array('performed_by' => $user->id, 'performed_to' => $user->id, 'table_affected' => 'users', 'action_taken' => 'unsubscribe'));
          echo "/images/panel/icons/unchecked.png";
          return true;
        }
      } else {
        $user->receive_blast = 1;
        if($user->save()) {
          Activity::create(array('performed_by' => $user->id, 'performed_to' => $user->id, 'table_affected' => 'users', 'action_taken' => 'subscribe'));
          echo "/images/panel/icons/checked.png";
          return true;
        }
      }
    }
  }
  
  function delProp() {
    if(isset($_SESSION['user']) && isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $property = Property::find($_GET['id']);
        if(PropertiesDeleted::create($property->to_array()) && $property->delete()) {
          Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $property->id, 'table_affected' => 'properties', 'action_taken' => 'delete'));
          echo true;
          exit;
        }
      }
    }
  }
  
  function delComListing() {
    if(isset($_SESSION['user']) && isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $listing = CommercialListing::find($_GET['id']);
        if(CommercialListingsDeleted::create($listing->to_array()) && $listing->delete()) {
          Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $listing->id, 'table_affected' => 'commercial_listings', 'action_taken' => 'delete'));
          echo true;
          exit;
        }
      }
    }
  }
  
  function delListing() {
    if(isset($_SESSION['user']) && isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $listing = Listing::find($_GET['id']);
        if(ListingsDeleted::create($listing->to_array()) && $listing->delete()) {
          Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $listing->id, 'table_affected' => 'listings', 'action_taken' => 'delete'));
          echo true;
          exit;
        }
      }
    }
  }
  
  function newRow() {
    
  }
  
  function comGalOrder() {
    if(isset($_SESSION['user']) && isset($_GET['id'])) {
      $dir = PUB_ROOT . "/public/commercial/" . $_GET['id'];
      foreach($_POST['file'] as $key => $photo) {
        $filename = findFilename($photo, $dir);
        $pi = pathinfo($dir . "/" . $filename);
        echo $filename." ";
        rename($dir . "/" . $filename, $dir . "/" . ($key + 1) . "_new" . "." . $pi['extension']);
      }
      foreach(filesIn($dir) as $file) {
        rename($dir . "/" . $file, $dir . "/" . str_replace('_new', '', $file));
      }
      return true;
    }
  }
  
  function propGalOrder() {
    if(isset($_SESSION['user']) && isset($_GET['id'])) {
      $dir = PUB_ROOT . "/public/properties/" . $_GET['id'];
      foreach($_POST['file'] as $key => $photo) {
        $filename = findFilename($photo, $dir);
        $pi = pathinfo($dir . "/" . $filename);
        echo $filename." ";
        rename($dir . "/" . $filename, $dir . "/" . ($key + 1) . "_new" . "." . $pi['extension']);
      }
      foreach(filesIn($dir) as $file) {
        rename($dir . "/" . $file, $dir . "/" . str_replace('_new', '', $file));
      }
      return true;
    }
  }
  
  function galleryOrder() {
    if(isset($_SESSION['user'])) {
      foreach(json_decode($_POST['order']) as $key => $photo) {
        $photo = Photo::find(str_replace('photo_', '', $photo));
        $photo->sort = $key + 1;
        $photo->save();
      }
      return true;
    }
  }
  
  function delFile() {
    if(isset($_SESSION['user'])) {
      $path = preg_replace("/\?[0-9]*/", "", PUB_ROOT . $_POST['src']);
      if(unlink($path)) {
        echo true;
        exit;
      }
    }
  }
  
  function delPhoto() {
    if(isset($_SESSION['user']) && isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $photo = Photo::find($_GET['id']);
        $path = PUB_ROOT . "/public/gallery/" . $photo->id . "." . $photo->ext;
        if(unlink($path) && $photo->delete()) {
          echo true;
          exit;
        }
      }
    }
  }
  
  function delUser() {
    if(isset($_SESSION['user']) && isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $user = User::find($_GET['id']);
        if(UsersDeleted::create($user->to_array()) && $user->delete()) {
          Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $user->id, 'table_affected' => 'users', 'action_taken' => 'delete'));
          echo true;
          exit;
        }
      }
    }
  }
  
  function comListAvail() {
    if(isset($_SESSION['user']) && isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $listing = CommercialListing::find($_GET['id']);
        if($listing->avail) {
          $listing->avail = 0;
          if($listing->save()) {
            Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $listing->id, 'table_affected' => 'commercial_listings', 'action_taken' => 'update'));
            echo "/images/panel/icons/unchecked.png";
            exit;
          }
        } else {
          $listing->avail = 1;
          if($listing->save()) {
            Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $listing->id, 'table_affected' => 'commercial_listings', 'action_taken' => 'update'));
            echo "/images/panel/icons/checked.png";
            exit;
          }
        }
      }
    }
  }
  
  function listReady() {
    if(isset($_SESSION['user']) && isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $listing = Listing::find($_GET['id']);
        if($listing->ready) {
          $listing->ready = 0;
          if($listing->save()) {
            Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $listing->id, 'table_affected' => 'listings', 'action_taken' => 'update'));
            echo "/images/panel/icons/unchecked.png";
            exit;
          }
        } else {
          $listing->ready = 1;
          if($listing->save()) {
            Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $listing->id, 'table_affected' => 'listings', 'action_taken' => 'update'));
            echo "/images/panel/icons/checked.png";
            exit;
          }
        }
      }
    }
  }
  
  function listHold() {
    if(isset($_SESSION['user']) && isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $listing = Listing::find($_GET['id']);
        if($listing->hold) {
          $listing->hold = 0;
          if($listing->save()) {
            Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $listing->id, 'table_affected' => 'listings', 'action_taken' => 'update'));
            echo "/images/panel/icons/unchecked.png";
            exit;
          }
        } else {
          $listing->hold = 1;
          if($listing->save()) {
            Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $listing->id, 'table_affected' => 'listings', 'action_taken' => 'update'));
            echo "/images/panel/icons/checked.png";
            exit;
          }
        }
      }
    }
  }
  
  function listAvail() {
    if(isset($_SESSION['user']) && isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $listing = Listing::find($_GET['id']);
        if($listing->avail) {
          $listing->avail = 0;
          if($listing->save()) {
            Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $listing->id, 'table_affected' => 'listings', 'action_taken' => 'update'));
            echo "/images/panel/icons/unchecked.png";
            exit;
          }
        } else {
          $listing->avail = 1;
          if($listing->save()) {
            Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $listing->id, 'table_affected' => 'listings', 'action_taken' => 'update'));
            echo "/images/panel/icons/checked.png";
            exit;
          }
        }
      }
    }
  }
  
  function suspend() {
    if(isset($_SESSION['user']) && isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $user = User::find($_GET['id']);
        if($user->suspend) {
          $user->suspend = 0;
          if($user->save()) {
            Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $user->id, 'table_affected' => 'users', 'action_taken' => 'update'));
            echo "/images/panel/icons/unchecked.png";
            exit;
          }
        } else {
          $user->suspend = 1;
          if($user->save()) {
            Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $user->id, 'table_affected' => 'users', 'action_taken' => 'update'));
            echo "/images/panel/icons/checked.png";
            exit;
          }
        }
      }
    }
  }
  
  function blast() {
    if(isset($_SESSION['user']) && isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $user = User::find($_GET['id']);
        if($user->receive_blast) {
          $user->receive_blast = 0;
          if($user->save()) {
            Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $user->id, 'table_affected' => 'users', 'action_taken' => 'unsubscribe'));
            echo "/images/panel/icons/unchecked.png";
            exit;
          }
        } else {
          $user->receive_blast = 1;
          if($user->save()) {
            Activity::create(array('performed_by' => $_SESSION['user'], 'performed_to' => $user->id, 'table_affected' => 'users', 'action_taken' => 'subscribe'));
            echo "/images/panel/icons/checked.png";
            exit;
          }
        }
      }
    }
  }
  
  function gallery() {
  }
  
  function propGal() {
    global $photos;
    if(isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $photos = filesIn(PUB_ROOT . "/public/properties/" . $_GET['id']);
      }
    }
  }
  
  function comGal() {
    global $photos;
    if(isset($_GET['id'])) {
      if(is_numeric($_GET['id'])) {
        $photos = filesIn(PUB_ROOT . "/public/commercial/" . $_GET['id']);
      }
    }
  }
  
  function contact() {
    global $message;
    global $passed;
    global $mailer;
    global $transport;
    $passed = false;
    $to = "info@pistilli.com";
    if(!empty($_POST['contact']['name'])) {
      if(!empty($_POST['contact']['email'])) {
        if(!empty($_POST['contact']['subject'])) {
          if(!empty($_POST['contact']['message'])) {
            $message = Swift_Message::newInstance($_POST['contact']['subject'])
              ->setFrom(array($_POST['contact']['email'] =>$_POST['contact']['name']))
              ->setTo(array($to))
              ->setBody($_POST['contact']['message']);
            if($mailer->send($message)) {
              $message = "Thank you for your email!  You can expect a response within the next 48 hours.<small><br><br>Regards,<br>The Pistilli Staff</small>";
              $passed = true;
            }
          }
        }
      }
    }
    
    if(!$passed) {
      $message = "Something went wrong. Please double check the form and try again.";
    }
  }
  
  function getDefault() {
    return $this->default;
  }
}
?>