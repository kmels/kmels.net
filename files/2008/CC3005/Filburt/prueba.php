<?php 

echo '<pre>';
print_r($this->memoria);

echo "<script language='JavaScript'>\n";
echo "var valores = new Array();\n";
echo "var valoresenHEX = new Array();\n";
foreach($this->memoria as $key => $value){
	echo "valores[$key] = '$value';";
	echo "valoresenHEX[".$key."] = '".$this->binToHex($value)."';";
}
?>
		var tbodyElem = document.getElementById("simulatorTbody");
		var trElem, tdElem, txtNode;
		for (var j = 0; j < valores.length; j++) {
		   trElem = tbodyElem.insertRow(tbodyElem.rows.length);
		   trElem.className = "tr" + (j%2);

		  tdElem = trElem.insertCell(trElem.cells.length);
		  tdElem.className = "col0";
		  txtNode = document.createTextNode('');
		  tdElem.appendChild(txtNode);
		
		tdElem = trElem.insertCell(trElem.cells.length);
		  tdElem.className = "col1";
		  txtNode = document.createTextNode('');
		  tdElem.appendChild(txtNode);
		
		tdElem = trElem.insertCell(trElem.cells.length);
		  tdElem.className = "col2";
		  txtNode = document.createTextNode(valores[j]);
		  tdElem.appendChild(txtNode);
		
		  tdElem = trElem.insertCell(trElem.cells.length);
		  tdElem.className = "col3";
		  txtNode = document.createTextNode(valoresenHEX[j]);
		  tdElem.appendChild(txtNode);
		
		tdElem = trElem.insertCell(trElem.cells.length);
		  tdElem.className = "col4";
		  txtNode = document.createTextNode('');
		  tdElem.appendChild(txtNode);
		}

	<?php
		
		echo "</script>\n";
		?>
		
		
			<div class="simulatorWrapper">
			<table id="simulatorTable">
			   <thead>
			     <tr>
			        <th><?php echo $this->lang->text['simulator_label']?></th>
					<th><?php echo $this->lang->text['simulator_address']?></th>
					<th><?php echo $this->lang->text['simulator_value']?></th>
					<th><?php echo $this->lang->text['simulator_value_in_HEX']?></th>
					<th><?php echo $this->lang->text['simulator_operation']?></th>
			     </tr>
			   </thead>

			   <tbody id="simulatorTbody">
			   </tbody>
			</table>
			</div>
