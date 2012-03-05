<?php 
//require_once('includes/globals.php');


if (!($this->lang->lang=='es')){?>
	<div id='welcome'>
	<h2>Welcome!</h2>
	<br/><br/>
		Filburt is a project developed by the three guys you see on the top (C. L&oacute;pez, H. Hurtarte and M. S&aacute;nchez) for
		the course CC3001, Introduction to Computers Organization from <a href='http://uvg.edu.gt'>UVG</a>.
		<br/><br/>
		It's main goal is to interprete the MIPS I ISA Assembly language with some extra <a href='http://pages.cs.wisc.edu/~larus/spim.html'>SPIM-based</a> directives implemented and described 
		in the documentation [es, but not hard to understand].
	</div>
<?php }
else {?>
	<div id='welcome'>
	<h2>Bienvenido!</h2>
	<br/><br/>
		Filburt es un proyecto desarrollado por los tres personajes que se ven arriba (C. L&oacute;pez, H. Hurtarte and M. S&aacute;nchez)
		para el curso CC3001, Introducci&oacute;n a la Organizaci&oacute;n de las computadoras de <a href='http://uvg.edu.gt'>UVG</a>
		<br/><br/>
		Su principal objetivo es el de interpretar el lenguaje ensamblador ISA de la MIPS I con algunas directivas basadas en <a href='http://pages.cs.wisc.edu/~larus/spim.html'>SPIM</a> extras implementadas y 
		descritas en la documentaci&oacute;n.
	</div>
<?php }?>
