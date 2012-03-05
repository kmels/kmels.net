<?php require_once('includes/globals.php');?>

<?php

echo 'not funy: '.strval(bindec($Filburt->registers["\$PC"]['content']));

//print_r($Filburt->memoria);?>

<h2><?php echo $Filburt->lang->text['content_menu_simulator'];?></h2>
<table style='margin: auto;' id="simulatorTableHead">
	<thead>
		<tr>
			<th class='col_pc'></th>
			<th class='col_label'><?php echo $Filburt->lang->text['simulator_label']?></th>
			<th class='col_address'><?php echo $Filburt->lang->text['simulator_address']?></th>
			<th class='col_content'><?php echo $Filburt->lang->text['simulator_value']?></th>
			<!---><th class='col_content_HEX'><?php echo $Filburt->lang->text['simulator_value_in_HEX']?></th><!-->
			<th class='col_operation'><?php echo $Filburt->lang->text['simulator_operation']?></th>
		</tr>
	</thead>
</table>
<div id="scrollbar_container">
<div id="scrollbar_track">
<div id="scrollbar_handle"></div>
</div>
<div id="scrollbar_content">
<table id="simulatorTable">
	<tbody id="simulatorTbody">
	</tbody>
</table>
</div>
</div>

<h2><?php echo $Filburt->lang->text['main_registers'];?></h2>
<?php
foreach($Filburt->registers as $registerName => $register_properties){
	echo $registerName." : ".$Filburt->registers[$registerName]["content"]."\n";
}
?>
<table style='margin: auto;' id="registersTable">
	<thead>
	</thead>

	<tbody id="registersTbody">
	</tbody>
</table>
<script>

		//styled examples use the window factory for a shared set of behavior  
		var window_factory = function(container,options){  
		var window_header = new Element('div',{  
			className: 'window_header'  
		});  
		
		var window_title = new Element('div',{
			className: 'window_title'  
		});  
		var window_close = new Element('div',{  
			className: 'window_close'  
		});  
		var window_contents = new Element('div',{  
			className: 'window_contents'  
		});

		var w = new Control.Window(container,Object.extend({  
			className: 'window',  
			closeOnClick: window_close,  
			draggable: window_header,  
			insertRemoteContentAt: window_contents,  
			afterOpen: function(){  
				window_title.update(container.readAttribute('title'))  
			}  
	  	},options || {}));  
		w.container.insert(window_header);  
	  	window_header.insert(window_title);  
		window_header.insert(window_close);  
	 	w.container.insert(window_contents);  
		return w;  
		};
	
		var simulatorTbodyj = document.getElementById("simulatorTbody");
		while (simulatorTbodyj.childNodes.length > 0) {
			simulatorTbodyj.removeChild(simulatorTbodyj.firstChild);
		}
		
		var registersTbodyj = document.getElementById("registersTbody");
		while (registersTbodyj.childNodes.length > 0) {
			registersTbodyj.removeChild(registersTbodyj.firstChild);
		}
	
</script>

<?php
//Fill Javascripts Array Memory
echo "<script language='JavaScript'>\n";
//echo "function mostrarMemoriayRegistros(){\n";
//echo "limpiarTablasdelSimulador();\n";
echo "var valores = new Array();\n";
echo "var posicionesEnHex = new Array();\n";
echo "var operaciones = new Array();\n";
echo "var labels = new Array();\n";
foreach($Filburt->memoria as $key => $value){
	echo "valores[$key] = '".$value." ';\n";
	echo "posicionesEnHex[".$key."] = '".$Filburt->binToHex($Filburt->decToBin($key,32))."';\n";
	echo "operaciones[".$key."] = '".$Filburt->interpretacionDeInstruccion($value)."';\n";
	//echo "operaciones[".$key."] = 'nada de nada';\n";
	echo "labels[".$key."] = '".$Filburt->getLabelOfAddress($key)."';\n";
}

//Do the same with the registers
$i=0;
echo "var nombresRegistros = new Array();\n";
echo "var valoresRegistros = new Array();\n";

