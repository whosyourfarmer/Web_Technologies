<!doctype html>
<html>
<head><title>Show $_SERVER, $_POST, $_GET Variables</title></head>

<style type="text/css">

table { 
	font: 14px monospace;
	line-height:22px;
}

th { 
	text-align:left;
}
</style>

<body>

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


<table>
	<tr><th width="33%">$_SERVER</th><th width="34%">$_POST</th><th width="33%">$_GET</th></tr>
	<tr>
<td valign="top">

<?php print_array($_SERVER); ?>

</td>
<td valign="top">

<?php print_array($_POST); ?>

</td>
<td valign="top">

<?php print_array($_GET); ?>

</td>
	</tr>
</table>

<ul>
	<li>$_SERVER array is initialized by the server, and contains special parameters such as headers, server version.</li>
	<li>The $_POST array is set when a form of method=POST has an action to this page and is submitted.
		<ul>
			<li><a href="?fname=Hello&lname=World">A form with method = POST</a>
				<div>
					<form method="POST" action="">
						<p>
							<label for="fname">First Name</label>
							<input type="text" value="" name="fname">
						</p>
						<p>
							<label for="lname">Last Name</label>
							<input type="text" value="" name="lname">
						</p>
						<p>
							<input type="submit" value="Submit" name="submit">
						</p>
					</form>
				</div>
			</li>
		</ul>
	
	
	
	</li>
	<li> The $_GET array is set when a form of method=GET has an action to this page and is submitted, or a URL of this page has a query.
		<ul>
			<li><a href="?fname=Hello&lname=World">An example of a URL with a GET query</a></li>
			<li><a href="?fname=Hello&lname=World">A form with method = GET</a>
				<div>
					<form method="GET" action="">
						<p>
							<label for="fname">First Name</label>
							<input type="text" value="" name="fname">
						</p>
						<p>
							<label for="lname">Last Name</label>
							<input type="text" value="" name="lname">
						</p>
						<p>
							<input type="submit" value="Submit" name="submit">
						</p>
					</form>
				</div>
			</li>
		</ul>
	
	</li>
</ul>

<h2>Handling Arrays</h2>
<p>PHP also accepts multidimensional arrays as an form input. To create an array, add brackets to end of the name variable. (e.g. time[]). For example, if there is an input named time[], it would be inputted into the time[] array in PHP.</p>
<form method="GET" action="">
	<p>
		<label for="fname">Time 1</label>
		<input type="text" value="" name="time[]">
	</p>
	<p>
		<label for="fname">Time 2</label>
		<input type="text" value="" name="time[]">
	</p>
	<p>
		<label for="fname">Time 3</label>
		<input type="text" value="" name="time[]">
	</p>
	<p>
		<input type="submit" value="Submit" name="submit">
	</p>
</form>

</body>
</html>