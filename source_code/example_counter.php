<?php
$ourFileName = "counter.txt";
$ourFileHandle = fopen($ourFileName, "r") or die("can't open file");
$num = fread($ourFileHandle, filesize($ourFileName));
fclose($ourFileHandle);
$ourFileHandle = fopen($ourFileName,"w") or die("can't open file");
$num++;
echo "<h1>Welcome Visitor #" . $num . "</h1>";
fwrite($ourFileHandle, $num);
fclose($ourFileHandle);
?>

<h3>Simple Counter PHP Example</h3>

<ol>
	<li>The PHP script reads in the txt file and gets the current value.</li>
	<li>Then, it increments that current value by 1, prints out the visitor #, and writes it to the file.</li>
</ol>