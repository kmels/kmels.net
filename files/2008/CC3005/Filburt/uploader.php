<?php
require_once('includes/globals.php');

// Where the file is going to be placed 
$target_path = "uploads/" . basename( $_FILES['userfile']['name']); 
$file = $_FILES['userfile'];

//Extensions allowed
$allowedExtensions = array("asm","bin");

//validate file extension
function isAllowedExtension($fileName) {
  global $allowedExtensions;
  return in_array(end(explode(".", $fileName)), $allowedExtensions);
}

//try to upload it
if($file['error'] == UPLOAD_ERR_OK) {
	if(isAllowedExtension($file['name'])) {
		if(move_uploaded_file($file['tmp_name'], $target_path)) {
			$msg = "The file ".  basename( $file['name']). " has been uploaded";
			$class = 'green';
			$Filburt->yasubioArchivo = true;			
			if ((end(explode(".", $file['name']))) == "asm") {//hacer lo de hector{}
				$Filburt->traducirArchivo($target_path);
			} else {										//es binario, hacer lo mio
				$Filburt->interpretarArchivo($target_path);
			}
		} else{
	    	$msg = "There was an error uploading the file, please try again!";
			$class = 'red';
		}
  	} else {
    	$msg = "Invalid file type";
		$class = 'red';
  	}
} else die("Cannot upload");

echo '<span style=\'color:'.$class.';\'>'.$msg.'</span>'
?>

