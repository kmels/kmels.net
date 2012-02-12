---
title: Contador de impares ascendente (4 bits)
author: Carlos López Camey, Hugo Chinchilla
date: April 04, 2009
lang: es
tags: contador,impares,ascendente,bits,logica,binaria
---
Éste circuito trata acerca de un contador ascendente de números impares. Estos se representarán con números binarios de cuatro bits (esto deja trabajando al circuito únicamente contando de 1 a 15. El circuito es cíclico y necesitará de un oscilador para que esto suceda.

En éste reporte, se estará haciendo referencia al “circuito #1” como el primer intento para desarrollarlo, el “circuito #2” fue el que se realizó al final. La razón de esto fue, que a la hora de poner el circuito en práctica (en un protoboard), éste no funcionó dos veces consecutivas, tratandolo de repetir una última vez, nos dimos cuenta que éste se podía simplificar todavía vez más.

La manera en que se simplificó más, es, quitando una variable o un bit. Esto se pudo hacer gracias a que los números impares en binario siempre terminan en “1” (eg. 0001, 0011.. etc.); como los números en el circuito son representados con leds, éste último no lo tomaríamos en cuenta en el circuito y siempre estaría encendido.

<center>
<iframe src="http://crocodoc.com/Snadg9r?embedded=true" width="100%" height="600" style="border:1px solid #ddd;"></iframe>
</center>
