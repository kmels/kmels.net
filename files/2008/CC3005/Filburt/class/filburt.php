<?php
/**
 * 
 * This class the class of the Filburt Application
 * @version 1.0
 * @package Filburt
 * @subpackage classes
 */
require_once('lang.php');
require_once('user.php');
require_once('Traductor.php');

class filburt{
	public $lang;
	public $memoria;
	public $registers;
	public $traductor;
	public $errores;
	public $yasubioArchivo;

	/*
		* Used when you serialize an instance of this class
		*/
	public function __sleep(){
		return array('lang', 'registers','memoria','traductor');
	}

	/*
		*	Constructor
		*/
	public function filburt(){
		if (!isset($_GET['lang'])){
			$_GET['lang'] = 'en';
		}
			
		$this->InstanceLanguage($_GET['lang']);
		$this->errores = array();
		$this->memoria = array();
		$this->traductor = new Traductor();
		//llenar array
		//for ($i = 0; $i<= 512 ; $i++  ){
		//	array_push($this->memoria, $this->getNOP());
		//}

		$this->yasubioArchivo = false;
		$this->registers = array("\$v0" => array("content" => $this->getNOP(), "binaryRepresentation" => "00010"),
									"\$v1" => array("content" => $this->getNOP(), "binaryRepresentation" => "00011"),
									"\$a0" => array("content" => $this->getNOP(), "binaryRepresentation" => "00100"),
									"\$a1" => array("content" => $this->getNOP(), "binaryRepresentation" => "00101"),
									"\$a2" => array("content" => $this->getNOP(), "binaryRepresentation" => "00110"),
									"\$a3" => array("content" => $this->getNOP(), "binaryRepresentation" => "00111"),
									"\$t0" => array("content" => $this->getNOP(), "binaryRepresentation" => "01000"),
									"\$t1" => array("content" => $this->getNOP(), "binaryRepresentation" => "01001"),
									"\$t2" => array("content" => $this->getNOP(), "binaryRepresentation" => "01010"),
									"\$t3" => array("content" => $this->getNOP(), "binaryRepresentation" => "01011"),
									"\$t4" => array("content" => $this->getNOP(), "binaryRepresentation" => "01100"),
									"\$t5" => array("content" => $this->getNOP(), "binaryRepresentation" => "01101"),
									"\$t6" => array("content" => $this->getNOP(), "binaryRepresentation" => "01110"),
									"\$t7" => array("content" => $this->getNOP(), "binaryRepresentation" => "01111"),
									"\$t8" => array("content" => $this->getNOP(), "binaryRepresentation" => "11000"),
									"\$t9" => array("content" => $this->getNOP(), "binaryRepresentation" => "11001"),
									"\$s0" => array("content" => $this->getNOP(), "binaryRepresentation" => "10000"),
									"\$s1" => array("content" => $this->getNOP(), "binaryRepresentation" => "10001"),
									"\$s2" => array("content" => $this->getNOP(), "binaryRepresentation" => "10010"),
									"\$s3" => array("content" => $this->getNOP(), "binaryRepresentation" => "10011"),
									"\$s4" => array("content" => $this->getNOP(), "binaryRepresentation" => "10100"),
									"\$s5" => array("content" => $this->getNOP(), "binaryRepresentation" => "10101"),
									"\$s6" => array("content" => $this->getNOP(), "binaryRepresentation" => "10110"),
									"\$s7" => array("content" => $this->getNOP(), "binaryRepresentation" => "10111"),
									"\$ra" => array("content" => $this->getNOP(), "binaryRepresentation" => "11111"),
									"\$PC" => array("content" => $this->getNOP()),
									"\$IR" => array("content" => $this->getNOP())
		);
	}

	public function getPCasHEX(){
		return $this->registers["\$PC"]["content"];
	}

	public function getBinaryRepresentationOfRegister($registerName){
		return $this->registers[$registerName]['binaryRepresentation'];
	}

	public function getNOP(){
		return "00000000000000000000000000000000"; //32 bits NO-OP
	}

	/*
	 * Regresa el contenido de un registro mandando como parametro la representación binaria de ese registro en string
	 */
	public function getContentOfRegister($binaryRep){
		return $this->registers[$register]['content'];
	}

