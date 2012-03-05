<?php
	/**
	* 
	* This class is for the lang handler
	* @author Carlos Lopez Camey <c.lopez@kmels.net>
	* @version 1.0
	* @package Chiaj
	* @subpackage classes
	*/

	class lang{
		var $lang; // Code of language
		var $text = array(); // array for the text
		var $directory = "languages"; // base directory of the language files
		var $languages = array(); // list of languages		
		
		/*
		 * The Constructor
		 * @param $lang - The code of language
		 * @param $dir - Base director of language files
		 */

		function Lang($lang, $dir = "") {
			$this->lang = $lang;
			if(!empty($dir)){
				$this->directory = $dir;
			}
			$this->LoadLangFile();
			$this->GetLanguages();
		}
		
		/*
		 * Load the language file
		 */
		function LoadLangFile() {
			$prefix = "";
			$file = $this->directory."/".$this->lang.".lang";
			$open = fopen($file, "r");
			if ($open) {
				while (!feof($open)) {
					$buffer = fgets($open, 4096);
					if((substr($buffer,0,1) == "\n") || (!substr($buffer,0,1))) 
						continue;
						
					if(substr($buffer,0,1) == '[') 
						$prefix = substr($buffer,1,-2);
					else {
						list($key,$value) = preg_split("/ = /", $buffer);
						$this->text[$prefix."_".$key] = substr($value,0,-1);
					}
				}
			}
			fclose($open);
		}
			
		/*
		 * get the text from the file
		 */
		function GetLanguages() {
		   	$lang_folder=opendir($this->directory);
			while (false !== ($file = readdir($lang_folder))) {
				if (($file!='.') and ($file!='..') and preg_match("/.lang$/",$file)) {
					$lines = file($this->directory."/".$file);
					$name = 'Ismeretlen';
					foreach ($lines as $line) {
						if(substr($line,0,5) == 'name ') {
							$this->languages[substr($file,0,strpos($file,'.'))] = substr($line,7,-1);
							break;
						}
					}
				}
			}
		}
		
		/*
		 * Set the base directory of languages files
		 */
		function SetDir($dir) {
			$this->directory = $dir;
		}
		
		
	}
?>
