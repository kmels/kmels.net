<?php
	require_once('includes/globals.php');	
?>

<?php
$instrucciones = $Filburt->traductor->matrizGeneradaSoloBinario;

?>

<h2><?php echo $Filburt->lang->text['content_menu_showBIN']; ?></h2>
<div id="scrollbar_container_sb">  
<div id="scrollbar_track_sb"><div id="scrollbar_handle_sb"></div></div>  
<div id="scrollbar_content_sb">
<table id="showBIN_Table">
	<thead>
		<tr>
			<th><?php echo $Filburt->lang->text['showBIN_linenumber']; ?></th>
			<th><?php echo $Filburt->lang->text['showBIN_instruction']; ?></th>
		</tr>
	</thead>
<tbody id="showBIN_Tbody">
   </tbody>
</table>
</div>
</div>

<?php	
	echo "<script language='JavaScript'>\n";
	echo "var numerodeLinea = new Array();\n";
	echo "var instrucciones = new Array();\n";

	foreach($instrucciones as $indice => $instruccion){
		echo "numerodeLinea[$indice] = '".$instruccion[0]." ';\n";
		echo "instrucciones[$indice] = '".$instruccion[1]." ';\n";
	}
?>		

	var tbodyElem = document.getElementById("showBIN_Tbody");
	var trElem, tdElem, txtNode;
	for (var j = 0; j < instrucciones.length; j++) {
		trElem = tbodyElem.insertRow(tbodyElem.rows.length);
		trElem.className = "etiquetas" + (j%2);
		
		tdElem = trElem.insertCell(trElem.cells.length);
  		tdElem.className = "col_line_number";
  		txtNode = document.createTextNode(numerodeLinea[j]);
		tdElem.appendChild(txtNode);
		
		
		tdElem = trElem.insertCell(trElem.cells.length);
  		tdElem.className = "c";
  		txtNode = document.createTextNode(instrucciones[j]);
  		tdElem.appendChild(txtNode);
	}
	
	var scrollbar = new Control.ScrollBar('scrollbar_content_s','scrollbar_track_sb');  
	</script>