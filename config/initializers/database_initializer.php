<?php
class databaseInitializer {
  public $initialized = false;
  
  function __construct($which, $filename = false) {
    if(!$filename)
      $filename = DOC_ROOT . "config/database.yml";
      
    $info = $this->load_yaml($which, $filename);
    if($this->connect($info['host'], $info['username'], $info['password']))
      if($this->select_db($info['database']))
        $initialized = true;
  }
  
  function select_db($db) {
    if(mysql_select_db($db))
      return true;
    return false;
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
}
?>