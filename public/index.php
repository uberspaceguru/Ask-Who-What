<?php
session_start();
setlocale(LC_MONETARY, 'en_US');
date_default_timezone_set("America/New_York");
error_reporting(E_ALL|E_STRICT);
ini_set('display_errors', 'on');

define('DOC_ROOT', $_SERVER['DOCUMENT_ROOT'] . "/");
define('PUB_ROOT', DOC_ROOT . "public");
require_once(DOC_ROOT . "config/bootstrap.php");

?>