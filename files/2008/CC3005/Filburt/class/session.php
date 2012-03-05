<?php
	/**
	* 
	* This class is for users
	* @author Carlos Lopez Camey <c.lopez@kmels.net>
	* @version 1.0
	* @package Chiaj
	* @subpackage classes
	*/
	
	class session{
		function session() {
			session_start();
		}
	
		public function is_set($varname) {
			return (isset($_SESSION[$varname]));
		}

		public function get_var($varname) {
			return $_SESSION[$varname];
		}
		
		public function delete_var($varname) {
			unset($_SESSION[$varname]);
		}

		public function set_var($varname, $varval){
			if (!varname || !$varval){
				return false;
			}
			$_SESSION[$varname] = $varval;
		}
	}
?>