<?php
include_once("inc.php");


if(isset($_GET["submit"])): 
?>
<h3>Thanks for submitting!</h3>
<pre>
<?php print_array($_GET); ?>
</pre>
<?php endif; ?>


<form method="GET" action="">
<fieldset>
	<legend>Welcome!</legend>
	<p>
		<label for="first_name">First Name</label>
		<input type="text" name="first_name" value="<?php echo isset($_GET["first_name"]) ? $_GET["first_name"] : "" ?>">
	</p>
	<p>
		<label for="first_name">Last Name</label>
		<input type="text" name="last_name" value="<?php echo isset($_GET["last_name"]) ? $_GET["last_name"] : "" ?>">
	</p>
	<input type="submit" name="submit" value="Submit">
</fieldset>
</form>

<h3>Tutorial</h3>
<ol>
	<li>Type in your first name, last name and click submit. The PHP script takes all the name value pairs in the form and pushes it into the global associative array $_GET</li>
	<li>Now type in <pre>" disabled="1</pre> in first name or last name, and submit. Notice on the submission page, the first name input box is disabled. Why does that happen? How should the code below be fixed for this to not happen?</li>
	<li>Notice the URL encoded string appended to the example after you submit a query. With the code below, find a way to manipulate the code so that <pre>Thanks for Submitting</pre> always shows without even submitting a query. How should the code below fixed for this to not happen?</li>
</ol>

