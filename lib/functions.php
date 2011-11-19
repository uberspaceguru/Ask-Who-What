<?php
function getDbInfo($which, $filename = false) {
  if(!$filename)
    $filename = DOC_ROOT . "config/database.yml";
    
  $info = load_yaml($which, $filename);
  return $info;
  /*
  if($this->connect($info['host'], $info['username'], $info['password']))
    if($this->select_db($info['database']))
      $initialized = true;
  */
}

function select_db($db) {
  if(mysql_select_db($db))
    return true;
  return false;
}

function selId($id) {
  if($id == ID)
    echo 'class="sel"';
}

function filesIn($folder) {
  $files = array();
  foreach(scandir($folder) as $file) {
    if($file != '..' && $file != '.')
      $files[] = $file;
  }
  natsort($files);
  return $files;
}

function pageVal($pageNum) {
  $current = parse_url($_SERVER['REQUEST_URI']);
  if(empty($current['query']))
    return "?page=" . $pageNum;
  if(strpos($_SERVER['REQUEST_URI'], "page=") > 0)
    return preg_replace("/page=[0-9]/", "page=" . $pageNum, $_SERVER['REQUEST_URI']);
  return $_SERVER['REQUEST_URI'] . "&amp;page=" . $pageNum;
}

function avg($nums) {
  return (array_sum($nums) / count($nums));
}

function deleteOutliers($nums) {
  $iqr  = IQR($nums);
  $high = $iqr['q3'] + ($iqr['iqr'] * 1.5);
  $low  = $iqr['q1'] - ($iqr['iqr'] * 1.5);
  $numsFinal = array();
  foreach($nums as $num) {
    if($num <= $high && $num >= $low)
      $numsFinal[] = $num;
  }
  return $numsFinal;
}

function median($nums) {
  sort($nums);
  $count = count($nums);
  $intval = intval($count / 2);
  if($count % 2 == 0) {
    $median = ($nums[$intval] + $nums[$intval + 1]) / 2;
  } else {
    $median = $nums[$intval];
  }
  return $median;
}

function IQR($nums) {
  sort($nums);
  $median = median($nums);
  
  $top = array();
  $bottom = array();
  
  foreach($nums as $num)
    if($num < $median)
      $bottom[] = $num;
    else if($num > $median)
      $top[] = $num;

  $q1 = median($bottom);
  $q3 = median($top);
  $iqr = abs($q3 - $q1);
  return array('iqr' => $iqr, 'q1' => $q1, 'q3' => $q3);
}

function selected($id, $possible) {
  if($id == $possible)
    echo 'selected="selected"';
}

function getGalleryPhoto($id, $ext) {
  return "/public/gallery/" . $id . "." . $ext;
}

function selectedMult($ids, $possible) {
  $idA = explode(",", $ids);
  if(in_array($possible, $idA))
    echo 'selected="selected"';
}

function checked($bool, $negative = false) {
  if ($bool == 1 && !$negative)
    return 'checked="checked"';
  else if ($bool == 0 && $negative)
    return 'checked="checked"';
}

function upload4ext($file, $dir, $id) {
  $info = pathinfo($file['name']);
  $ext = $info['extension'];
  if(move_uploaded_file($file['tmp_name'], $dir . $id . "." . $ext))
    return $ext;
  return false;
}

function latlng($address) {
  $requrl = "http://maps.googleapis.com/maps/api/geocode/json?address=" . $address . "&sensor=false";
  $json = file_get_contents($requrl);
  $contents = json_decode($json, true);
  if(!empty($contents['results'][0]['geometry']['location']))
    return $contents['results'][0]['geometry']['location'];
  return false;
}

function findFilename($filename, $dir) {
  foreach(filesIn($dir) as $file) {
    $pi = pathinfo($dir . "/" . $file);
    if($pi['filename'] == $filename)
      return $file;
  }
}

function nl2array($string) {
  return explode("\n", $string);
}

/*
function cycle($one, $two) {
  if(!isset($c))
    $c = true;
  
  if($c) {
    echo $one;
    $c = false;
  } else {
    echo $two;
    $c = true;
  }
}
*/

$_cycles = array();
function cycle() {
	global $_cycles;
	$args = func_get_args();
	$last_arg = count($args) - 1;
	$name = 'default';
	if (is_array($args[$last_arg])) {
		$name = $args[$last_arg]['name'];
		unset($args[$last_arg]);
	}
	@$_cycles[$name] = (null === $_cycles[$name] || $_cycles[$name] + 1 >= count($args)) ? 0 : $_cycles[$name] + 1;
	return $args[$_cycles[$name]];
}
	
function reset_cycle($name = 'default') {
	global $_cycles;
	@$_cycles[$name] = null;
}

function connect($host, $user, $pass) {
  if(mysql_connect($host, $user, $pass))
    return true;
  return false;
}

function load_yaml($which, $filename) {
  if(file_exists($filename)) {
    $yaml = new sfYamlParser();
    $info = $yaml->parse(file_get_contents($filename));
    return $info[$which];
  }
  return false;
}

function array_to_csv($array)
{
	if (!is_array($array))
	  return false;
	
	$temp = "";
	foreach ($array as $value) {
		$temp .= $value . ", ";
	}
	
	$temp = substr($temp, 0, -2);
	
	return $temp;
}
?>