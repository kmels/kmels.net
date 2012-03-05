<?php

class Traductor
{
	public $instruccionesArray = array(); //Arreglo en donde se guarda la matriz de instrucciones reconocidas
	public $directivasArray = array(); //Arreglo donde se guarda la matriz de directivas reconocidas
	public $listadoAsciiArray = array(); //Arreglo donde se guarda la matriz de los caracteres reconocidos y sus ASCIIs en numeros
	public $registrosArray = array(); //Arreglo donde se guarda la representacion de los registros
	public $erroresArray = array(); //Arreglo donde se guardan los errores traduccion
	public $palabras = array(); //Arreglo donde se guardan y modifican las lineas que van a ser traducidas.
	public $matrizGenerada = array(); //Matriz con las lineas en binario que van a guardarse en archivo.bin
	public $matrizTablaSimbolos = array(); //Matriz con las etiquetas y sus direcciones
	public $matrizGeneradaSoloBinario = array(); //Matriz generada que no contiene informacion sobre las directivas
	public $dirText; //Contiene la direccion (en binario) a partir de la cual deben escribirse las instrucciones
	public $dirTextDec = 0; //Contiene la direccion (en decimal) a partir de la cual deben escribirse las instrucciones
	public $dirData; //Contiene la direccion (en binario) a partir de la cual deben escribirse los datos
	public $dirDataDec = 0; //Contiene la direccion (en binario) a partir de la cual deben escribirse los datos
	public $textEncontrada=false; //Variable que controla si se ha encontrado la directiva .TEXT
	public $dataEncontrada=false; //Variable que controla si se ha encontrado la directiva .DATA
	public $lineaDelData = 0;
	public $contadorGlobal;
	public $desplazamientosGeneral=0;
	public $diferenciaLabels=0;
	public $direccionActual=0;
	public function Traducir($pathArchivo)
	{
		//Generación de arreglo con nemonicos de instrucciones
		$this->instruccionesArray = file("./includes/listadoInstrucciones.txt");
		$this->directivasArray = file("./includes/listadoDirectivas.txt");
		$listadoAsciiArrayTemp = file("./includes/listadoAscii.txt");
		$this->inicializarRegistros();
		
		
		for($i=0;$i<count($this->instruccionesArray);$i++)
		{
			$this->instruccionesArray[$i] = $this->eliminarEscapeCaracters($this->instruccionesArray[$i]);
		}

		for($i=0;$i<count($this->directivasArray);$i++)
		{
			$this->directivasArray[$i] = $this->eliminarEscapeCaracters($this->directivasArray[$i]);
		}

		foreach($listadoAsciiArrayTemp as $linea)
		{
			array_push($this->listadoAsciiArray,explode(" ",$linea));
		}

		for($i=0;$i<count($this->listadoAsciiArray);$i++)
		{
			$this->listadoAsciiArray[$i][0] = $this->eliminarEscapeCaracters($this->listadoAsciiArray[$i][0]);
			$this->listadoAsciiArray[$i][1] = $this->eliminarEscapeCaracters($this->listadoAsciiArray[$i][1]);
		}

		//Creacion de un arreglo que contiene solo las palabras importantes
		$archivoASM = file($pathArchivo);
		$this->palabras = array(); //Arreglo bidimensional que termina conteniendo todas las palabras a procesar
		$temp = array(); //Arreglo temporal de usos variados
		$temp2 = array(); //Arreglo temporal de usos variados

		foreach($archivoASM as $linea)
		{
			array_push($this->palabras,explode(" ",$linea));
		}

		//Al final el arreglo $palabras es bidimensional y contiene las palabras
		//en una 'matriz' de (linea,No. de palabra) y ha eliminado las lineas que empiezan
		//con #
		$temp = count($this->palabras);
		for($i=0;$i<$temp;$i++)
		{
			if(substr($this->palabras[$i][0],0,1)=="#")	//Eliminacion de lineas que empiezan con #
			{
				unset($this->palabras[$i]);
			}
			else	//Eliminacion de los espacios
			{
				$temp2 = count($this->palabras[$i]);
				for($j=0;$j<$temp2;$j++)
				{
					if($this->palabras[$i][$j]==" "||$this->palabras[$i][$j]=="")
					{
						unset($this->palabras[$i][$j]);
					}
					if(substr($this->palabras[$i][$j],0,1)=="#")	//Eliminacion de las palabras siguientes a un #
					{
						for($k=$j;$k<$temp2;$k++)
						{
							unset($this->palabras[$i][$k]);
						}
					}
				}
			}
		}

		//Conversion a mayusculas para analisis y eliminacion de caracteres de escape
		$temp = array();
		foreach($this->palabras as $linea)
		{
			$temp2 = array();
			foreach($linea as $palabra)
			{
				$palabra = strtoupper($palabra);
				$palabra = $this->eliminarEscapeCaracters($palabra);
				array_push($temp2,$palabra);
			}
			array_push($temp,$temp2);
		}
		$this->palabras = $temp;



		//Eliminacion de ""
		$temp = count($this->palabras);
		for($i=0;$i<$temp;$i++)
		{
			$temp2 = count($this->palabras[$i]);
			for($j=0;$j<$temp2;$j++)
			{
				if($this->palabras[$i][$j]=="")
				{
					unset($this->palabras[$i][$j]);
				}
			}
			if($this->palabras[$i][0]==""||$this->palabras[$i][0]==" "||$this->palabras[$i][0]=="\n")
			{
				unset($this->palabras[$i]);
			}
		}



		//Regeneracion de la matriz (el vector bidimensional) para reindexar los elementos
		$this->reindexarMatizPalabras();


		//Agregamiento de un ultimo elemento a cada linea, que representa su numero relativo de celda en memoria
		$temp = count($this->palabras);
		for($i=0;$i<$temp;$i++)
		{
			array_push($this->palabras[$i],$i);
		}


		//var_dump($this->palabras);

		//Procesamiento de directivas, etiquetas y generación de tabla de simbolos
		//PRIMERA CORRIDA
		for($this->contadorGlobal=0;$this->contadorGlobal<count($this->palabras);$this->contadorGlobal++)
		{
			$palabra = $this->palabras[$this->contadorGlobal][0];
			if(in_array($palabra,$this->instruccionesArray))
			{
				//Es una instruccion, se dejara para la segunda corrida
			}
			elseif(in_array($palabra,$this->directivasArray))
			{
				$this->procesarDirectiva($this->contadorGlobal,0);
			}
			else
			{
				$this->procesarLabel($this->contadorGlobal,0);
			}
		}

		//Recorrido de la matriz para cambiar aquellas directivas .WORD

		for($i=0;$i<count($this->matrizGenerada);$i++)
		{
			if(!(substr($this->matrizGenerada[$i],0,1)=="1"||substr($this->matrizGenerada[$i],0,1)=="0"||substr($this->matrizGenerada[$i],0,1)=="\n"))
			{
				$cambiado = false;
				for($j=0;$j<count($this->matrizTablaSimbolos);$j++)
				{
					if($this->matrizGenerada[$i]==$this->matrizTablaSimbolos[$j][0])
					{
						$this->matrizGenerada[$i] = $this->intToBinaryString($this->matrizTablaSimbolos[$j][1],32);
						$j=count($this->matrizTablaSimbolos)-1;
						$cambiado = true;
					}
				}
				if(!$cambiado)
				{
					$this->matrizGenerada[$i] = $this->parseNumDecHexaBin($this->matrizGenerada[$i],32);
				}
			}
		}

		//Luego de la primera corrida se eliminan del arreglo $this->palabras las lineas que correspondan a labels
		$temp = count($this->palabras);
		for($this->contadorGlobal=0;$this->contadorGlobal<$temp;$this->contadorGlobal++)
		{
			$palabra = $this->palabras[$this->contadorGlobal][0];
			for($i=0;$i<count($this->matrizTablaSimbolos);$i++)
			{
				if($palabra==$this->matrizTablaSimbolos[$i][0])
				{
					unset($this->palabras[$this->contadorGlobal]);
				}
			}
		}
		$this->reindexarMatizPalabras();

		//Procesamiento de instrucciones
		//SEGUNDA CORRIDA
		for($this->contadorGlobal=0;$this->contadorGlobal<count($this->palabras);$this->contadorGlobal++)
		{

			$palabra = $this->palabras[$this->contadorGlobal][0];
			if(in_array($palabra,$this->instruccionesArray))
			{
				$this->procesarInstruccion($this->contadorGlobal,0);
			}
			else
			{
				$this->agregarError("Error en segunda corrida: elemento $palabra no es una instruccion.");
			}
		}

		$archivoBIN = fopen("generados/archivo.bin","w");
		foreach($this->matrizGenerada as $linea)
		{
			if(strpos($linea,"\n")=='NULL')
			{
				fwrite($archivoBIN,$linea);
			}
			else
			{
				fwrite($archivoBIN,$linea."\n");
			}
		}
		fclose($archivoBIN);

		$tablaSimbolos = fopen("generados/tablaSimbolos.txt","w");
		foreach($this->matrizTablaSimbolos as $matriz)
		{
			fwrite($tablaSimbolos,$matriz[0]." ".$matriz[1]."\n");
		}
		fclose($tablaSimbolos);


		//Generacion de la matriz matrizGeneradaSoloBinario que contiene las instrucciones en binario y otro
		//campo con su numero absoluto de linea
		$DataEncontrada = false;
		$desplazamientosData=0;
		for($i=1;$i<count($this->matrizGenerada);$i++)
		{
			if($this->dirDataDec!=0)
			{
				if(substr($this->matrizGenerada[$i],0,1)=="\n")
				{
					$i++;
					$DataEncontrada=true;
				}
				else
				{
					if(!$DataEncontrada)
					{
						array_push($this->matrizGeneradaSoloBinario,array($i+$this->dirTextDec-1,$this->matrizGenerada[$i]));
					}
					else
					{
						array_push($this->matrizGeneradaSoloBinario,array($desplazamientosData+$this->dirDataDec,$this->matrizGenerada[$i]));
						$desplazamientosData++;
					}
				}
			}
			else
			{
				if(substr($this->matrizGenerada[$i],0,1)=="\n")
				{
					$i++;
					$DataEncontrada=true;
				}
				else
				{
					if(!$DataEncontrada)
					{
						array_push($this->matrizGeneradaSoloBinario,array($i+$this->dirTextDec-1,$this->matrizGenerada[$i]));
					}
					else
					{
						array_push($this->matrizGeneradaSoloBinario,array($i+$this->dirTextDec-3,$this->matrizGenerada[$i]));
					}
				}
			}
		}

		if(isset($this->erroresArray[0]))
		{
			echo "<pre>";
			print_r($this->erroresArray);
			echo "</pre>";
		}


		//Impresiones de pruebas
		//echo "dir text: ".$this->dirTextDec;
		//echo "dir data: ".$this->dirDataDec;
		/*
		echo "<pre>";
		print_r($this->erroresArray);
		echo "</pre>";

		foreach($this->matrizGenerada as $linea)
		{
		echo $linea."<br>";
		}

		echo "<pre>";
		print_r($this->matrizTablaSimbolos);
		print_r($this->palabras);
		echo "</pre>";
		echo "<br><br>";
		*/
	}

