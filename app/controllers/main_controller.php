<?php
class MainController {
  var $default = "home";
  
  function home() {
    global $midpts;
    $midpts = Property::getPubMidPts();  
  }
  
  function contact() {
    global $message;
    global $passed;
    $passed = false;
    $to = "blink182av@gmail.com";
    if(!empty($_POST['contact']['name'])) {
      if(!empty($_POST['contact']['email'])) {
        if(!empty($_POST['contact']['subject'])) {
          if(!empty($_POST['contact']['message'])) {
            if(mail($to, $_POST['contact']['subject'], $_POST['contact']['message'], 'From: ' . $_POST['contact']['name'] . ' <' . $_POST['contact']['email'] . '>')) {
              $message = "Thank you for your email!  You can respect a response within the next 48 hours.<br><br>Regards,<br>The Pistilli Staff";
              $passed = true;
              echo "worked";
            } 
          }
        }
      }
    }
  }
  
  function getDefault() {
    return $this->default;
  }
}
?>