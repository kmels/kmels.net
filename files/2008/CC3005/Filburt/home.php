<?php 
	$this->get_headers();
?>

<div id="wrapper">
<TABLE class=columns cellSpacing=0>
  	<TBODY>
  		<TR width="100%">
    		<TD class=column id="td_content">
				<div class="content">
					
						<div style="" id="welcome"><p><?php require_once('welcome.php'); ?></p></div>
						<div style="display: none;" id="symbolstable"><p>
							<script>
								function cargarTablaSimbolos(){
									new Ajax.Request('symbols_table.php', {
									  method: 'get',
									  onSuccess: function(response) {
									    $('symbolstable').update(response.responseText);
									  }
									});
								} cargarTablaSimbolos();
							</script>
						</p></div>
						<div style="display: none;" id="showbin"><p>
							<script>
								function cargarBinario(){
									new Ajax.Request('showbin.php', {
									  method: 'get',
									  onSuccess: function(response) {
									    $('showbin').update(response.responseText);
									  }
									});
								} cargarBinario();
							</script>
						</p></div>
						<div style="display: none;" id="license"><p><?php require_once('license.php'); ?></p></div>
						<div style="display: none;" id="simulatordiv"><p>
						<script>
							function cargarSimulador(){
								new Ajax.Request('simulator.php', {
								  method: 'get',
								  onSuccess: function(response) {
								    $('simulatordiv').update(response.responseText);
								  }
								});
							} cargarSimulador();
						</script></p>
						</div>
					<script>
						var tabs = new Control.Tabs('the_tabs',{
							afterChange: function(new_container){
								cargarSimulador();
								cargarBinario();
								cargarTablaSimbolos();
							}
						});
					</script>
				</div>
            </TD>
    		<TD class=column id="td_right_sidebar">
      			<div id="right_sidebar">
						<center><h3> <?php echo $this->lang->text['filburt_show_console']?></h3></center>
    			</div> <!--right sidebox -->

				<br/>
				Documentaci&oacute;n.PDF
				
				<br/><br/>
				<?php if($this->lang->lang=='es'){ ?>
					<h3>Usamos</h3>
					<ul>
						<li>
							<a href='http://www.prototypejs.org/'>El framework Prototype</a> junto con:
						</li>
						<li>
							<a href='http://script.aculo.us/'>Scriptaculous</a>
						</li>
						<li>
							<a href='http://20bits.com/projects/dynamic-ajax-tabs/'>TabbedPane.js - Dynamic Ajax Tabs</a>
						</li>
						<li>
							<a href='http://www.millstream.com.au/upload/code/tablekit/'>TableKit</a>
						</li>
				<?php } else { ?>
					<h3>We use</h3>
					<ul>
						<li>
							<a href='http://www.prototypejs.org/'>The Prototype framework</a> along with:
						</li>
						<li>
							<a href='http://script.aculo.us/'>Scriptaculous</a>
						</li>
						<li>
							<a href='http://20bits.com/projects/dynamic-ajax-tabs/'>TabbedPane.js - Dynamic Ajax Tabs</a>
						</li>
						<li>
							<a href='http://www.millstream.com.au/upload/code/tablekit/'>TableKit</a>
						</li>
				<?php } ?>
				</ul>
				<br/><br/>
				<h3><?php echo $this->lang->text['main_references'];?></h3>
					<ul>
						<li>
							<a href='http://dkrizanc.web.wesleyan.edu/courses/231/07/mips-spim.pdf'>1994, Daniel J. Ellard, MIPS Assembly Language Programming, 
								CS50 Discussion and Pro ject Book</a>
							</li>
							<li>
								<a href='http://www.cs.cmu.edu/afs/cs/academic/class/15740-f97/public/doc/mips-isa.pdf'>1995, Charles Price, MIPS IV Instruction Set, Revision 3.2 </a>
							</li>
					</ul>
					
					
		<!-- no borrar, éste es el lado bonito de abajo de la tabla!-->
       <TR width="100%">
    		<TD id="td_footerleft">
    			
            </TD>
            <TD id="td_footerright">
    			
            </TD>
        </TR>
		<!-- no borrar, éste es el lado bonito de abajo de la tabla!-->
    </TBODY></TABLE>
</div> <!-- wrapper -->