	public function eliminarEscapeCaracters($string)
	{
		$retorno = str_replace("\n","",$string);
		$retorno = str_replace("\t","",$retorno);
		$retorno = str_replace("\r","",$retorno);
		return $retorno;
	}

	public function intToBinaryString($int,$numBits)
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

	public function signExtensionString($binaryString,$numBits)
	{

	}

	public function hexaStringToBinaryString($hexaString,$numBits)
	{
		if(strlen($hexaString)>((int)($numBits/4)))
		{
			$this->agregarError("Error en primera corrida: el numero representado por $hexaString es demasiado grande para $numBits bits");
		}
		else
		{
			return $this->intToBinaryString(hexdec($hexaString),$numBits);
		}
	}

	public function decStringToInt($decString)
	{
		$num = (int)$decString;
		if($num==0&&$decString!="0")
		{
			$this->agregarError("Error en primera corrida: $decString no se reconoce como un numero decimal");
			return $num;
		}
		else
		{
			return $num;
		}
	}

	public function binStringToInt($binString)
	{

	}

	public function procesarDirectiva($numLinea,$numColumnaActual)
	{
		switch($this->palabras[$numLinea][$numColumnaActual])
		{
			case ".TEXT":
				if(!$this->textEncontrada)
				{
					if(is_string($this->palabras[$numLinea][$numColumnaActual+1]))
					{
						$this->dirText = $this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+1],32);
						if(substr($this->palabras[$numLinea][$numColumnaActual+1],0,1)=="%")
						{
							$this->dirTextDec = (int)(substr($this->palabras[$numLinea][$numColumnaActual+1],1));
						}
						else
						{
							$this->dirTextDec = hexdec(substr($this->palabras[$numLinea][$numColumnaActual+1],1));
						}
					}
					else
					{
						$this->dirText = $this->parseNumDecHexaBin("%0",32);
						$this->dirDataDec = 0;
					}

					unset($this->palabras[$numLinea]);
					$this->reindexarMatizPalabras();
					$this->regeneracionDeNumeroDeLinea();
					$this->reindexarMatizPalabras();
					$this->contadorGlobal = $this->contadorGlobal-1;
					$this->textEncontrada=true;
					array_push($this->matrizGenerada,$this->dirText);
				}
				else
				{
					$this->agregarError("Error en primera corrida: dos .TEXT encontrados");
				}
				break;
			case ".DATA":
				if(!$this->dataEncontrada)
				{
					if($this->textEncontrada)
					{
						if(is_string($this->palabras[$numLinea][$numColumnaActual+1]))
						{
							$this->dirData = $this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+1],32);
							if(substr($this->palabras[$numLinea][$numColumnaActual+1],0,1)=="%")
							{
								$this->dirDataDec = (int)(substr($this->palabras[$numLinea][$numColumnaActual+1],1));
							}
							else
							{
								$this->dirDataDec = hexdec(substr($this->palabras[$numLinea][$numColumnaActual+1],1));
							}
						}
						else
						{
							$this->dirData = $this->parseNumDecHexaBin("%0",32);
							$this->dirDataDec = 0;
						}

