<?php
class controller {
  static function load() {
    if(substr(CONTROLLER, -1, 1) == 's') {
      if(file_exists(DOC_ROOT . "app/models/" . substr(CONTROLLER, 0, -1) . ".php"))
        require_once(DOC_ROOT . "app/models/" . substr(CONTROLLER, 0, -1) . ".php");
    } else {
      if(file_exists(DOC_ROOT . "app/models/" . CONTROLLER . ".php"))
        require_once(DOC_ROOT . "app/models/" . CONTROLLER . ".php");
    }
    
    if(file_exists(DOC_ROOT . "app/controllers/" . CONTROLLER . "_controller.php"))
      require_once(DOC_ROOT . "app/controllers/" . CONTROLLER . "_controller.php");
    else {
      require_once(PUB_ROOT . "/404.html");
      exit;
    }
  }
  
  static function getControllerName() {
    return ucwords(CONTROLLER) . "Controller";
  }
}
?>