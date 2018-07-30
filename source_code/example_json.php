<?php 
if(isset($_POST["result"])): 
	$results = $_POST["result"]; 
	
	$moviesResults = new SimpleXMLElement("<rsp stat=\"ok\"><results></results></rsp>");
	$moviesResults->results->addAttribute('total', count($results));

	foreach($results as $result) { 
		$movieResult = $moviesResults->results->addChild('result', '');
		$movieResult->addAttribute('title', $result['title']);
		$movieResult->addAttribute('year', $result['year']);
		$movieResult->addAttribute('director', $result['director']);
		$movieResult->addAttribute('rating', $result['rating']);
	}
endif;

?>

<?php if(isset($_POST["result"])):  ?>
<h2>Here's the JSON:</h2>
<pre>
<?php echo json_encode($_POST["result"]); ?>
</pre>
<?php endif; ?>

<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>

<script>
$(function() {
	var $i = 0; 
	$last = $("#orig");
	$("#add-more").click(function(e) {
		$i++; 
		$clone = $("#orig").clone();
		
		$title = $clone.find(".title");
		$year = $clone.find(".year");
		$director = $clone.find(".director");
		$rating = $clone.find(".rating");
		
		$title.attr("name", "result["+$i+"][title]");
		$year.attr("name", "result["+$i+"][year]");
		$director.attr("name", "result["+$i+"][director]");
		$rating.attr("name", "result["+$i+"][rating]");
		
		$last.after($clone);
		$last = $clone;
		e.preventDefault();
		return false;
	});
});
</script>
<form method="POST">
	<fieldset id="orig">
		<legend>Enter Movie Details</legend>
	<p>
		<label for="title">Title</label>
		<input type="text" name="result[0][title]" class="title" />
	</p>
	<p>
		<label for="year">Year</label>
		<input type="text" name="result[0][year]" class="year" />
	</p>
	<p>
		<label for="director">Director</label>
		<input type="text" name="result[0][director]" class="director" />
	</p>
	<p>
		<label for="director">Rating</label>
		<input type="text" name="result[0][rating]" class="rating" />
	</p>
	</fieldset>
	<p>
		<button id="add-more">add more movies</button>
	</p>
	<p>
		<input type="submit" value="submit" name="submit" />
	</p>
</form>

<h3>Movies Example JSON</h3>

<ul>
	<li>The user fills out a form containing movie details. Each movie has is defined by an array called result[i]. Also, for each parameter of the movie details, there is a key specified, e.g. Director => result[i][director]. (i increases as add more movies is clicked)</li>
	<li>Once the user clicks submit, the JSON is produced using <code>json_encode</code></li>
</ul>

