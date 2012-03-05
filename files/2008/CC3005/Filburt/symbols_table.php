<?php
	require_once('includes/globals.php');	
?>

<h2><?php echo $Filburt->lang->text['content_menu_hashTable']; ?></h2>
<div id="scrollbar_container_s">  
<div id="scrollbar_track_s"><div id="scrollbar_handle_s"></div></div>  
<div id="scrollbar_content_s">
<table id="symbols_Table">
	<thead>
		<tr>
			<th><?php echo $Filburt->lang->text['symbols_label']; ?></th>
			<th><?php echo $Filburt->lang->text['symbols_label_value']; ?></th>
		</tr>
	</thead>
<tbody id="symbols_Tbody">
   </tbody>
</table>
</div>
</div>

<?php	
	echo "<script language='JavaScript'>\n";
	echo "var nombresEtiquetas = new Array();\n";
	echo "var valoresEtiquetas = new Array();\n";

	foreach($Filburt->traductor->matrizTablaSimbolos as $indice => $etiqueta){
		echo "nombresEtiquetas[$indice] = '".$etiqueta[0]." ';\n";
		echo "valoresEtiquetas[$indice] = '".$etiqueta[1]." ';\n";
	}
?>		

	var tbodyElem = document.getElementById("symbols_Tbody");
	var trElem, tdElem, txtNode;
	for (var j = 0; j < nombresEtiquetas.length; j++) {
		trElem = tbodyElem.insertRow(tbodyElem.rows.length);
		trElem.className = "etiquetas" + (j%2);
		
		tdElem = trElem.insertCell(trElem.cells.length);
  		tdElem.className = "nombre_etiqueta";
  		txtNode = document.createTextNode(nombresEtiquetas[j]);
		tdElem.appendChild(txtNode);
		
		
		tdElem = trElem.insertCell(trElem.cells.length);
  		tdElem.className = "c";
  		txtNode = document.createTextNode(valoresEtiquetas[j]);
  		tdElem.appendChild(txtNode);
	}
	
	var scrollbar = new Control.ScrollBar('scrollbar_content_s','scrollbar_track_s');  
	</script>

