<?php
require_once('includes/globals.php');
function getDecimalFromUnsignedBin($binario){
	//tomar cada bit, de derecha a izquierda y multiplicarlo por su representacion en decimal
	$res = 0;
	for ($posicion = -1; $posicion >= (strlen($binario)*-1); $posicion--){
		$res += intval(substr($binario,$posicion,1))*pow(2,($posicion*-1)-1);
	}
	return $res;
}


function intToBinaryString($int,$numBits)
{
	if($int>pow(2,$numBits))
	{
		$this->agregarError("Error en primera corrida: el numero $int es muy grande para la cantidad de bits ($numBits): se desechan los demas bits");
	}

	$i=0;
	$carry = 1;
	$flag = 0;
	$binaryTemp = "";
	$binary="";
	$binaryArray = array();
	$tmp=$numBits-1;

	for($i=$tmp;$i>=0;$i--)
	{
		$binaryArray[$i]=0;
	}

	if($int<0)
	{
		$flag=1;
		$int=$int*-1;
	}

	while($int>0)
	{
		$numBits = $numBits-1;
		$binaryArray[$numBits]=$int%2;
		$int = (int)($int/2);
	}

	if($flag)
	{
		for($i=$tmp;$i>=0;$i--)
		{
			$binaryArray[$i] = ~$binaryArray[$i];
			$binaryArray[$i]=$binaryArray[$i]+2;
			$binaryArray[$i]=$binaryArray[$i]+$carry;
			$carry = 0;
			if($binaryArray[$i]>1)
			{
				$binaryArray[$i]=0;
				$carry=1;
			}
		}
	}

	if($int>0&&$binaryArray[0]>0)
	{
		$this->agregarError("Error en primera corrida: num negativo y la cantidad de bits: ha ocurrido desbordamiento al convertir $int en un binario de $numBits bits.");
	}

	if($int<0&&$binaryArray[0]=0)
	{
		$this->agregarError("Error en primera corrida: num positivo y la cantidad de bits: ha ocurrido desbordamiento al convertir $int en un binario de $numBits bits.");
	}

	for($i=0;$i<count($binaryArray);$i++)
	{
		$retorno = $retorno."$binaryArray[$i]";
	}

	return $retorno;
}

function ejecutar()
{

}

if (isset($_GET['action'])) {
	switch ($_GET['action']){
		case 'initMachine()':{
			// 'erase' memory
			$Filburt->memoria = array();
			$Filburt->traductor->matrizTablaSimbolos = array();
			$Filburt->registers = array("\$v0" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "00010"),
									"\$v1" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "00011"),
									"\$a0" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "00100"),
									"\$a1" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "00101"),
									"\$a2" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "00110"),
									"\$a3" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "00111"),
									"\$t0" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "01000"),
									"\$t1" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "01001"),
									"\$t2" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "01010"),
									"\$t3" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "01011"),
									"\$t4" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "01100"),
									"\$t5" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "01101"),
									"\$t6" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "01110"),
									"\$t7" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "01111"),
									"\$t8" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "11000"),
									"\$t9" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "11001"),
									"\$s0" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "10000"),
									"\$s1" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "10001"),
									"\$s2" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "10010"),
									"\$s3" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "10011"),
									"\$s4" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "10100"),
									"\$s5" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "10101"),
									"\$s6" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "10110"),
									"\$s7" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "10111"),
									"\$ra" => array("content" => $Filburt->getNOP(), "binaryRepresentation" => "11111"),
									"\$PC" => array("content" => $Filburt->getNOP()),
									"\$IR" => array("content" => $Filburt->getNOP())
			);
			//for the message
			$class='green';
			$msg = 'Memory has been initialized<br>';

		} break;
		case 'stepOver()':{

			//
			$Filburt->registers["\$IR"]["content"] = $Filburt->registers["\$PC"]["content"];

			$valorenDecimal = getDecimalFromUnsignedBin($Filburt->registers["\$PC"]["content"])+1;
			$Filburt->registers["\$PC"]["content"] = intToBinaryString($valorenDecimal,32);

			$Filburt->ejecutarInstruccion($Filburt->memoria[$Filburt->getDecimalFromUnsignedBin($Filburt->registers["\$IR"]["content"])]);

		} break;
		case 'run()':{
			for($i=0;$i<count($Filburt->memory);$i++)
			{
				ejecutar();
			}
		} break;
		default:{
			echo 'PROCESS.PHP en DEFAULT!  :  '.$_GET['action'];
		} break;
	}
	echo '<span style=\'color:'.$class.';\'>'.$msg.'</span>';
}
?>