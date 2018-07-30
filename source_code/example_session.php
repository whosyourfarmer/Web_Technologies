<?php 
	session_start();
	if(isset($_POST["submit"])) { 
		$_SESSION["fname"] = $_POST["fname"];
		$_SESSION["lname"] = $_POST["lname"];
	}
	if(isset($_POST["logout"])) { 
		session_destroy();
		unset($_SESSION);
	}
?>

<?php if(!(isset($_SESSION["fname"],$_SESSION["lname"]))): ?>
<h1>Login</h1>

<form method="POST">
<p>
	<label for="username">First Name:</label>
	<input type="text" name="fname" />
</p>

<p>
	<label for="lname">Last Name:</label>
	<input type="text" name="lname" />
</p>

<p>
	<input type="submit" name="submit" value="Submit">
</p>
</form>

<?php else: ?>
<h1>Welcome, <?php echo ucwords($_SESSION["fname"] . " " . $_SESSION["lname"]); ?>
<form method="POST">
	<input type="submit" name="logout" value="logout">
</form>
<?php endif; ?>

<h2>Simple Login and Logout Example</h2>
<ul>
	<li>Everytime an authorization needs to be made in PHP, it is best to use <code>$_SESSION</code> to create a private <code>$_SESSION</code>  to the client and the server.</li>
	<li>To initialize a session, <code>session_start()</code>  needs to be called in the <b>very first line of your PHP file.</b></li>
	<li>To destroy a session (logout), <code>session_destroy()</code>  needs to be called. Don't forget to also call <code>unset($_SESSION);</code> or else the <code>$_SESSION</code> variables are not destroyed yet until the user closes the browser.</li>
</ul>