						$temp = count($this->palabras[$numLinea])-1;
						$this->lineaDelData = $this->palabras[$numLinea][$temp];

						unset($this->palabras[$numLinea]);
						$this->reindexarMatizPalabras();
						$this->regeneracionDeNumeroDeLinea();
						$this->reindexarMatizPalabras();
						$this->contadorGlobal = $this->contadorGlobal-1;

						$this->dataEncontrada=true;
							
						array_push($this->matrizGenerada,"\n");
						array_push($this->matrizGenerada,$this->dirData);
					}
					else
					{
						$this->agregarError("Error en primera corrida: el contenido de .DATA debe estar luego de un .TEXT");
					}
				}
				else
				{
					$this->agregarError("Error en primera corrida: dos .DATA encontrados");
				}
				break;
			case ".ASCII":
				if($this->dataEncontrada)
				{
					$stringTemp = $this->palabras[$numLinea][$numColumnaActual+1];
					for($i=$numColumnaActual+2;$i<count($this->palabras[$numLinea])-1;$i++)
					{
						$stringTemp = $stringTemp." ".$this->palabras[$numLinea][$i];
					}

					$stringTemp = substr($stringTemp,1,strlen($stringTemp)-2);
					for($i=0;$i<strlen($stringTemp);$i++)
					{
						if(substr($stringTemp,$i,1)==" ")
						{
							array_push($this->matrizGenerada,$this->caracterStringToBin("sp",32));
						}
						elseif(substr($stringTemp,$i,1)=="\\")
						{
							array_push($this->matrizGenerada,$this->caracterStringToBin(substr($stringTemp,$i,2),32));
							$i++;
						}
						else
						{
							array_push($this->matrizGenerada,$this->caracterStringToBin(substr($stringTemp,$i,1),32));
						}

						//
						$this->desplazamientosGeneral++;
						//
					}
					if($numColumnaActual==0)
					{
						unset($this->palabras[$numLinea]);
						$this->reindexarMatizPalabras();
						$this->regeneracionDeNumeroDeLinea();
						$this->reindexarMatizPalabras();
						$this->contadorGlobal = $this->contadorGlobal-1;
					}
				}
				else
				{
					$this->agregarError("Error en primera corrida: .ASCIIZ debe estar luego de un .DATA");
				}
				break;
			case ".ASCIIZ":
				if($this->dataEncontrada)
				{
					$stringTemp = $this->palabras[$numLinea][$numColumnaActual+1];
					for($i=$numColumnaActual+2;$i<count($this->palabras[$numLinea])-1;$i++)
					{
						$stringTemp = $stringTemp." ".$this->palabras[$numLinea][$i];
					}

					$stringTemp = substr($stringTemp,1,strlen($stringTemp)-2);
					for($i=0;$i<strlen($stringTemp);$i++)
					{
						if(substr($stringTemp,$i,1)==" ")
						{
							array_push($this->matrizGenerada,$this->caracterStringToBin("sp",32));
						}
						elseif(substr($stringTemp,$i,1)=="\\")
						{
							array_push($this->matrizGenerada,$this->caracterStringToBin(substr($stringTemp,$i,2),32));
							$i++;
						}
						else
						{
							array_push($this->matrizGenerada,$this->caracterStringToBin(substr($stringTemp,$i,1),32));
						}
						//
						$this->desplazamientosGeneral++;
						//
					}

					array_push($this->matrizGenerada,$this->caracterStringToBin("null",32));

					//
					$this->desplazamientosGeneral++;
					//

					if($numColumnaActual==0)
					{
						unset($this->palabras[$numLinea]);
						$this->reindexarMatizPalabras();
						$this->regeneracionDeNumeroDeLinea();
						$this->reindexarMatizPalabras();
						$this->contadorGlobal = $this->contadorGlobal-1;
					}
				}
				else
				{
					$this->agregarError("Error en primera corrida: .ASCIIZ debe estar luego de un .DATA");
				}
				break;
			case ".SPACE":
				if($this->dataEncontrada)
				{
					$num = $this->decStringToInt($this->palabras[$numLinea][$numColumnaActual+1]);
					for($i=0;$i<$num;$i++)
					{
						array_push($this->matrizGenerada,$this->caracterStringToBin("null",32));
						//
						$this->desplazamientosGeneral++;
						//
					}
					if($numColumnaActual==0)
					{
						unset($this->palabras[$numLinea]);
						$this->reindexarMatizPalabras();
						$this->regeneracionDeNumeroDeLinea();
						$this->reindexarMatizPalabras();
						$this->contadorGlobal = $this->contadorGlobal-1;
					}
				}
				else
				{
					$this->agregarError("Error en primera corrida: .SPACE debe estar luego de un .DATA");
				}
				break;
			case ".WORD":
				if($this->dataEncontrada)
				{
					if(is_string($this->palabras[$numLinea][$numColumnaActual+1]))
					{
						$this->palabras[$numLinea][$numColumna+1] = $this->eliminarEscapeCaracters($this->palabras[$numLinea][$numColumna+1]);
						array_push($this->matrizGenerada,$this->palabras[$numLinea][$numColumnaActual+1]);
						$this->desplazamientosGeneral++;
						if($numColumnaActual==0)
						{
							unset($this->palabras[$numLinea]);
							$this->reindexarMatizPalabras();
							$this->regeneracionDeNumeroDeLinea();
							$this->reindexarMatizPalabras();
							$this->contadorGlobal = $this->contadorGlobal-1;
						}
					}
					else
					{
						$this->agregarError("Error en primera corrida: .WORD debe recibir un parametro");
					}
				}
				else
				{
					$this->agregarError("Error en primera corrida: .WORD debe estar luego de un .DATA");
				}
				break;
		}
	}

	public function caracterStringToBin($string,$numBits)
	{
		$index = $this->SearchBiDimArray($this->listadoAsciiArray,0,$string,true);
		if($index!=NULL)
		{
			return $this->intToBinaryString((int)$this->listadoAsciiArray[$index][1],$numBits);
		}
		elseif($index==0)
		{
			return $this->intToBinaryString(0,$numBits);
		}
		else
		{
			$this->agregarError("Error en primera corrida: caracter $string no se reconoce como un caracter ASCII implementado");
		}
	}

	public function parseNumDecHexaBin($string,$numBits)
	{
		$binaryString="";

		if(substr($string,0,1)=="X")
		{
			$binaryString = $this->hexaStringToBinaryString(substr($string,1),$numBits);
		}
		elseif(substr($string,0,1)=="%")
		{
			$num = $this->decStringToInt(substr($string,1));
			$binaryString = $this->intToBinaryString($num,$numBits);
		}
		else
		{
			$this->agregarError("Error en la primera corrida: $string no se reconoce como un numero en decimal ni hexadecimal, debe especificar x para hexadecimal y % para decimal");
		}
		return $binaryString;
	}

	public function SearchBiDimArray(&$theArray, $dimNo, $searchValue, $returnIndex = true)
	{
		if(is_array($theArray)){
			$keys = array_keys($theArray[0]);
			$key = $keys[$dimNo];
			$elcount = count($theArray);

			for($i=0; $i < $elcount; $i++){
				if($theArray[$i][$key] === $searchValue){
					if ($returnIndex){
						return $i;
					}
					else{
						return $theArray[$i];
					}
				}
			}
		}
		else{
			return array_search($searchValue, $theArray);
		}
	}

	public function procesarLabel($numLinea,$numColumnaActual)
	{
		if($this->textEncontrada)
		{
			if($numColumnaActual==0)
			{
				if(is_string($this->palabras[$numLinea][$numColumnaActual+1]))
				{
					if(in_array($this->palabras[$numLinea][$numColumnaActual+1],$this->instruccionesArray))
					{
						$temp = count($this->palabras[$numLinea])-1;
						array_push($this->matrizTablaSimbolos,array($this->palabras[$numLinea][$numColumnaActual],$this->palabras[$numLinea][$temp]+$this->desplazamientosGeneral-$this->diferenciaLabels));

						unset($this->palabras[$numLinea][$numColumnaActual]);
						$this->reindexarMatizPalabras();
						$this->regeneracionDeNumeroDeLinea();
						$this->reindexarMatizPalabras();
					}
					elseif(in_array($this->palabras[$numLinea][$numColumnaActual+1],$this->directivasArray))
					{
						$temp = count($this->palabras[$numLinea])-1;
						array_push($this->matrizTablaSimbolos,array($this->palabras[$numLinea][$numColumnaActual],$this->palabras[$numLinea][$temp]+$this->desplazamientosGeneral-$this->diferenciaLabels));
						$this->diferenciaLabels++;
						$this->procesarDirectiva($numLinea,$numColumnaActual+1);

					}
					else
					{
						$temp = count($this->palabras[$numLinea])-1;
						array_push($this->matrizTablaSimbolos,array($this->palabras[$numLinea][$numColumnaActual],$this->palabras[$numLinea][$temp]+$this->desplazamientosGeneral-$this->diferenciaLabels));

						unset($this->palabras[$numLinea][$numColumnaActual]);
						$this->reindexarMatizPalabras();
						$this->regeneracionDeNumeroDeLinea();
						$this->reindexarMatizPalabras();
					}
				}
				else
				{
					unset($this->palabras[$numLinea][$numColumnaActual+1]);
					$this->reindexarMatizPalabras();

					for($i=0;$i<count($this->palabras[$numLinea+1]);$i++)
					{
						array_push($this->palabras[$numLinea],$this->palabras[$numLinea+1][$i]);
					}

					unset($this->palabras[$numLinea+1]);
					$this->reindexarMatizPalabras();
					$this->regeneracionDeNumeroDeLinea();
					$this->reindexarMatizPalabras();

					if(in_array($this->palabras[$numLinea][$numColumnaActual+1],$this->instruccionesArray))		//TODO aqui hay otra llamada para la instruccion, hay que ojearla
					{

						$temp = count($this->palabras[$numLinea])-1;
						array_push($this->matrizTablaSimbolos,array($this->palabras[$numLinea][$numColumnaActual],$this->palabras[$numLinea][$temp]+$this->desplazamientosGeneral-$this->diferenciaLabels));

						unset($this->palabras[$numLinea][$numColumnaActual]);

						$this->reindexarMatizPalabras();
						$this->regeneracionDeNumeroDeLinea();
						$this->reindexarMatizPalabras();

					}
					elseif(in_array($this->palabras[$numLinea][$numColumnaActual+1],$this->directivasArray))
					{
						$temp = count($this->palabras[$numLinea])-1;
						array_push($this->matrizTablaSimbolos,array($this->palabras[$numLinea][$numColumnaActual],$this->palabras[$numLinea][$temp]+$this->desplazamientosGeneral-$this->diferenciaLabels));
						$this->diferenciaLabels++;
						$this->procesarDirectiva($numLinea,$numColumnaActual+1);
					}
					else
					{
						$temp = count($this->palabras[$numLinea])-1;
						array_push($this->matrizTablaSimbolos,array($this->palabras[$numLinea][$numColumnaActual],$this->palabras[$numLinea][$temp]+$this->desplazamientosGeneral-$this->diferenciaLabels));
						unset($this->palabras[$numLinea][$numColumnaActual]);
						$this->reindexarMatizPalabras();
						$this->regeneracionDeNumeroDeLinea();
						$this->reindexarMatizPalabras();
					}
				}
			}
			else
			{
				$this->agregarError("error en procesarLabel($numLinea,$numColumnaActual), no se ha identificado $this->palabras[$numLinea][$numColumnaActual]<br>");
			}
		}
		else
		{
			$this->agregarError("no se ha encontrado directiva .TEXT procesarLabel($numLinea,$numColumnaActual)<br>");
		}
	}

	public function reindexarMatizPalabras()
	{
		$temp = array();
		foreach($this->palabras as $linea)
		{
			$temp2 = array();
			foreach($linea as $palabra)
			{
				array_push($temp2,$palabra);
			}
			array_push($temp,$temp2);
		}
		$this->palabras = $temp;
		/*
		 for($i=0;$i<count($this->palabras);$i++)
		 {
			$temp = count($this->palabras[$i])-1;
			echo $this->palabras[$i][0].": ".$this->palabras[$i][$temp]."  ";
			}
			echo "<br><br>";
			*/
	}

	public function regeneracionDeNumeroDeLinea()
	{
		$desplazamientosData=0;
		for($i=0;$i<count($this->palabras);$i++)
		{
			$temp = count($this->palabras[$i])-1;
			//$this->palabras[$i][$temp] = $i;
			if($this->dirDataDec==0)
			{
				//echo "true";
				$this->palabras[$i][$temp] = $i+$this->dirTextDec;
			}
			else
			{
				//echo "false";
				if(!($this->palabras[$i][$temp]<$this->lineaDelData))
				{
					$this->palabras[$i][$temp] = $desplazamientosData+$this->dirDataDec;
					$desplazamientosData++;
				}
			}
			//echo $this->palabras[$i][$temp]." ";
		}
		//echo "<br>";
	}

	public function procesarInstruccion($numLinea,$numColumnaActual)
	{
		switch($this->palabras[$numLinea][$numColumnaActual])
		{
			case "ADD":
				if($this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+3]))
				{
					$stringTemp = "000000";
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+2]);
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+3]);
					$stringTemp = $stringTemp."00000"."100000";
				}
				else
				{
					$stringTemp = "001000";
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+2]);
					$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+3],16);
				}

				$this->direccionActual++;
				break;
			case "ADDI":
				$stringTemp = "001000";
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+2]);
				$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+3],16);
				$this->direccionActual++;
				break;
			case "AND":
				if($this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+3]))
				{
					$stringTemp = "000000";
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+2]);
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+3]);
					$stringTemp = $stringTemp."00000"."100100";
				}
				else
				{
					$stringTemp = "001100";
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+2]);
					$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+3],16);
				}
				$this->direccionActual++;
				break;
			case "ANDI":
				$stringTemp = "001100";
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+2]);
				$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+3],16);
				$this->direccionActual++;
				break;
			case "NOP":
				$stringTemp = "00000000000000000000000000000000";
				$this->direccionActual++;
				break;
			case "LW":
				$stringTemp = "100011";
				if($this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+2]))
				{
					//echo $this->palabras[$numLinea][$numColumnaActual+1]." : ".$this->palabras[$numLinea][$numColumnaActual+2]." : ".$this->palabras[$numLinea][$numColumnaActual+3];

					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+2]);
					$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+3],16);
				}
				else
				{
					//echo $this->palabras[$numLinea][$numColumnaActual+1]." : 00000 : ".$this->palabras[$numLinea][$numColumnaActual+2];
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
					$stringTemp = $stringTemp."00000";
					$pos = $this->SearchBiDimArray($this->matrizTablaSimbolos,0,$this->palabras[$numLinea][$numColumnaActual+2],true);
					if($this->matrizTablaSimbolos[$pos][0]==$this->palabras[$numLinea][$numColumnaActual+2])
					{
						$stringTemp = $stringTemp.$this->intToBinaryString($this->matrizTablaSimbolos[$pos][1]-$this->direccionActual-1,16);
					}
					else
					{
						$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+2],16);
					}
				}
				$this->direccionActual++;
				//echo $stringTemp;
				break;
			case "SW":

				$stringTemp = "101011";
				if($this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+2]))
				{

					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+2]);
					$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+3],16);

				}
				else
				{
					$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
					$stringTemp = $stringTemp."00000";

					//$this->agregarError($pos);
					$pos = $this->SearchBiDimArray($this->matrizTablaSimbolos,0,$this->palabras[$numLinea][$numColumnaActual+2],true);
					if($this->matrizTablaSimbolos[$pos][0]==$this->palabras[$numLinea][$numColumnaActual+2])
					{
						$stringTemp = $stringTemp.$this->intToBinaryString($this->matrizTablaSimbolos[$pos][1]-$this->direccionActual-1,16);
					}
					else
					{
						$strintTemp = $stringTemp.$this->parseNumDecHexaBin("%10",16);
						$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+2],16);
					}
				}
				$this->direccionActual++;
				break;
			case "BEQ":
				$stringTemp = "000100";
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+2]);

				$pos = $this->SearchBiDimArray($this->matrizTablaSimbolos,0,$this->palabras[$numLinea][$numColumnaActual+3],true);
				if($this->matrizTablaSimbolos[$pos][0]==$this->palabras[$numLinea][$numColumnaActual+3])
				{
					$stringTemp = $stringTemp.$this->intToBinaryString($this->matrizTablaSimbolos[$pos][1]-$this->direccionActual-1,16);
				}
				else
				{
					$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+3],16);
				}
				$this->direccionActual++;
				//echo $stringTemp;
				break;
			case "BNE":
				$stringTemp = "000101";
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+2]);

				$pos = $this->SearchBiDimArray($this->matrizTablaSimbolos,0,$this->palabras[$numLinea][$numColumnaActual+3],true);
				if($this->matrizTablaSimbolos[$pos][0]==$this->palabras[$numLinea][$numColumnaActual+3])
				{
					$stringTemp = $stringTemp.$this->intToBinaryString($this->matrizTablaSimbolos[$pos][1]-$this->direccionActual-1,16);
				}
				else
				{
					$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+3],16);
				}
				$this->direccionActual++;
				//echo $
				break;
			case "BGEZ":
				$stringTemp = "000001";
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
				$stringTemp = $stringTemp."00001";

				$pos = $this->SearchBiDimArray($this->matrizTablaSimbolos,0,$this->palabras[$numLinea][$numColumnaActual+2],true);
				if($this->matrizTablaSimbolos[$pos][0]==$this->palabras[$numLinea][$numColumnaActual+2])
				{
					$stringTemp = $stringTemp.$this->intToBinaryString($this->matrizTablaSimbolos[$pos][1]-$this->direccionActual-1,16);
				}
				else
				{
					$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+2],16);
				}
				$this->direccionActual++;
				//echo $stringTemp."<br>";
				break;
			case "BGTZ":
				$stringTemp = "000111";
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
				$stringTemp = $stringTemp."00000";

				$pos = $this->SearchBiDimArray($this->matrizTablaSimbolos,0,$this->palabras[$numLinea][$numColumnaActual+2],true);
				if($this->matrizTablaSimbolos[$pos][0]==$this->palabras[$numLinea][$numColumnaActual+2])
				{
					$stringTemp = $stringTemp.$this->intToBinaryString($this->matrizTablaSimbolos[$pos][1]-$this->direccionActual-1,16);
				}
				else
				{
					$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+2],16);
				}
				$this->direccionActual++;
				//echo $stringTemp."<br>";
				break;
			case "BLTZ":
				$stringTemp = "000001";
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
				$stringTemp = $stringTemp."00000";

				$pos = $this->SearchBiDimArray($this->matrizTablaSimbolos,0,$this->palabras[$numLinea][$numColumnaActual+2],true);
				if($this->matrizTablaSimbolos[$pos][0]==$this->palabras[$numLinea][$numColumnaActual+2])
				{
					$stringTemp = $stringTemp.$this->intToBinaryString($this->matrizTablaSimbolos[$pos][1]-$this->direccionActual-1,16);
				}
				else
				{
					$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+2],16);
				}
				$this->direccionActual++;
				//echo $stringTemp."<br>";
				break;
			case "BLEZ":
				$stringTemp = "000110";
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
				$stringTemp = $stringTemp."00000";

				$pos = $this->SearchBiDimArray($this->matrizTablaSimbolos,0,$this->palabras[$numLinea][$numColumnaActual+2],true);
				if($this->matrizTablaSimbolos[$pos][0]==$this->palabras[$numLinea][$numColumnaActual+2])
				{
					$stringTemp = $stringTemp.$this->intToBinaryString($this->matrizTablaSimbolos[$pos][1]-$this->direccionActual-1,16);
				}
				else
				{
					$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+2],16);
				}
				$this->direccionActual++;
				//echo $stringTemp."<br>";
				break;
			case "J":

				$stringTemp = "000010";
				$pos = $this->SearchBiDimArray($this->matrizTablaSimbolos,0,$this->palabras[$numLinea][$numColumnaActual+1],true);
				if($this->matrizTablaSimbolos[$pos][0]==$this->palabras[$numLinea][$numColumnaActual+1])
				{
					$stringTemp = $stringTemp.$this->intToBinaryString($this->matrizTablaSimbolos[$pos][1],26);
				}
				else
				{
					//$stringTemp = $stringTemp.$this->intToBinaryString($this->matrizTablaSimbolos[0][1],26);
					$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+1],26);
				}
				$this->direccionActual++;
				break;
			case "JAL":
				$stringTemp = "000011";
				$pos = $this->SearchBiDimArray($this->matrizTablaSimbolos,0,$this->palabras[$numLinea][$numColumnaActual+1],true);
				if($this->matrizTablaSimbolos[$pos][0]==$this->palabras[$numLinea][$numColumnaActual+1])
				{
					$stringTemp = $stringTemp.$this->intToBinaryString($this->matrizTablaSimbolos[$pos][1],26);
				}
				else
				{
					$stringTemp = $stringTemp.$this->parseNumDecHexaBin($this->palabras[$numLinea][$numColumnaActual+1],26);
				}
				$this->direccionActual++;
				//echo $stringTemp."<br>";
				break;
			case "JR":
				$stringTemp = "000000";
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1]);
				$stringTemp = $stringTemp."000000000000000"."001000";
				$this->direccionActual++;
				//echo $stringTemp."<br>";
				break;
			case "JALR":
				$stringTemp = "000000";
				if(!($stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister($this->palabras[$numLinea][$numColumnaActual+1])))
				{
					$this->agregarError("Error en segunda corrida: JALR debe recibir un registro como argumento");
				}
				$stringTemp = $stringTemp."00000";
				$stringTemp = $stringTemp.$this->getBinaryRepresentationOfRegister("\$RA");
				$stringTemp = $stringTemp."00000";
				$stringTemp = $stringTemp."001001";
				$this->direccionActual++;
				//echo $stringTemp."<br>";
				break;
			case "SYSCALL":
				$stringTemp = "000000"."00000000000000000000"."001100";
				$this->direccionActual++;
				break;
		}
		//echo $this->palabras[$numLinea][$numColumnaActual]." : ".$stringTemp."<br>";
		$this->matrizGenerada = $this->insertArrayIndex($this->matrizGenerada,$stringTemp,$this->direccionActual);
	}

	public function inicializarRegistros()
	{
		$this->registers = array("v0" => array("content" => $this->getNOP(), "binaryRepresentation" => "00010"),
									"\$V1" => array("content" => $this->getNOP(), "binaryRepresentation" => "00011"),
									"\$A0" => array("content" => $this->getNOP(), "binaryRepresentation" => "00100"),
									"\$A1" => array("content" => $this->getNOP(), "binaryRepresentation" => "00101"),
									"\$A2" => array("content" => $this->getNOP(), "binaryRepresentation" => "00110"),
									"\$A3" => array("content" => $this->getNOP(), "binaryRepresentation" => "00111"),
									"\$T0" => array("content" => $this->getNOP(), "binaryRepresentation" => "01000"),
									"\$T1" => array("content" => $this->getNOP(), "binaryRepresentation" => "01001"),
									"\$T2" => array("content" => $this->getNOP(), "binaryRepresentation" => "01010"),
									"\$T3" => array("content" => $this->getNOP(), "binaryRepresentation" => "01011"),
									"\$T4" => array("content" => $this->getNOP(), "binaryRepresentation" => "01100"),
									"\$T5" => array("content" => $this->getNOP(), "binaryRepresentation" => "01101"),
									"\$T6" => array("content" => $this->getNOP(), "binaryRepresentation" => "01110"),
									"\$T7" => array("content" => $this->getNOP(), "binaryRepresentation" => "01111"),
									"\$T8" => array("content" => $this->getNOP(), "binaryRepresentation" => "11000"),
									"\$T9" => array("content" => $this->getNOP(), "binaryRepresentation" => "11001"),
									"\$S0" => array("content" => $this->getNOP(), "binaryRepresentation" => "10000"),
									"\$S1" => array("content" => $this->getNOP(), "binaryRepresentation" => "10001"),
									"\$S2" => array("content" => $this->getNOP(), "binaryRepresentation" => "10010"),
									"\$S3" => array("content" => $this->getNOP(), "binaryRepresentation" => "10011"),
									"\$S4" => array("content" => $this->getNOP(), "binaryRepresentation" => "10100"),
									"\$S5" => array("content" => $this->getNOP(), "binaryRepresentation" => "10101"),
									"\$S6" => array("content" => $this->getNOP(), "binaryRepresentation" => "10110"),
									"\$S7" => array("content" => $this->getNOP(), "binaryRepresentation" => "10111"),
									"\$RA" => array("content" => $this->getNOP(), "binaryRepresentation" => "11111"),
									"PC" => array("content" => $this->getNOP()),
									"IR" => array("content" => $this->getNOP())
		);
	}

	public function getBinaryRepresentationOfRegister($registerName)
	{
		return $this->registers[$registerName]['binaryRepresentation'];
	}

	public function getNOP()
	{
		return "00000000000000000000000000000000"; //32 bits NO-OP
	}

	public function insertArrayIndex($array, $new_element, $index) {
		/*** get the start of the array ***/
		$start = array_slice($array, 0, $index);
		/*** get the end of the array ***/
		$end = array_slice($array, $index);
		/*** add the new element to the array ***/
		$start[] = $new_element;
		/*** glue them back together and return ***/
		return array_merge($start, $end);
	}

	public function agregarError($mensaje)
	{
		array_push($this->erroresArray,$mensaje);
	}

}
?>