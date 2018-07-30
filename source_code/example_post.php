<?php
include_once("inc.php");

if(isset($_POST["submit"])): 
?>
<h3>Thanks for submitting!</h3>
<pre>
<?php print_array($_POST); ?>
</pre>
<?php endif; ?>


<form method="POST" action="">
<fieldset>
	<legend>Welcome!</legend>
	<p>
		<label for="first_name">First Name</label>
		<input type="text" name="first_name" value="<?php echo isset($_POST["first_name"]) ? $_POST["first_name"] : "" ?>">
	</p>
	<p>
		<label for="first_name">Last Name</label>
		<input type="text" name="last_name" value="<?php echo isset($_POST["last_name"]) ? $_POST["last_name"] : "" ?>">
	</p>
	<input type="submit" name="submit" value="Submit">
</fieldset>
</form>

<h3>Tutorial</h3>
<ol>
	<li>Type in your first name, last name and click submit. The PHP script takes all the name value pairs in the form and pushes it into the global associative array $_POST</li>
	<li>Now type in <pre>" disabled="1</pre> in first name or last name, and submit. Notice on the submission page, the first name input box is disabled. Why does that happen? How should the code below be fixed for this to not happen?</li>
	<li>Notice that in $_POST, nothing is appended to the URL query. How would this be better than $_GET?</li>
</ol>

