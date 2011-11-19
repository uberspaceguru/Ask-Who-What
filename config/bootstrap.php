<?php
define("DB_TO_LOAD", "main");

/*** Include Dependencies/3rd Party Plugins ***/
require_once(DOC_ROOT . "vendor/plugins/sfYaml/sfYamlParser.php");
require_once(DOC_ROOT . "vendor/plugins/ActiveRecord/ActiveRecord.php");
require_once(DOC_ROOT . "vendor/plugins/recaptchalib.php");
#require_once(DOC_ROOT . "vendor/plugins/wkhtmltopdf/wkhtmltopdf.php");
#require_once(DOC_ROOT . "vendor/plugins/html2pdf/html2pdf.class.php");
require_once(DOC_ROOT . "vendor/plugins/swift-mailer/lib/swift_required.php");
#require_once(DOC_ROOT . "vendor/plugins/phmagick/phmagick.php");
define("PUBLIC_KEY", "6Lepf8YSAAAAAPz7h7TtyfNplS3mhEfkIi7Hw2pA");
define("PRIVATE_KEY", "6Lepf8YSAAAAAAGOQqb-bv89C4Qt_fOloZt7T8tc");

//Create the Transport
$transport = Swift_SmtpTransport::newInstance('localhost', 25);

//Create the Mailer using your created Transport
$mailer = Swift_Mailer::newInstance($transport);

require_once(DOC_ROOT . "lib/functions.php");
ActiveRecord\Config::initialize(function($cfg)
{
    $db = getDbInfo(DB_TO_LOAD);
    $cfg->set_model_directory(DOC_ROOT . "app/models");
    $cfg->set_connections(array(
        DB_TO_LOAD => $db["socket"] . "://" . $db["username"] . ":" . $db["password"] . "@" . $db["host"] . "/" . $db["database"]));
    $cfg->set_default_connection(DB_TO_LOAD);
});


require_once(DOC_ROOT . "lib/controller.php");
require_once(DOC_ROOT . "config/routes.php");
require_once(DOC_ROOT . "lib/template.php");
$template = new template();
$template->render(get_defined_vars());

?>