foreach($Filburt->registers as $registerName => $register_properties){
	echo "nombresRegistros[".$i."] = '".$registerName."';\n";
	//echo "valoresRegistros[".$i."] = '".$Filburt->binToHex($register_properties['content'])."';\n";
	echo "valoresRegistros[".$i."] = '".$Filburt->binToHex($Filburt->registers[$registerName]["content"])."';\n";
	$i++;
}

?>
var tbodyElem = document.getElementById("simulatorTbody"); var trElem,
tdElem, txtNode; for (var j = 0; j < valores.length; j++) { trElem =
tbodyElem.insertRow(tbodyElem.rows.length); trElem.className = "tr" +
(j%2); var col = 1; tdElem = trElem.insertCell(trElem.cells.length);
tdElem.className = "col_pc"; tdElem.id = 'simTable_'+(j+1)+''+col;
txtNode = document.createTextNode(''); tdElem.appendChild(txtNode);

tdElem = trElem.insertCell(trElem.cells.length); tdElem.className =
"col_label"; txtNode = document.createTextNode(labels[j]);
tdElem.appendChild(txtNode); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"col_address"; txtNode = document.createTextNode(posicionesEnHex[j]);
tdElem.appendChild(txtNode); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"col_content"; txtNode = document.createTextNode(valores[j]);
tdElem.appendChild(txtNode); /*tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"col_content"; txtNode = document.createTextNode(valoresenHEX[j]);
tdElem.appendChild(txtNode);*/ tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"col_operation"; txtNode = document.createTextNode(operaciones[j]);
tdElem.appendChild(txtNode); } var tbodyElem =
document.getElementById("registersTbody"); var trElem, tdElem, txtNode;

for (var j = 0; j < nombresRegistros.length-3; j=j+3) { trElem =
tbodyElem.insertRow(tbodyElem.rows.length); trElem.id =
'Registros_fila_'+j; trElem.className = "tr" + (j%2); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"registersName"; txtNode =
document.createTextNode("$"+nombresRegistros[j]);
tdElem.appendChild(txtNode); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"registersValue"; txtNode =
document.createTextNode('x'+valoresRegistros[j]);
tdElem.appendChild(txtNode); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"registersName"; txtNode =
document.createTextNode("$"+nombresRegistros[j+1]);
tdElem.appendChild(txtNode); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"registersValue"; txtNode =
document.createTextNode('x'+valoresRegistros[j+1]);
tdElem.appendChild(txtNode); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"registersName"; txtNode =
document.createTextNode(nombresRegistros[j+2]);
tdElem.appendChild(txtNode); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"registersValue"; txtNode =
document.createTextNode('x'+valoresRegistros[j+2]);
tdElem.appendChild(txtNode); } trElem =
tbodyElem.insertRow(tbodyElem.rows.length); trElem.id =
'Registros_fila_'+j; trElem.className = "tr" + (0); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"registersName"; txtNode = document.createTextNode("$ra");
tdElem.appendChild(txtNode); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"registersValue"; txtNode =
document.createTextNode('x'+valoresRegistros[22]);
tdElem.appendChild(txtNode); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"registersName"; txtNode = document.createTextNode("PC");
tdElem.appendChild(txtNode); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"registersValue"; txtNode =
document.createTextNode('x'+valoresRegistros[23]);
tdElem.appendChild(txtNode); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"registersName"; txtNode = document.createTextNode("IR");
tdElem.appendChild(txtNode); tdElem =
trElem.insertCell(trElem.cells.length); tdElem.className =
"registersValue"; txtNode =
document.createTextNode('x'+valoresRegistros[24]);
tdElem.appendChild(txtNode);
<?php
echo "</script>\n";
//poner la flechita en el pc..
if (count($Filburt->memoria)>0){
	if ((intval($Filburt->registers['\$PC']['content']))< count($Filburt->memoria)){
		echo "<script/>\n
			$('simTable_".strval(bindec($Filburt->registers["\$PC"]['content'])+1)."1').update('<img src=\"images/icons/pc.png\">')\n
			</script>\n"; 
	} else {
		echo 'Stack overflow, PC > memory!';
	}
} else
{
	echo 'Stack overflow, PC > memory 2!';
}?>
<script>
	var scrollbar = new Control.ScrollBar('scrollbar_content','scrollbar_track');  
</script>
