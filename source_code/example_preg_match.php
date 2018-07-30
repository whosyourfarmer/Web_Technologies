<style type="text/css">
	a:link, a:visited { text-decoration: none; color: black;}
	a:hover { background:yellow; } 
</style>
<h2>Where are the secret links?</h2>
<?php 
$html = <<< HTML
<p>Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo. Quisque sit amet <a href="http://www.google.com">est</a> et sapien ullamcorper pharetra. Vestibulum erat wisi, condimentum sed, commodo vitae, ornare sit amet, wisi. Aenean fermentum, elit eget tincidunt condimentum, eros ipsum rutrum orci, sagittis tempus lacus enim ac dui. Donec non enim in turpis pulvinar facilisis. <a href="http://www.yahoo.com">Ut felis</a>. Praesent dapibus, neque id cursus faucibus, tortor neque egestas augue, eu vulputate magna eros eu erat. <a href="http://www.usc.edu">Aliquam erat volutpat</a>. Nam dui mi, tincidunt quis, accumsan porttitor, facilisis luctus, metus</p>
HTML;
echo $html;
?>
<form method="POST">
	<input type="submit" value="Give me a Hint!" name="submit" />
</form>

<?php if(isset($_POST["submit"])): ?>
<?php 
/**
* Returns the URL and the innerText contained the anchor tag in an associative array
*/
function get_link_contents($html) {
	$results = array(); 
	
	$regexp = '<a [^>]*href="([^"]+)"[^>]*>(.*)<\/a>';
	if(preg_match_all("/$regexp/siU", $html, $matches)) {
		$results["innerText"] = $matches[2];
		$results["href"] = $matches[1];
	}
	
	return $results; 
}

$hints = get_link_contents($html);
?>
<h2>Hints:</h2>
<?php foreach($hints["innerText"] as $hintKey => $hintValue): ?>
<p>
	<b>Text:</b> <?php echo $hintValue; ?><br/>
	<b>Link:</b> <?php echo $hints["href"][$hintKey]; ?>
</p>
<?php endforeach; ?>
<?php endif; ?>

<h2><code>preg_match</code> Example</h2>
<ul>
	<li>The script looks for all links using <code>preg_match_all</code></li>
	<li><code>preg_match_all</code> returns only a TRUE or a FALSE</li>
	<li>To use the match information, specify a third argument, which would be an array of your choosing, such as <code>$matches.</code></li>
</ul>