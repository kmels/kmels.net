<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//<?php echo strtoupper($this->lang->lang) ?>"   "http://www.w3.oFilburtrg/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><?php echo $this->lang->text['main_title'] ?></title>
		<meta http-equiv="Content-Type" content="text/html; charset=<?php echo $this->lang->text['data_charset'] ?>">
		<meta http-equiv="Content-Language" content="<?php echo $this->lang->lang ?>">
		
		<script src="includes/js/js.js" type="text/javascript"></script>
		<script src="includes/js/prototype.js" type="text/javascript"></script>
		<script src="includes/js/scriptaculous.js" type="text/javascript"></script>
		<script src="includes/js/ajaxuploader.js" type="text/javascript"></script>
		<script src="includes/js/TabbedPane.js" type="text/javascript"></script>
		<script src="includes/js/fabtabulous.js" type="text/javascript"></script>
		<script src="includes/js/tablekit.js" type="text/javascript"></script>
		<script src="includes/js/all.js" type="text/javascript"></script>
		
		<script>			
			document.observe('dom:loaded', function() {
							
			new AjaxUpload('upload_file_pseudobutton', {action: 'uploader.php', 
			onComplete: function(file,response){
				$('response_note').update(response);
				cargarSimulador();
				tabs.setActiveTab(1);
			}
			});
		});	
		</script>			
		<link rel="stylesheet" href="includes/filburt.css" type="text/css" />
	</head>
	<body>

<div id="nav_out">
		<div id="nav">
        	<div id="nav_left">
            	<a href="index.php">Filburt</a>
            </div>
            
            <div id="nav_right">
            	<ul>
                	<li class="first">
                    		<?php echo ($this->lang->text['filburt_description']); ?>
                    </li>
					<li>
	                    	<a href='http://twitter.com/kmels'>Carlos L&oacute;pez</a>
	                 </li>
                    <li>
      						<a href='http://twitter.com/hectorh30'>H&eacute;ctor Hurtarte</a>
                    </li>
					<li>
	      					Mario S&aacute;nchez
	                </li>
					<li class='last'>
                	<select onChange="location.href='index.php?lang='+this.value;" id="LanguageSelector">
                		<option>Language</option>
                		<option value="en">English (US)</option>
                		<option value="es">Espa&#241;ol</option>
                	</select>
                	</li>
                </ul>
            </div>
		</div>
</div>
	<div id="header">
			<h1><a href="index.php"><?php echo $this->lang->text['filburt_header_text'] ?></a></h1>
			<ul id='usermenu'>
				<li>
                    <img id='upload_file_pseudobutton' height='32px' title='<?php echo $this->lang->text['header_imgopen']?>' alt='<?php echo $this->lang->text['header_imgopen']?>' src='images/icons/open.png'>
                 </li>
				<li>
  					<img onClick='doOnFilburt("initMachine()"); cargarSimulador(); cargarTablaSimbolos();' height='32px' title='<?php echo $this->lang->text['header_imgreinit']?>' alt='<?php echo $this->lang->text['header_imgreinit']?>' src='images/icons/reinit.png'>
                </li>
				<li>
                    <img onClick='doOnFilburt("run()")' height='32px' title='<?php echo $this->lang->text['header_imgrun']?>' alt='<?php echo $this->lang->text['header_imgrun']?>' src='images/icons/run.png'>
                 </li>
				<li>
                    <img onClick='doOnFilburt("stepOver()")' height='32px' title='<?php echo $this->lang->text['header_imgdebug']?>' alt='<?php echo $this->lang->text['header_imgdebug']?>' src='images/icons/debug.png'>
                 </li>
                <li>
  					<img height='32px' title='<?php echo $this->lang->text['header_imghelp']?>' alt='<?php echo $this->lang->text['header_imghelp']?>' src='images/icons/help.png'>
                </li>
            </ul>
			<ul>
				<li id='response_note'>
				</li>
			</ul>
    </div>
	<div id="content_user_menu">
		<!-- example 1 -->
		<ul id="the_tabs" class="tabs">
			<li class="tab"><a class="active" href="#welcome"><?php echo $this->lang->text['content_menu_hello'];?></a></li>
			<li class="tab"><a class="" href="#simulatordiv"><?php echo $this->lang->text['content_menu_simulator'];?></a></li>
			<li class="tab"><a class="" href="#showbin"><?php echo $this->lang->text['content_menu_showBIN'];?></a></li>
			<li class="tab"><a class="" href="#symbolstable"><?php echo $this->lang->text['content_menu_hashTable'];?></a></li>
			<li class="tab"><a class="" href="#license"><?php echo $this->lang->text['content_menu_license'];?></a></li>
		</ul>
	</div>