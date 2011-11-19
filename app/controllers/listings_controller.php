<?php
class ListingsController {
  var $default = "index";
  
  function index() {
    global $listings;
    global $listingCount;
    global $page;
    global $start;
    global $end;
    global $next;
    global $prev;
    global $midpts;
    
    $midpts = Property::getPubMidPts();  
    
    if(isset($_GET['page'])) {
      if(is_numeric($_GET['page'])) {
        $page = $_GET['page'];
        $listings = Listing::find('all', array('order' => 'price desc', 'limit' => 20, 'conditions' => 'status_2_id = 4 AND status_1_id != 4', 'offset' => (($_GET['page'] - 1) * 20)));
        $listingCount = Listing::count(array('conditions' => 'status_2_id = 4 AND status_1_id != 4'));
        $start = (($page - 1) * 20) + 1;
        $end = ($page - 1) * 20 + count($listings);
      }
    } else if(isset($_GET['property_id'])) {
      if(is_numeric($_GET['property_id'])) {
        $page = 1;
        $start = 1;
        $listings = Listing::find('all', array('order' => 'price desc', 'limit' => 20, 'offset' => 0, 'conditions' => 'status_2_id = 4 AND status_1_id != 4 AND property_id = ' . $_GET['property_id']));
        $listingCount = Listing::count(array('conditions' => 'status_2_id = 4 AND status_1_id != 4 AND property_id = ' . $_GET['property_id']));
        $end = count($listings);
      }
    } else {
      $page = 1;
      $start = 1;
      $listings = Listing::find('all', array('order' => 'price desc', 'limit' => 20, 'offset' => 0, 'conditions' => 'status_2_id = 4 AND status_1_id != 4'));
      $listingCount = Listing::count(array('conditions' => 'status_2_id = 4 AND status_1_id != 4'));
      $end = count($listings);
    }
    if($end == $listingCount)
      $next = false;
    else
      $next = $page + 1;
  
    if($page > 1)
      $prev = $page - 1;
    else
      $prev = false;
  }
  
  function blast() {
    if(isset($_GET['id']))
      if(is_numeric($_GET['id']))
        die(Blast::find($_GET['id'])->html);
    global $listings;
    $listings = array();
    foreach(Location::all(array('order' => 'location asc')) as $location)
      foreach($location->neighborhoods as $neighborhood)
        foreach($neighborhood->properties as $property)
          foreach($property->listings as $listing)
            if($listing->status_2_id != 3)
              $listings[] = $listing;
  }
  
  function show() {
    global $listing;
    global $subs;
    $listing = Listing::find($_GET['id']);
    $prop_specs = explode(",", $listing->property->specs);
    $listing->property->specs = "";
    foreach($prop_specs as $spec_id) {
      if(is_numeric($spec_id))
        $listing->property->specs .= PropertySpec::find($spec_id)->spec . "\n";
    }
    $listing->property->specs = trim($listing->property->specs);
    $apt_specs = explode(",", $listing->specs);
    $listing->specs = "";
    foreach($apt_specs as $spec_id) {
      if(is_numeric($spec_id))
        $listing->specs .= ListingSpec::find($spec_id)->spec . "\n";
    }
    $listing->specs = trim($listing->specs);
    $subs = Subway::all(array('select' => '*, ( 3959 * acos( cos( radians(' . $listing->property->lat . ') ) * cos( radians( Latitude ) ) * cos( radians( Longitude ) - radians(' . $listing->property->lng . ') ) + sin( radians(' . $listing->property->lat . ') ) * sin( radians( Latitude ) ) ) ) AS distance', /* 'having' => 'distance < .5', */ 'group' => 'station_name', 'order' => 'distance asc', 'limit' => 3));
  }
  
  function search() {
    global $listings;
    global $listingCount;
    global $page;
    global $start;
    global $end;
    global $next;
    global $prev;
    global $midpts;
    
    $midpts = Property::getPubMidPts();
    $where = "";
    foreach($_GET['search'] as $key => $value) {
      if($value != "Any") {
        if($key == 'max')
          $where .= 'price' . " <= " . str_replace(",", "", str_replace("$", "", $value)) . " AND ";
        else if($key == 'min')
          $where .= 'price' . " >= " . str_replace(",", "", str_replace("$", "", $value)) . " AND ";
        else if($key == 'hood') {
          if(Property::count(array('select' => 'id', 'conditions' => 'neighborhood_id = ' . $value)) > 0) {
            $properties = Property::find('all', array('select' => 'id', 'conditions' => 'neighborhood_id = ' . $value));
            $property_ids = array();
            foreach($properties as $property) {
              $property_ids[] = $property->id;
            }
            $where .= "property_id IN (" . array_to_csv($property_ids) . ") AND ";
          } else {
            $where .= "id = 0 AND ";
            break;
          }
        } else if($key == 'loc') {
          if(Neighborhood::count(array('select' => 'id', 'conditions' => 'location_id = ' . $value)) > 0) {
            $neighborhoods = Neighborhood::find('all', array('select' => 'id', 'conditions' => 'location_id = ' . $value));
            $neighborhood_ids = array();
            foreach($neighborhoods as $neighborhood) {
              $neighborhood_ids[] = $neighborhood->id;
            }
            if(Property::count(array('select' => 'id', 'conditions' => 'neighborhood_id IN (' . array_to_csv($neighborhood_ids) . ')')) > 0) {
              $properties = Property::find('all', array(
                'select' => 'id',
                'conditions' => 'neighborhood_id IN (' . array_to_csv($neighborhood_ids) . ')'
              ));
              $property_ids = array();
              foreach($properties as $property) {
                $property_ids[] = $property->id;
              }
              $where .= "property_id IN (" . array_to_csv($property_ids) . ") AND ";
            }
          } else {
            $where .= "id = 0 AND ";
            break;
          }
        } else
          $where .= $key . " = " . $value . " AND ";
      }
    }
    $where = substr($where, 0, -5);
    $options = array(
      'order' => 'price desc',
      'conditions' => $where . " AND status_2_id = 4 AND status_1_id != 4",
      'limit' => 20
    );
    if(strlen($where) > 0) {
      if(isset($_GET['page'])) {
        if(is_numeric($_GET['page'])) {
          $page = $_GET['page'];
          $options['offset'] = (($_GET['page'] - 1) * 20);
          $listings = Listing::find('all', $options);
          $start = (($page - 1) * 20) + 1;
          $end = ($page - 1) * 20 + count($listings);
        }
      } else {
        $page = 1;
        $start = 1;
        $listings = Listing::find('all', $options);
        $end = count($listings);
      }
      $listingCount = Listing::count(array('conditions' => $options['conditions']));
      if($end == $listingCount)
        $next = false;
      else
        $next = $page + 1;
  
      if($page > 1)
        $prev = $page - 1;
      else
        $prev = false;
    } else
      header("Location: /listings");
  }
  
  function getDefault() {
    return $this->default;
  }
}
?>