	/*
	 * Establece el contenido de un registro mandando como parametro la representación binaria de ese registro en string y el contenido ($content), este contenido debe ser un binario de 32 bits
	 */
	public function setContentOfRegisterTo($binaryRep,$content){
		$nombre = $this->getRegisterNameFromBinaryRepresentation($binaryRep);
		$this->registers[$nombre] = $content;
	}



	public function getRegisterNameFromBinaryRepresentation($binaryRep){
		foreach ($this->registers as $registroName => $registro){
			if ($registro['binaryRepresentation']==$binaryRep)
			return $registroName;
		}

		$this->nuevoError('No hay ningún registro con ésa representación binaria: '.$binaryRep);
	}

	public function getRegisterContentFromBinaryRepresentation($binaryRep){
		foreach ($this->registers as $registro){
			if ($registro['binaryRepresentation']==$binaryRep)
			return $registro['content'];
		}
	}

	public function intToBinaryString($int,$numBits)
	{
		if($int>pow(2,$numBits))
		{
			$this->nuevoError("Error en primera corrida: el numero $int es muy grande para la cantidad de bits ($numBits): se desechan los demas bits");
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

	public function InstanceLanguage($lang){
		$this->lang = new Lang($lang);
	}

	public function get_headers(){
		require_once('./header.php');
	}

	public function get_html(){
		require_once('./home.php');
	}

	/*
	 *	Decimal to bin
	 * @param $dec $decimal number in string
	 * @param $numbits $numbits in integer
	 */
	public function decToBin($dec,$numBits)
	{
		$int = intval($dec);
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

		for($i=0;$i<count($binaryArray);$i++)
		{
			$retorno = $retorno."$binaryArray[$i]";
		}
		return $retorno;
	}

	public function incPC($incremento = 1){
		//		echo 'en incrementar pc pc vale: '.$this->registers["\$PC"]["content"].'<br/>';

		$valorenDecimal = $this->getDecimalFromUnsignedBin($Filburt->registers["\$PC"]["content"])+$incremento;
		echo $this->intToBinaryString($valorenDecimal,32);
		$Filburt->registers["\$PC"]["content"] = $this->intToBinaryString($valorenDecimal,32);

	}

	public function setPCto($future_pc_value){
		$this->registers["\$PC"]["content"] = $future_pc_value;
	}

	public function binToHex($binario){
		$respuesta = '';
		for ($i = 0; $i <= strlen($binario)-4; $i += 4){
			$binEn4Bits = substr($binario,$i,4);
			$respuesta = $respuesta.$this->binToHexNotation($binEn4Bits);
		}
		return $respuesta;
	}

	public function binToHexNotation($binario){
		if (strlen($binario)==4){
			$valor = intval(substr($binario,-1)) +  intval(substr($binario,-2,1))*2 + intval(substr($binario,-3,1))*pow(2,2) + intval(substr($binario,-4,1))*pow(2,3);
			if (!(($valor>=0) && ($valor<10))){
				switch($valor){
					case 10:{
						return 'A';
					}break;
					case 11:{
						return 'B';
					}break;
					case 12:{
						return 'C';
					}break;
					case 13:{
						return 'D';
					}break;
					case 14:{
						return 'E';
					};
					default: {
						return 'F';
					}
				}
			} else{
				return strval($valor); //no hay necesidad de convertir a notación Hexagesimal
			}
		} else {
			echo 'Error en bin to hex notation, mando mas de 4';
		}
	}

	private function getOperationSpec($instruccion){
		return 'op';
	}

	private function fillMemoryWithInstructions($pathToFile){
		//$instrucciones = file($pathToFile);
		$instrucciones = $this->traductor->matrizGeneradaSoloBinario;
		for($i=0;$i<count($instrucciones);$i++)
		{
			$this->memoria[$instrucciones[$i][0]] = $instrucciones[$i][1];
		}

		$temp = count($instrucciones)-1;
		$temp = $instrucciones[$temp][0];

		for($i=0;$i<$temp;$i++)
		{
			$estaEnArreglo = false;
			for($j=0;$j<count($instrucciones);$j++)
			{
				if($i==$instrucciones[$j][0])
				{
					$estaEnArreglo=true;
					$j=count($instrucciones)-1;
				}
			}
			if(!$estaEnArreglo)
			{
				$this->llenarPosiciondeMemoriaCon($i,$this->getNOP());
			}
		}
	}

	public function llenarPosiciondeMemoriaCon($posicion,$palabra){
		$this->memoria[$posicion] = $palabra;
	}

	public function interpretarArchivo($fileNameToParse){
		$pathToFile = $fileNameToParse;
		chmod($pathToFile, 0777);   // make the file writable

		//crear la memoria y llenarla
		$this->fillMemoryWithInstructions($pathToFile);
	}

	public function traducirArchivo($pathArchivoASM)
	{
		$pathArchivoASM = './'.$pathArchivoASM;
		$this->traductor = new Traductor();
		$this->traductor->Traducir($pathArchivoASM);
		$this->interpretarArchivo('generados/archivo.bin');
	}

	public function getLabelOfAddress($addressinDecimalString){
		foreach($this->traductor->matrizTablaSimbolos as $indice => $label){
			if (strcmp($label[1],$addressinDecimalString)==0){
				return $label[0];
			}
		}
	}

	public function interpretacionDeInstruccion($instruccion){
		$primeros_6bits = substr($instruccion,0,6);
		if (strlen($instruccion)!=32)
		return;

		switch ($primeros_6bits){
			case '000000':
				{
					//puede ser ADD, AND, JR, JALR, SYSCALL o NOP!
					$ultimos_6bits = substr($instruccion,-6);
					switch ($ultimos_6bits)
					{
						case '100000':
							{
								//es ADD
								$rd = substr($instruccion,6,5);
								$rt = substr($instruccion,11,5);
								$rs = substr($instruccion,16,5);
								return $this->getRegisterNameFromBinaryRepresentation($rd).' = '.$this->getRegisterNameFromBinaryRepresentation($rt).' + '.$this->getRegisterNameFromBinaryRepresentation($rs);
							} break;
						case '100100':
							{
								//es AND
								$rd = substr($instruccion,6,5);
								$rt = substr($instruccion,11,5);
								$rs = substr($instruccion,16,5);
								return $this->getRegisterNameFromBinaryRepresentation($rd).' = '.$this->getRegisterNameFromBinaryRepresentation($rt).' AND '.$this->getRegisterNameFromBinaryRepresentation($rs);
							}break;
						case '001000':
							{
								//es JR
								$rs = substr($instruccion,6,5);
								return 'JR '.$this->getRegisterNameFromBinaryRepresentation($rs);
							}break;
						case '001001':
							{
								//es JALR
								$rs = substr($instruccion,6,5);
								//return $rs;
								return 'JALR '.$this->getRegisterNameFromBinaryRepresentation($rs).' $ra = this_address + 1';
							}break;
						case '001100':
							{
								//ES SYSCALL
								return 'syscall';
							}break;
						case '000000':
							{
								//es NOP
								return '.WORD x0 (no-op)';
							}break;
						default :
							{
								return 'No reonocido';
							}break;
					}
				}break;
						case '001000':{
							//es ADDI
							$rd = substr($instruccion,6,5);
							$rt = substr($instruccion,11,5);
							$imm = substr($instruccion,16);
							return $this->getRegisterNameFromBinaryRepresentation($rd).' = '.$this->getRegisterNameFromBinaryRepresentation($rt).' + '.$this->getDecimalRepFromTwosComplement($imm);
						}break;
						case '001100':{
							//es ANDI
							$rd = substr($instruccion,6,5);
							$rt = substr($instruccion,11,5);
							$imm = substr($instruccion,16);
							return $this->getRegisterNameFromBinaryRepresentation($rd).' = '.$this->getRegisterNameFromBinaryRepresentation($rt).' AND '.$this->getDecimalRepFromTwosComplement($imm);
						}break;
						case '000100':{
							//es BEQ
							$rd = substr($instruccion,6,5);
							$rt = substr($instruccion,11,5);
							$offset = substr($instruccion,16);
							return $this->getRegisterNameFromBinaryRepresentation($rd).' == '.$this->getRegisterNameFromBinaryRepresentation($rt).' ? pc += '.$this->getDecimalRepFromTwosComplement($offset);
						}break;
						case '000001':{
							//es REGIMM
							//puede ser BGEZ o BLTZ
							$bits_11_a_15 = substr($instruccion,11,5);
							switch ($bits_11_a_15){
								case '00001':{
									//es BGEZ
									$rd = substr($instruccion,6,5);
									$offset = substr($instruccion,16);
									return $this->getRegisterNameFromBinaryRepresentation($rd).' >= 0 ? pc += ' .$this->getDecimalRepFromTwosComplement($offset);
								}break;
								case '00000':{
									//es BLTZ
									$rd = substr($instruccion,6,5);
									$offset = substr($instruccion,16);
									return $this->getRegisterNameFromBinaryRepresentation($rd).' < 0 ? pc += ' .$this->getDecimalRepFromTwosComplement($offset);
								}break;
								default:{
									return 'No reconocido';
								}
							}
						}break;
								case '000111':{
									//es BGTZ
									$rd = substr($instruccion,6,5);
									$offset = substr($instruccion,16);
									return $this->getRegisterNameFromBinaryRepresentation($rd).' > 0 ? pc += ' .$this->getDecimalRepFromTwosComplement($offset);
								}break;
								case '000110':{
									//es BLEZ
									$rd = substr($instruccion,6,5);
									$offset = substr($instruccion,16);
									return $this->getRegisterNameFromBinaryRepresentation($rd).' <= 0 ? pc += ' .$this->getDecimalRepFromTwosComplement($offset);
								}break;
								case '000101':{
									//es BNE
									$rd = substr($instruccion,6,5);
									$rs = substr($instruccion,11,5);
									$offset = substr($instruccion,16);
									return $this->getRegisterNameFromBinaryRepresentation($rd).' != '.$this->getRegisterNameFromBinaryRepresentation($rs).' ? pc += ' .$this->getDecimalRepFromTwosComplement($offset);
								}break;
								case '000010':{
									//es J
									$branch = substr($instruccion,6);
									//return $branch;
									return 'J '.$this->getDecimalFromUnsignedBin($branch);
								}break;
								case '000011':{
									//es JAL
									$branch = substr($instruccion,6);
									return 'JAL '.$this->getDecimalFromUnsignedBin($branch);
								}break;
								case '100011':{
									//es LW
									$base = substr($instruccion,11,5);
									$rd = substr($instruccion,6,5);
									$offset = substr($instruccion,16);

									if (strcmp($base,"00000")==0){
										//es PC + offset
										return $this->getRegisterNameFromBinaryRepresentation($rd).' = '.'mem[PC + '.$this->getDecimalRepFromTwosComplement($offset).']';
									}else {
										//return
										//return (strcmp($base,"00000")==0);
										return $this->getRegisterNameFromBinaryRepresentation($rd).' = '.'mem['.$this->getRegisterNameFromBinaryRepresentation($base).' + '.$this->getDecimalRepFromTwosComplement($offset).']';
									}

								}break;
								case '101011':{
									//es SW
									$rdestino = substr($instruccion,11,5);
									$rorigen = substr($instruccion,6,5);
									$offset = substr($instruccion,16);
									//return strcmp($rdestino,"00000")==0;
									if (strcmp($rdestino,"00000")==0){
										//es PC + offset
										return 'mem[PC + '.$this->getDecimalRepFromTwosComplement($offset).'] = '.$this->getRegisterNameFromBinaryRepresentation($rorigen);
									}else {
										return 'mem['.$this->getRegisterNameFromBinaryRepresentation($rdestino).' + '.$this->getDecimalRepFromTwosComplement($offset).'] = '.$this->getRegisterNameFromBinaryRepresentation($rorigen);
									}
								}break;
								default:{
									return 'elque traujo sux :D!!';
								}
		}

		return 'asdf';
	}

	/*
	 * Ejecutar instruccion :D::D!! ya mero
	 */
	public function ejecutarInstruccion($instruccion,$addressOfThisInstruction = ''){
		$primeros_6bits = substr($instruccion,0,6);
		if (strlen($instruccion)!=32)
		return;

		switch ($primeros_6bits){
			case '000000':{
				//puede ser ADD, AND, JR, JALR, SYSCALL o NOP!
				$ultimos_6bits = substr($instruccion,-6);
				switch ($ultimos_6bits){
					case '100000':{
						//es ADD
						$rdestino = substr($instruccion,6,5);
						$rorigen1 = substr($instruccion,11,5);
						$rorigen2 = substr($instruccion,16,5);
						$this->ADD($rdestino,$rorigen1,$rorigen2);
						return true;
					} break;
					case '100100':{
						//es AND
						$rdestino = substr($instruccion,6,5);
						$rorigen1 = substr($instruccion,11,5);
						$rorigen2 = substr($instruccion,16,5);
						$this->AND_de($rdestino,$rorigen1,$rorigen2);
						return true;
					}break;
					case '001000':{
						//es JR
						$rs = substr($instruccion,6,5);
						$this->JR($rs);
						return true;
					}break;
					case '001001':{
						//es JALR
						$rs = substr($instruccion,16,5);
						$this->JALR($rs,$addressOfThisInstruction);
					}break;
					case '001100':{
						//ES SYSCALL
						return true;
					}break;
					case '000000':{
						//es NOP
						return true;
					}
					default :{
						return false;
					}
				}
			}break;
					case '001000':{
						//es ADDI
						$rd = substr($instruccion,6,5);
						$rt = substr($instruccion,11,5);
						$imm = substr($instruccion,16);
						$this->ADDI($rd,$rt,$imm);
						return true;
					}break;
					case '001100':{
						//es ANDI
						$rd = substr($instruccion,6,5);
						$rt = substr($instruccion,11,5);
						$imm = substr($instruccion,16);
						$this->ANDI($rd,$rt,$imm);
						return true;
					}break;
					case '000100':{
						//es BEQ
						$rd = substr($instruccion,6,5);
						$rt = substr($instruccion,11,5);
						$offset = substr($instruccion,16);
						$this->BEQ($rd,$rt,$offset);
						return true;
					}break;
					case '000001':{
						//es REGIMM
						//puede ser BGEZ o BLTZ
						$bits_11_a_15 = substr($instruccion,11,5);
						switch ($bits_11_a_15){
							case '00001':{
								//es BGEZ
								$rd = substr($instruccion,6,5);
								$offset = substr($instruccion,16);
								$this->BGEZ($rd,$offset);
								return true;
							}break;
							case '00000':{
								//es BLTZ
								$rd = substr($instruccion,6,5);
								$offset = substr($instruccion,16);
								$this->BLTZ($rd,$offset);
								return true;
							}break;
							default:{
								return false;
							}
						}
					}break;
							case '000111':{
								//es BGTZ
								$rd = substr($instruccion,6,5);
								$offset = substr($instruccion,16);
								$this->BGTZ($rd,$offset);
								return true;
							}break;
							case '000110':{
								//es BLEZ
								$rd = substr($instruccion,6,5);
								$offset = substr($instruccion,16);
								$this->BLEZ($rd,$offset);
								return true;
							}break;
							case '000101':{
								//es BNE
								$rd = substr($instruccion,6,5);
								$rs = substr($instruccion,11,5);
								$offset = substr($instruccion,16);
								$this->BNE($rd,$rs,$offset);
								return true;
							}break;
							case '000010':{
								//es J
								$offset = substr($instruccion,6);
								$this->J($offset);
								//return 'J '.$this->getDecimalFromUnsignedBin($offset);
							}break;
							case '000011':{
								//es JAL
								$offset = substr($instruccion,6);
								$this->JAL($offset,$addressOfThisInstruction);
								return true;
							}break;
							case '100011':{
								//es LW

								$base = substr($instruccion,11,5);
								$rd = substr($instruccion,6,5);
								$offset = substr($instruccion,16);

								$this->LW($rd,$base,$offset);
								return true;
							}break;
							case '101011':{
								//es SW
								$rfuente = substr($instruccion,6,5);
								$rbase = substr($instruccion,11,5);
								$offset = substr($instruccion,16);
								$this->SW($rfuente,$rbase,$offset);
								return true;
							}break;
							default:{
								return false;
							}
		}

		return 'asdf';
	}

	public function nuevoError($error_msg){
		array_push($this->$errores,$error_msg);
	}

	public function mostrarErrores(){
		?>
<script>
				$('response_note').update(<?php echo"'".$this->getErroresComoMensaje()."'"; ?>);
			</script>
		<?php
	}

	public function getErroresComoMensaje(){
		$respuesta = '';

		foreach($this->errores as $error){
			$respuesta += $error.'<br/>';
		}
	}


	public function getDecimalFromUnsignedBin($binario){
		//tomar cada bit, de derecha a izquierda y multiplicarlo por su representacion en decimal
		$res = 0;
		for ($posicion = -1; $posicion >= (strlen($binario)*-1); $posicion--){
			$res += intval(substr($binario,$posicion,1))*pow(2,($posicion*-1)-1);
		}
		return $res;
	}

	public function getDecimalRepFromTwosComplement($binario){
		//tomar cada bit, de derecha a izquierda y multiplicarlo por su representacion en decimal
		$res = 0;
		for ($posicion = -1; $posicion > (strlen($binario)*-1); $posicion--){
			$res += intval(substr($binario,$posicion,1))*pow(2,($posicion*-1)-1);
			//eso es, $res = $res + bit*2^pos (de derecha a izqierda)
		}
		return $res - intval(substr($binario,0,1))*pow(2,(strlen($binario))-1); //el signo
	}

	public function extensionA32Bitsde($binario){
		$cuantos_bits_le_faltan = 32 - strlen($binario);
		$resp = '';
		for ($bit0 = 0; $bit0 <= $cuantos_bits_le_faltan; $bit0++){
			$resp .= '0';
		}
		return $resp.$binario;
	}

	/*
	 *	Suma el contenido de dos registros ($rt y $rs) y establece el resultado en el contenido de $rd
	 * 	NOTA: $rt, $rs y $rd están en su representación binaria
	 */
	public function ADD($rd,$rt,$rs){
		//fetchear contenido y pasarlo a decimal
		$contenido_rt = $this->registers[$this->getRegisterNameFromBinaryRepresentation($rt)]["content"];
		$contenido_rs = $this->registers[$this->getRegisterNameFromBinaryRepresentation($rs)]["content"];
		$registro = $this->getRegisterNameFromBinaryRepresentation($rd);
		$this->registers[$registro]["content"] = $this->intToBinaryString($this->getDecimalRepFromTwosComplement($contenido_rs)+$this->getDecimalRepFromTwosComplement($contenido_rt),32);
	}

	/*
	 *	AND del contenido de dos registros ($rt y $rs) y establece el resultado en el contenido de $rd
	 * 	NOTA: $rt, $rs y $rd están en su representación binaria
	 */
	public function AND_de($rd,$rt,$rs){
		$res = '';
		$contenido_rt = $this->registers[$this->getRegisterNameFromBinaryRepresentation($rt)]["content"];
		$contenido_rs = $this->registers[$this->getRegisterNameFromBinaryRepresentation($rs)]["content"];

		for($bit = 0; $bit < 32; $bit++){
			if (((substr($contenido_rt,$bit,1) )==1)  && ((substr($contenido_rs,$bit,1))==1))
				$res = $res.'1';
			else
				$res = $res.'0';
		}
		$registro = $this->getRegisterNameFromBinaryRepresentation($rd);
		$this->registers[$registro]["content"] = $res;
	}

	/*
	 *	Suma el contenido de un registro ($rt) con un valor inmediato y establece el resultado en el contenido de $rd
	 * 	NOTA: $rt y $rd están en su representación binaria
	 *	NOTA 2: $imm está representado como un numero en complemento a dos
	 */
	public function ADDI($rd,$rt,$imm){
		$res = '';
		$contenido_rt = $this->registers[$this->getRegisterNameFromBinaryRepresentation($rt)]["content"];
		$valor_imm = $this->getDecimalRepFromTwosComplement($imm);
		$registro = $this->getRegisterNameFromBinaryRepresentation($rd);
		//echo $registro." : ".$valor_imm." : ".$contenido_rt;
		//echo ($this->intToBinaryString($this->getDecimalRepFromTwosComplement($contenido_rs)+$valor_imm,32));
		$this->registers[$registro]["content"] = $this->intToBinaryString($this->getDecimalRepFromTwosComplement($contenido_rt)+$valor_imm,32);
	}

	/*
	 *	Hace AND del contenido de un registro ($rt) con un valor inmediato y establece el resultado en el contenido de $rd
	 * 	NOTA: $rt y $rd están en su representación binaria
	 *	NOTA 2: $imm está representado como un numero en complemento a dos
	 */
	public function ANDI($rd,$rt,$imm){
		$res = '';
		$contenido_rt = $this->registers[$this->getRegisterNameFromBinaryRepresentation($rt)]["content"];
		$valor_imm = $this->intToBinaryString($this->getDecimalRepFromTwosComplement($imm),32);

		for($bit = 0; $bit < 32; $bit++){
			if (((substr($contenido_rt,$bit,1) )==1)  && ((substr($valor_imm,$bit,1))==1))
			$res = $res.'1';
			else
			$res = $res.'0';
		}
		$registro = $this->getRegisterNameFromBinaryRepresentation($rd);
		$this->registers[$registro]["content"] = $res;
	}

	/*
	 * BEQ, Bifurcacion si dos registros son iguales
	 * NOTA: $rt y $rd estan en su representación binaria
	 * NOtA 2: Si hay bifurcacion, PC = PC + offset
	 */
	public function BEQ($rt,$rs,$offset){
		$contenido_rt = $this->getRegisterContentFromBinaryRepresentation($rt);
		$contenido_rs = $this->getRegisterContentFromBinaryRepresentation($rs);
		if (strcmp($contenido_rt,$contenido_rs)==0){//bifurcar
			$this->registers["\$PC"]["content"] = $this->intToBinaryString($this->getDecimalRepFromTwosComplement($offset)+$this->getDecimalRepFromTwosComplement($this->registers["\$PC"]["content"]),32);
		}
	}

	/*
	 * BGEZ, Bifurcacion si el contenido de un registro es mayor o igual que cero
	 * NOTA: $rt esta en su representación binaria
	 * NOtA 2: Si hay bifurcacion, PC = PC + offset
	 */
	public function BGEZ($rt,$offset){
		$contenido_rt = $this->getRegisterContentFromBinaryRepresentation($rt);

		if ($this->getDecimalRepFromTwosComplement($contenido_rt) >= 0){//bifurcar
			$this->registers["\$PC"]["content"] = $this->intToBinaryString($this->getDecimalRepFromTwosComplement($offset)+$this->getDecimalRepFromTwosComplement($this->registers["\$PC"]["content"]),32);
		}
	}

	/*
	 * BGTZ, Bifurcacion si el contenido de un registro es mayor que cero
	 * NOTA: $rt esta en su representación binaria
	 * NOtA 2: Si hay bifurcacion, PC = PC + offset
	 */
	public function BGTZ($rt,$offset){
		$contenido_rt = $this->getRegisterContentFromBinaryRepresentation($rt);

		if ($this->getDecimalRepFromTwosComplement($contenido_rt) > 0){//bifurcar
			$this->registers["\$PC"]["content"] = $this->intToBinaryString($this->getDecimalRepFromTwosComplement($offset)+$this->getDecimalRepFromTwosComplement($this->registers["\$PC"]["content"]),32);
		}
	}

	/*
	 * BLEZ, Bifurcacion si el contenido de un registro es menor o igual que cero
	 * NOTA: $rt esta en su representación binaria
	 * NOtA 2: Si hay bifurcacion, PC = PC + offset
	 */
	public function BLEZ($rt,$offset){
		$contenido_rt = $this->getRegisterContentFromBinaryRepresentation($rt);

		if ($this->getDecimalRepFromTwosComplement($contenido_rt) <= 0){//bifurcar
			$this->registers["\$PC"]["content"] = $this->intToBinaryString($this->getDecimalRepFromTwosComplement($offset)+$this->getDecimalRepFromTwosComplement($this->registers["\$PC"]["content"]),32);
		}
	}

	public function BLTZ($rt,$offset){
		$contenido_rt = $this->registers[$this->getRegisterNameFromBinaryRepresentation($rt)]['content'];

		if ($this->getDecimalRepFromTwosComplement($contenido_rt)<0)
		{//bifurcar
			$this->registers["\$PC"]["content"] = $this->intToBinaryString($this->getDecimalRepFromTwosComplement($offset)+$this->getDecimalRepFromTwosComplement($this->registers["\$PC"]["content"]),32);
		}
	}

	/*
	 * BNE, Bifurcacion si el contenido de dos registros son diferentes
	 * NOTA: $rt y $rs esta en su representación binaria
	 * NOtA 2: Si hay bifurcacion, PC = PC + offset
	 */
	public function BNE($rt,$rs,$offset){
		$contenido_rt = $this->getRegisterContentFromBinaryRepresentation($rt);
		$contenido_rs = $this->getRegisterContentFromBinaryRepresentation($rs);
		if (!(strcmp($contenido_rt,$contenido_rs)==0)){//bifurcar
			$this->registers["\$PC"]["content"] = $this->intToBinaryString($this->getDecimalRepFromTwosComplement($offset)+$this->getDecimalRepFromTwosComplement($this->registers["\$PC"]["content"]),32);
		}
	}

	public function J($branch){
		$this->registers["\$PC"]["content"] = $this->intToBinaryString($this->getDecimalRepFromTwosComplement($branch),32);
	}

	public function JAL($branch,$address){
		$this->registers["\$ra"]["content"] = $this->registers["\$PC"]["content"];
		$this->registers["\$PC"]["content"] = $this->intToBinaryString($this->getDecimalRepFromTwosComplement($branch),32);

	}

	public function JR($rd){
		$this->registers["\$PC"]["content"] = $this->registers[$this->getRegisterNameFromBinaryRepresentation($rd)]["content"];
	}

	public function JALR($rd,$address){
		$this->registers["\$PC"]["content"] = $this->registers[$this->getRegisterNameFromBinaryRepresentation($rd)]["content"];
		$this->registers["\$PC"]["content"] = $this->intToBinaryString($this->getDecimalRepFromTwosComplement($branch),32);
	}

	public function LW($rd,$base,$offset){
		if (strcmp($base,"00000")==0){

			//es PC + offset
			$PC_value = $this->getDecimalFromUnsignedBin($this->registers["\$PC"]["content"]);
			$offset_value = $this->getDecimalRepFromTwosComplement($offset);
			$registro = $this->getRegisterNameFromBinaryRepresentation($rd);
			$this->registers[$registro]['content'] = $this->memoria[$PC_value+$offset_value];
		} else{
			//es base + offset
			$registro = $this->getRegisterNameFromBinaryRepresentation($base);
			$base_value = $this->getDecimalFromUnsignedBin($this->registers[$registro]["content"]);
			$offset_value = $this->getDecimalRepFromTwosComplement($offset);
			$registro = $this->getRegisterNameFromBinaryRepresentation($rd);
			$this->registers[$registro]['content'] = $this->memoria[$base_value+$offset_value];
			//!! aki hay que validar! :x
		}
	}

	public function SW($rfuente,$rbase,$offset){

		if (strcmp($rbase,"00000")==0){
			//es PC + offset
			$PC_value = $this->getDecimalFromUnsignedBin($this->registers["\$PC"]["content"]);
			$offset_value = $this->getDecimalRepFromTwosComplement($offset);
			$registrofuente = $this->getRegisterNameFromBinaryRepresentation($rfuente);
				
			$this->memoria[$PC_value+$offset_value] = $this->registers[$registrofuente]['content'];
				
			//!! aki hay que validar! :x
		} else{
			//es base + offset

			$registroBase = $this->getRegisterNameFromBinaryRepresentation($rbase);
			$base_value = $this->getDecimalFromUnsignedBin($this->registers[$registroBase]["content"]);
			$offset_value = $this->getDecimalRepFromTwosComplement($offset);
			$registroFuente = $this->getRegisterNameFromBinaryRepresentation($rfuente);
			$this->memoria[$base_value+$offset_value] = $this->registers[$registroFuente]['content'];
		}
	}
}
?>
