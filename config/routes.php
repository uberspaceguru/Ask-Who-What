<?php
// DEFAULT CONTROLLER
$default = "main";

foreach($_GET as $key => $value)
  ${$key} = $value;

if(!isset($controller))
  define('CONTROLLER', $default);
else
  define('CONTROLLER', $controller);
  
controller::load();

$controller = controller::getControllerName();
${CONTROLLER} = new $controller();

switch(CONTROLLER) {
  case "listings":
    if(isset($action)) {
      if(is_numeric($action)) {
        $_GET['id'] = $action;
        $action = "show";
      }
    }
    if(isset($_GET['search']))
      $action = "search";
    break;
  case "main":
    if(isset($_POST['contact']))
      $action = "contact";
    break;
  case "user":
    if(isset($action)) {
      if($action == 'panel') {
        if(isset($id))
          define('ID', $id);
        else
          define('ID', 'index');
      }
    }
    break;
}


if(!isset($action))
  define('ACTION', ${CONTROLLER}->getDefault());
else
  define('ACTION', $action);

if(method_exists(${CONTROLLER}, ACTION))
  ${CONTROLLER}->{ACTION}();
else {
  require_once(PUB_ROOT . "/404.html");
  exit;
}
?>