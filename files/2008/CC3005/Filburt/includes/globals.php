<?php
	require_once("class/filburt.php");
	session_start();
	
	global $Filburt;
	
	//check if the filburt's object cookie is already set and unserialize it, else create it
	if (isset($_SESSION['Filburt'])){		
		if ($_SESSION['Filburt'] instanceof filburt){ //ya esta asi, no hacer nada mas
			$Filburt = $_SESSION['Filburt'];
			if (isset($_GET['lang'])){ //cambiar lenguaje
				$Filburt->InstanceLanguage($_GET['lang']);
			}
		} elseif (unserialize($_SESSION['Filburt']) instanceof filburt){
			$_SESSION['Filburt'] = unserialize($_SESSION['Filburt']);
			$Filburt = $_SESSION['Filburt'];
			if (isset($_GET['lang'])){ //cambiar lenguaje
				$Filburt->InstanceLanguage($_GET['lang']);
			}
		} else {
			echo 'caso 3 WTF?!?!?!?? asfASFas ksdjfk sadjfkl jasdfklj as;kdfj ksadj sdfjk ;skdfj ;ajsf a;ksdfj ;ksdj kadf dsj k!';
		}
	}
	else {
		$Filburt = new filburt();
		$_SESSION['Filburt'] = serialize($Filburt);
	}
	
	
?>

