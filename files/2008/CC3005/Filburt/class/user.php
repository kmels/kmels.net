<?php
	/**
	* 
	* This class is for users
	* @author Carlos Lopez Camey <c.lopez@kmels.net>
	* @version 1.0
	* @package Chiaj
	* @subpackage classes
	*/

	
	class user{
		private $logged_in;
		private $last_error;
		public $username;
		
	/*
	*	Constructor, default value of username is 'guest' and it's not logged in
	*/
		function user($username='guest') {
			$this->username=$username;
			$this->logged_in=false;
		}
		
	/*
	*	Returns true if the user is logged in
	*/
		public function isLoggedIn(){
			return $this->logged_in;
		}

	/*
	*	Returns true if the user exists in the database
	*/
		public function Exists() {
			$query = $GLOBALS['DB']->Execute("SELECT * FROM users WHERE username = '".mysql_escape_string($this->username)."'");
			if ($row = mysql_fetch_object($query)){
				return true;
			}
				$this->last_error = 'User does not exist';
				return false;
		}
	
	/*
	*	Attempt to login user, returns FALSE if the user could not be logged in
	*/
		public function Login(){
			if (!$this->Exists()){
				return false;
			}
			
			if($_POST['login_pass_md5']!='') {
				$password=$_POST['login_pass_md5'];
			} else { // catch users that have JS turned off
				$password=md5($_POST['login_password']);
			}
			
			$query = $GLOBALS['DB']->Execute("SELECT * FROM users WHERE username = '".mysql_escape_string($this->username)."' AND password = '".mysql_escape_string($password)."'"); 
			if ($row = mysql_fetch_object($query)){
				$this->logged_in = true;
				return true;
			}
			else {
				$this->last_error = 'Incorrect password';
				return false;
			}
		}

	/*
	* Get the last Error
	*/
		public function GetLastError(){
			return $this->last_error;
		}
	
	/*
	* Validate Email, returns TRUE only if the E-mail is valid
	*/
		public function ValidateEmail($email){
			return preg_match('/^([A-Z0-9._%-]+)@([A-Z0-9.-]+)\.([A-Z]{2,6})$/i',$email);
		}
	
	} //class
?>