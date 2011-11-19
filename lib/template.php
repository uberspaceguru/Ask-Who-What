<?php
class template {  
  function yield($partial = ACTION, $vars = false) {
    if($vars !== false) {
      foreach($vars as $key => $value)
        ${$key} = $value;
    }
    $location = DOC_ROOT . "app/views/" . CONTROLLER . "/" . $partial . ".html.tpl";
    if(file_exists($location))
      if(include($location))
        return true;
        
    $location = DOC_ROOT . "app/views/" . CONTROLLER . "/_" . $partial . ".html.tpl";
    if(file_exists($location)) {
      if(include($location))
        return true;
    } else {
      $cont = new $controller;
      $location = DOC_ROOT . "app/views/" . CONTROLLER . "/" . $cont->getDefault() . ".html.tpl";
      if(file_exists($location))
        if(include($location))
          return true;
    }
    return false;
  }
  
  function render($vars = false) {
    if($vars !== false) {
      foreach($vars as $key => $value)
        ${$key} = $value;
    }
    $location = DOC_ROOT . "app/views/layouts/" . ACTION . ".html.tpl";
    if(file_exists($location))
      if(include($location))
        return true;
    
    $location = DOC_ROOT . "app/views/layouts/" . CONTROLLER . ".html.tpl";
    if(file_exists($location))
      if(include($location))
        return true;
    return false;
  }
  
  private function get_assets() {
    $filename = DOC_ROOT . "config/assets.yml";
    $yaml = new sfYamlParser();
    $assets = $yaml->parse(file_get_contents($filename));
    return $assets;
  }
  
  function style_line($css, $key = null) {
    $return = "";
    $file = pathinfo($css);
    if($file['filename'] == "*") {
      $dir = scandir(PUB_ROOT . $file['dirname']);
      foreach($dir as $dfile) {
        $pinfo = pathinfo($dfile);
        if($file['extension'] == $pinfo['extension']) {
          $return .= "<link rel=\"stylesheet\" type=\"text/css\" href=\"". $file['dirname'] . "/" . $dfile . "?" . time() . "\"";
          if(!empty($key))
            $return .= " media=\"" . $key . "\"";
          $return .=">\r\n";
        }
      }
    } else {
      $return .= "<link rel=\"stylesheet\" type=\"text/css\" href=\"". $css . "?" . time() . "\"";
      if(!empty($key))
        $return .= " media=\"" . $key . "\"";
      $return .=">\r\n";
    }
    return $return;
  }
  
  function include_stylesheets($arr) {
    $assets = $this->get_assets();
    $return = "";
    foreach($arr as $value) {
      foreach($assets['stylesheets'][$value] as $key => $css) {
        if(is_array($css)) {
          foreach($css as $cssInner)
            $return .= $this->style_line($cssInner, $key);
        } else {
          $return .= $this->style_line($css);
        }
      }
    }
    print $return;
  }
  
  function include_javascripts($arr) {
    $assets = $this->get_assets();
    $return = "";
    foreach($arr as $value) {
      foreach($assets['javascripts'][$value] as $js) {
        $file = pathinfo($js);
        if($file['filename'] == "*") {
          $dir = scandir(PUB_ROOT . $file['dirname']);
          foreach($dir as $dfile) {
            $pinfo = pathinfo($dfile);
            if($file['extension'] == $pinfo['extension'])              
              $return .= "<script type=\"text/javascript\" src=\"". $file['dirname'] . "/" . $dfile . "?" . time() . "\"></script>\r\n";
          }
        } else {
          $parsed = parse_url($js);
          if(isset($parsed['query']))
            $js .= "&amp;" . time();
          else
            $js .= "?" . time();
          $return .= "<script type=\"text/javascript\" src=\"". $js . "\"></script>\r\n";
        }
      }
    }
    print $return;
  }
}
?>