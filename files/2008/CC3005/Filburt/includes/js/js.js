	function doOnFilburt(action){
		var params = "action="+action;
		var ultimaaccion = action

		new Ajax.Request(
			"process.php",
			{
				method: 'get',
				parameters: params,
				onComplete: showResponsePues
			});
	}
	
	function showResponsePues(originalRequest)
	{
		$('response_note').update(originalRequest.responseText);
		cargarSimulador();
	}
	
	function simulateUpload(){
	      $('sucess_message').innerHTML = 'Loading..'
	      return true;
	}

	function showUploadSucess(success){
	      var result = '';
	      if (success == 1){
	         result = '<span class="msg">The file was uploaded successfully!<\/span><br/><br/>';
	      }
	      else {
	         result = '<span class="error">There was an error during file upload!<\/span><br/><br/>';
	      }
			$('upload_sucess_message') = result;
	      return true;   
	}
