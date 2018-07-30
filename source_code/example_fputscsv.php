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


<h1>Browser Survey</h1>

<?php if(isset($_POST["submit"])): ?>
<?php if(!isset($_POST["ms"])): ?>
<p style="color:red;">Please select something.</p>
<?php else: ?>
<h1>Thanks for submitting!</h1>
<?php
	$acceptable_answers = array("Yes", "No");
	$a = array("No", "No", "No", "No", "No"); 
	foreach($_POST["ms"] as $k => $v) {
		if(in_array($v, $acceptable_answers)) { 
			$a[$k] = $v; 
		}
	}
	// read the file, convert it to array.
	$fh= fopen("survey.csv", "r") or die("can't open file");
	$answers = array();
	$i = 0;
	while(! feof($fh))
	{
		$arr = fgetcsv($fh);
		if($arr) { 
			$answers[$i++] = $arr;
		}
	}
	fclose($fh);
	// write newest entry.
	$fh= fopen("survey.csv", "w") or die("can't open file");
	array_push($answers, $a);
	foreach($answers as $answer) { 
		fputcsv($fh, $answer);
	}
	fclose($fh);
?>

<?php endif; ?>

<?php 
	function count_entries($index, $value) { 
		global $answers;
		$count = 0;
		foreach($answers as $answer) { 
			if($answer[$index] == $value) { 
				$count++;
			}
		}
		return $count; 
	}
	
	$number_of_entries = count($answers);
	$ie_like_percent = count_entries(0, "Yes") / $number_of_entries;
	$ff_like_percent = count_entries(1, "Yes") / $number_of_entries;
	$chrome_like_percent = count_entries(2, "Yes") / $number_of_entries;
	$opera_like_percent = count_entries(3, "Yes") / $number_of_entries;
	$safari_like_percent = count_entries(4, "Yes") / $number_of_entries;
	
?>

<style type="text/css">
	div { 
		text-align:center;
		color:white;
		font-weight:800;
	}
</style>

<h2>Here are the results:</h2>

<b>Internet Explorer</b>
<div style="width:<?php echo $ie_like_percent*100; ?>%; background:gray;height:30px;">
<?php echo round($ie_like_percent*100); ?>%
</div>

<b>Firefox</b>
<div style="width:<?php echo $ff_like_percent*100; ?>%; background:gray;height:30px;">
<?php echo round($ff_like_percent*100); ?>%
</div>

<b>Chrome</b>
<div style="width:<?php echo $chrome_like_percent*100; ?>%;background:gray;height:30px;">
<?php echo round($chrome_like_percent*100); ?>%
</div>

<b>Opera</b>
<div style="width:<?php echo $opera_like_percent*100; ?>%; background:gray;height:30px;">
<?php echo round($opera_like_percent*100); ?>%
</div>

<b>Safari</b>
<div style="width:<?php echo $safari_like_percent*100; ?>%;background:gray;height:30px;">
<?php echo round($safari_like_percent*100); ?>%
</div>

<?php endif; ?>

<form method="POST">
	<p>
		<label>Do you like Internet Explorer?</label><br/>
		<input type="radio" name="ms[0]" value="Yes" checked> Yes<br/>
		<input type="radio" name="ms[0]" value="No"> No<br/>
	</p>
		<p>
		<label>Do you like Firefox?</label><br/>
		<input type="radio" name="ms[1]" value="Yes"  checked> Yes<br/>
		<input type="radio" name="ms[1]" value="No"> No<br/>
	</p>
		<p>
		<label>Do you like Chrome?</label><br/>
		<input type="radio" name="ms[2]" value="Yes"  checked> Yes<br/>
		<input type="radio" name="ms[2]" value="No"> No<br/>
	</p>
		<p>
		<label>Do you like Opera?</label><br/>
		<input type="radio" name="ms[3]" value="Yes"  checked> Yes<br/>
		<input type="radio" name="ms[3]" value="No"> No<br/>
	</p>
	<p>
		<label>Do you like Safari?</label><br/>
		<input type="radio" name="ms[4]" value="Yes"  checked> Yes<br/>
		<input type="radio" name="ms[4]" value="No"> No<br/>
	</p>
	<input type="submit" name="submit" value="submit" />
</form>


<h3>fgetscsv & fputscsv CSV Example</h3>

<ul>
	<li>The user fills out a survey which is set as an array of answers.</li>
	<li>Then, the PHP script reads <code>(fgetscsv)</code> the CSV file and appends the recently submitted answers to the array that fgetscsv produces. </li>
	<li>Using the array obtained from <code>fgetscsv</code>, we can display results using <code>count</code></li>
	<li>Afterward, the PHP script writes back to the CSV file using <code>fputcsv</code>.</li>
	<li>Challenge: See if you can optimize the code.</li>
</ul>