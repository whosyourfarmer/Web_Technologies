<?php 
function print_tabs($tabs) { 
	for($i = 0; $i < $tabs; $i++) { 
		echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	}
}

function print_array($arr, $tabs = 0) {
	if(!empty($arr)) { 
		foreach($arr as $k=> $v) {
			print_tabs($tabs);
			echo "<b>" . $k . "</b>: &nbsp;" . $v . "<br/>";
			if(is_array($v)) {
				print_array($v, $tabs+1);
			}
		}
	} else { 
		echo "empty<br/>";
	}
}
?>