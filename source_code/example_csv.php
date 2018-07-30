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

<div style="font-family:monospace;">
<?php
$fh= fopen("sample.csv", "r") or die("can't open file");
$names = array();
$i = 0;
while(! feof($fh))
{
	$names[$i++] = fgetcsv($fh);
}
fclose($fh);

print_array($names); 
?>
</div>

<h3>Simple CSV Example</h3>

<ul>
	<li>The PHP Script opens the sample.csv using the <code>fopen</code> file handler.</li>
	<li>The file handler, this can be passed to <code>fgetscsv($file_handle)</code>, which will turn the file handler into an array. (Essentially fgetscsv will turn the file into a string which will then be passed to <code>strgetcsv</code> or an <code>explode</code> function)</li>
	<li><code>while(! feof($fh)) { $names[$i++] = fgetcsv($fh); }</code> is creating an array for each line break in the CSV file.</li>
</ul>