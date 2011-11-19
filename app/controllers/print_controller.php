<?php
class PrintController {
  var $default = "index";
  
  function index() {
    if($_GET['url']) {
      $out = PUB_ROOT . "/temp/Print.pdf";
      $pdf = new WKPDF();
      $pdf->set_url($_GET['url']);
      $pdf->set_output($out);
      $pdf->set_page_size('Letter');
      $pdf->set_stylesheet('print');
      $pdf->set_margins(5, 10, 18, 10);
      $pdf->render();
      
      $pdfContents = file_get_contents($out);
      header('Content-Description: File Transfer');
      header('Cache-Control: public, must-revalidate, max-age=0'); // HTTP/1.1
      header('Pragma: public');
      header('Expires: Sat, 26 Jul 1997 05:00:00 GMT'); // Date in the past
      header('Last-Modified: '.gmdate('D, d M Y H:i:s').' GMT');
      // force download dialog
      header('Content-Type: application/force-download');
      header('Content-Type: application/octet-stream', false);
      header('Content-Type: application/download', false);
      header('Content-Type: application/pdf', false);
      // use the Content-Disposition header to supply a recommended filename
      header('Content-Disposition: attachment; filename="'.basename("Print.pdf").'";');
      header('Content-Transfer-Encoding: binary');
      header('Content-Length: '.strlen($pdfContents));
      echo $pdfContents;
    }
  }
  
  function getDefault() {
    return $this->default;
  }
}
?>